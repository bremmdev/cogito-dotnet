-- Cogito — development seed data. Invented sample entries, for local development only.
--
-- Built to give the app something to exercise: 34 entries across eight months, ten tags, six
-- quotes, one entry with no mood (`mood_id` is nullable), and a vocabulary that repeats on
-- purpose — "morning", "run", "rain", "sleep", "code", "book" — so FTS5 search has something
-- to find. Re-runnable: it clears the tables it owns before inserting.
--
-- Moods are NOT seeded here. The eight-row mood vocabulary is structure, so `schema.sql` seeds
-- it; this file uses those ids and never touches the table. Every one of the eight is used at
-- least once and all three sentiments are well represented, so the sentiment filter has
-- something to filter.

DELETE FROM entry_tag;
DELETE FROM entry;
DELETE FROM tag;
DELETE FROM quote;

INSERT INTO tag (id, name) VALUES
    (1,  'work'),
    (2,  'running'),
    (3,  'reading'),
    (4,  'family'),
    (5,  'health'),
    (6,  'travel'),
    (7,  'coding'),
    (8,  'sleep'),
    (9,  'weather'),
    (10, 'cooking');

-- mood_id: 1 frustrated, 2 depressed, 3 grateful, 4 happy,
--          5 neutral,    6 proud,     7 sad,      8 determined
INSERT INTO entry (id, date, title, content, mood_id) VALUES
    (1,  '2026-01-04', 'First morning of the year',
         'Woke before the alarm for once. The flat was cold and the light was thin, and I sat with coffee for a while without reaching for my phone. A good start, probably meaningless, but I will take it.', 8),
    (2,  '2026-01-09', 'Slow run in the rain',
         'Five kilometres in steady rain. My legs felt like someone else had borrowed them overnight. Still, finishing a run you did not want to start is worth more than a fast one you did.', 6),
    (3,  '2026-01-15', 'The refactor that would not end',
         'Spent the whole day untangling code that I wrote in October and no longer understand. Left a comment for whoever reads it next, which will be me in March, equally confused.', 1),
    (4,  '2026-01-21', 'Bread, second attempt',
         'The loaf came out dense but edible. The kitchen smelled like a proper bakery for an hour, which was the actual point. Cooking is the only thing I do that has an ending.', 4),
    (5,  '2026-01-28', 'Reading again',
         'Finished a book for the first time in months. Nothing profound in it, but the habit of sitting still with a book is one I keep losing and reclaiming.', 3),
    (6,  '2026-02-03', 'Sleep is not optional',
         'Four bad nights in a row and everything feels sharper than it should. Noted, again, that I am a much kinder person on eight hours of sleep.', 7),
    (7,  '2026-02-08', 'Long run along the river',
         'Twelve kilometres, slowly, with the wind behind me on the way out and in my face all the way home. The classic error. Still glad I went.', 6),
    (8,  '2026-02-14', 'Dinner with my parents',
         'They asked about work and I gave the short answer, then the long one. Realised halfway through that I was explaining it to myself more than to them.', 3),
    (9,  '2026-02-19', 'A morning of small tasks',
         'Cleared the backlog of tiny things that had been quietly costing me attention. None of it mattered individually and all of it mattered together.', 8),
    (10, '2026-02-25', 'Grey week',
         'Rain every day since Sunday. The weather has a hold on my mood that I resent and cannot argue away.', 2),
    (11, '2026-03-02', 'Deploy day',
         'Shipped the thing. Watched the logs for an hour like a nervous parent and then went for a walk. Nothing broke, which felt almost anticlimactic.', 6),
    (12, '2026-03-07', 'Reading in the park',
         'First warm afternoon of the year. Sat outside with a book and a coffee and did not check the time once.', 4),
    (13, '2026-03-11', 'Cannot settle',
         'Restless all evening. Started three things and finished none of them. Some days the attention simply is not there and fighting it makes it worse.', 5),
    (14, '2026-03-18', 'Interval session',
         'Six times four hundred metres on the track. My lungs disagreed loudly with the plan. Running fast is a completely different sport to running far.', 8),
    (15, '2026-03-24', 'Notes on a hard bug',
         'The bug was in the code I was most confident about, which is where they always are. Three hours of reading before one line of writing.', 5),
    (16, '2026-03-30', 'Quiet Sunday',
         'Cooked, read, slept in the afternoon. No plans and no guilt about having no plans, which is rarer than it should be.', 5),
    (17, '2026-04-05', 'Train to the coast',
         'Two hours of watching fields go past. I do my best thinking on trains and none of it ever survives the walk to the platform.', 5),
    (18, '2026-04-12', 'Back injury, minor',
         'Tweaked something lifting badly. Not serious, but enough to stop running for a week, which I am taking worse than the injury deserves.', 7),
    (19, '2026-04-17', 'Learning something new',
         'Started reading properly about a language I have avoided for years. Being a beginner again is humbling in a way that is good for me.', 8),
    (20, '2026-04-23', 'A conversation I had been avoiding',
         'Said the thing. It went better than the version I had rehearsed forty times in the shower. They usually do.', 3),
    (21, '2026-04-29', 'Morning swim',
         'The pool at seven is almost empty and the light comes in sideways. Cold water is a shortcut to feeling awake that no coffee matches.', 4),
    (22, '2026-05-06', 'Too much work',
         'Three deadlines converging and no obvious way to move any of them. Wrote everything down, which did not solve it but stopped it circling.', 1),
    (23, '2026-05-13', 'Half marathon, unplanned',
         'Meant to run ten kilometres and simply kept going. The last three were miserable and the finish was the best I have felt in months.', 6),
    (24, '2026-05-19', 'Rain again',
         'A week of weather that makes the flat feel small. Cooked something slow to fill the afternoon and it worked better than expected.', 5),
    (25, '2026-05-26', 'Reading two books at once',
         'One for the morning and one for before sleep. They keep leaking into each other and I am not sure that is a bad thing.', 5),
    (26, '2026-06-02', 'Sleep experiment, week one',
         'Same bedtime seven nights running. The difference by day four was not subtle. Annoying how boring the useful things turn out to be.', 6),
    (27, '2026-06-11', 'Code review that stung',
         'Fair comments, all of them, and I still had to walk around the block before replying. Then I fixed everything they mentioned.', 1),
    (28, '2026-06-17', 'Family weekend',
         'Everyone in one house for three days. Loud, exhausting, and I would not have missed it.', 4),
    (29, '2026-06-24', 'Running without a watch',
         'Left the watch at home and ran by feel. Slower, probably. Much better morning for it.', 4),
    (30, '2026-07-01', 'Halfway through the year',
         'Read back through six months of these. The mood swings look smaller written down than they felt at the time, which is the whole point of writing them.', 5),
    (31, '2026-07-08', 'Heat',
         'Too hot to run, too hot to think. Worked with the blinds down and got almost nothing done.', 1),
    (32, '2026-07-16', 'Small kitchen victory',
         'Finally made the sauce properly, after four attempts and one very patient phone call. Cooking rewards stubbornness more than talent.', 6),
    (33, '2026-07-27', 'Nothing much happened',
         'A completely unremarkable day and I am writing it down anyway. The entries I regret skipping are always these ones.', NULL),
    (34, '2026-08-04', 'Starting something',
         'Began learning a new stack properly rather than skimming it. The plan is boring and slow, and that is exactly why I think it will work.', 8);

