--
-- Update subjects table with aggregates so that we can compute the baseball metrics
--
-- 7/2023
--
UPDATE subjects
SET ab = (SELECT count
          FROM atbats
          WHERE subjects.subjid = atbats.subjid);
-- Remofe patiets who did not have treatment
DELETE from subjects where ab is null;

--
UPDATE subjects
SET hits = (SELECT count
          FROM hits
          WHERE subjects.subjid = hits.subjid);
UPDATE subjects SET hits = -1 WHERE hits is null;
--
--
UPDATE subjects SET obp=-1 WHERE hits is null;
UPDATE subjects SET obp = hits/ab WHERE hits is not  null;

--
--
UPDATE subjects
SET slugs = (SELECT slg_numerator
          FROM compute_slg_numerator csn
          WHERE subjects.subjid = csn.subjid);
--
--
UPDATE subjects  SET slg=-1 WHERE hits is null;
UPDATE subjects  SET slg = slugs/ab where ab is not null;

UPDATE subjects
    SET efficacy = obp + slg;
--
--
UPDATE subjects
SET events = (SELECT count
          FROM compute_safety_numerator csn
          WHERE subjects.subjid = csn.subjid);
UPDATE subjects SET events = 0 WHERE events is null;

UPDATE subjects
    SET safety = events/ab;

UPDATE subjects
SET outs = (SELECT count
          FROM compute_toxicity_numerator ctn
          WHERE subjects.subjid = ctn.subjid);

UPDATE subjects   SET toxicity=-1         WHERE outs is null;
UPDATE subjects   SET toxicity = outs/ab  WHERE outs is not null;
