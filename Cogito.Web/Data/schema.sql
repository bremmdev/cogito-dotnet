-- Cogito — database schema.
--
-- The single source of truth for the structure. `PRAGMA user_version` below is the version
-- stamp: bump it in the same commit as any change here, so a database file and this script can
-- always be checked against each other.
--
-- Two things this script deliberately does not create:
--   * The FTS5 *shadow* tables (entry_fts_data, entry_fts_idx, entry_fts_docsize,
--     entry_fts_config). SQLite creates them itself when the virtual table is declared, so a
--     script that tries to create them fails. sqlite_sequence and sqlite_stat1 are likewise
--     SQLite's own bookkeeping. This is why a raw `.schema` dump will not replay as-is.
--   * Any `user` row. Accounts carry a password hash and a salt, and are created by the
--     application, not by the schema.
--
-- The mood vocabulary *is* seeded here: `sentiment` is what every filter and insight
-- aggregates by, so those eight rows are structure, not sample data.
--

PRAGMA foreign_keys = OFF;   -- deferred until every table exists
BEGIN;

PRAGMA user_version = 1;

-- ---------------------------------------------------------------------------
-- Reference data
-- ---------------------------------------------------------------------------

-- A controlled vocabulary. An entry has no sentiment of its own — it is classified
-- transitively, through its mood.
CREATE TABLE mood (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT NOT NULL,
    sentiment TEXT NOT NULL              -- 'positive' | 'neutral' | 'negative'
);

CREATE TABLE tag (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

-- UNIQUE lives in the index rather than the column: SQLite implements a UNIQUE column
-- constraint as exactly this, and an index can be swapped without rebuilding the table.
-- Note the consequence — the CREATE TABLE above says nothing about uniqueness, so reading
-- the table definitions alone does not tell you what is enforced.
CREATE UNIQUE INDEX idx_tag_name  ON tag(name);
CREATE UNIQUE INDEX idx_mood_name ON mood(name);

-- ---------------------------------------------------------------------------
-- Journal
-- ---------------------------------------------------------------------------

CREATE TABLE entry (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    date    TEXT NOT NULL,               -- 'YYYY-MM-DD'; ISO-8601 sorts chronologically
    title   TEXT NOT NULL,
    content TEXT NOT NULL,               -- sanitized HTML
    mood_id INTEGER,
    -- SET NULL, not CASCADE: retiring a mood must never destroy journal entries.
    FOREIGN KEY (mood_id) REFERENCES mood(id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- A pure junction table: no payload beyond its two key columns, so the composite primary key
-- doubles as the entry -> tags index and makes a duplicate pair impossible. WITHOUT ROWID
-- makes the table itself that B-tree, so a lookup is one descent rather than two.
CREATE TABLE entry_tag (
    entry_id INTEGER NOT NULL,
    tag_id   INTEGER NOT NULL,
    PRIMARY KEY (entry_id, tag_id),
    FOREIGN KEY (entry_id) REFERENCES entry(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tag_id)   REFERENCES tag(id)   ON UPDATE CASCADE ON DELETE CASCADE
) WITHOUT ROWID;

-- The reverse direction (tag -> entries); the primary key already covers the forward one.
CREATE INDEX idx_entrytag_tag_id ON entry_tag(tag_id);

-- ---------------------------------------------------------------------------
-- Full-text search
-- ---------------------------------------------------------------------------

-- External content: the index stores terms only and reads through to `entry` for the text,
-- so there is no second copy to drift. The cost is that SQLite will not maintain it — the
-- three triggers below do.
CREATE VIRTUAL TABLE entry_fts USING fts5(
    title,
    content,
    content='entry',
    content_rowid='id'
);

CREATE TRIGGER entry_ai AFTER INSERT ON entry BEGIN
    INSERT INTO entry_fts(rowid, title, content) VALUES (NEW.id, NEW.title, NEW.content);
END;

-- The 'delete' command must be given the OLD column values, not just the rowid: FTS5 needs
-- them to know which term entries to retract. Getting this wrong corrupts the index in a way
-- that only shows up later, as wrong search results.
CREATE TRIGGER entry_ad AFTER DELETE ON entry BEGIN
    INSERT INTO entry_fts(entry_fts, rowid, title, content)
    VALUES ('delete', OLD.id, OLD.title, OLD.content);
END;

CREATE TRIGGER entry_au AFTER UPDATE ON entry BEGIN
    INSERT INTO entry_fts(entry_fts, rowid, title, content)
    VALUES ('delete', OLD.id, OLD.title, OLD.content);
    INSERT INTO entry_fts(rowid, title, content) VALUES (NEW.id, NEW.title, NEW.content);
END;

-- ---------------------------------------------------------------------------
-- Quotes
-- ---------------------------------------------------------------------------

CREATE TABLE quote (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    author  TEXT
);

-- The collation must match the query's ORDER BY ... COLLATE NOCASE or the index is ignored.
CREATE INDEX idx_quote_author_nocase ON quote(author COLLATE NOCASE);

-- ---------------------------------------------------------------------------
-- Auth — present in the schema, deliberately unused until the auth phase.
-- ---------------------------------------------------------------------------

CREATE TABLE user (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    username     TEXT UNIQUE,
    passwordhash TEXT,                   -- hex-encoded
    salt         TEXT,                   -- per-user, hex-encoded
    role         TEXT                    -- 'user' | 'admin'
);

-- WITHOUT ROWID so the table *is* the session_id B-tree: the lookup on every navigation is
-- one descent, and no secondary index on session_id is needed or wanted.
CREATE TABLE session (
    session_id TEXT PRIMARY KEY,
    user_id    INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    expires_at TEXT NOT NULL,            -- full ISO-8601 timestamp
    FOREIGN KEY (user_id) REFERENCES user(id)
) WITHOUT ROWID;

-- ---------------------------------------------------------------------------
-- Mood vocabulary (structure, not sample data)
-- ---------------------------------------------------------------------------

INSERT INTO mood (id, name, sentiment) VALUES
    (1, 'frustrated', 'negative'),
    (2, 'depressed',  'negative'),
    (3, 'grateful',   'positive'),
    (4, 'happy',      'positive'),
    (5, 'neutral',    'neutral'),
    (6, 'proud',      'positive'),
    (7, 'sad',        'negative'),
    (8, 'determined', 'positive');

COMMIT;
PRAGMA foreign_keys = ON;