INSERT INTO entry_tag (entry_id, tag_id) VALUES
    (1, 5), (1, 9),
    (2, 2), (2, 9),
    (3, 1), (3, 7),
    (4, 10),
    (5, 3),
    (6, 8), (6, 5),
    (7, 2),
    (8, 4),
    (9, 1),
    (10, 9),
    (11, 1), (11, 7),
    (12, 3), (12, 9),
    (13, 5),
    (14, 2), (14, 5),
    (15, 7), (15, 1),
    (16, 10), (16, 3),
    (17, 6),
    (18, 5), (18, 2),
    (19, 3), (19, 7),
    (20, 4),
    (21, 5),
    (22, 1),
    (23, 2),
    (24, 9), (24, 10),
    (25, 3), (25, 8),
    (26, 8), (26, 5),
    (27, 1), (27, 7),
    (28, 4),
    (29, 2),
    (30, 3),
    (31, 9), (31, 1),
    (32, 10), (32, 4),
    (33, 8),
    (34, 7), (34, 3);

INSERT INTO quote (id, content, author) VALUES
    (1, 'The unexamined life is not worth living.', 'Socrates'),
    (2, 'We suffer more often in imagination than in reality.', 'Seneca'),
    (3, 'You have power over your mind, not outside events. Realise this, and you will find strength.', 'Marcus Aurelius'),
    (4, 'It is not that we have a short time to live, but that we waste a lot of it.', 'Seneca'),
    (5, 'How we spend our days is, of course, how we spend our lives.', 'Annie Dillard'),
    (6, 'The obstacle is the way.', NULL);
