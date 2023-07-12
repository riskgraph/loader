--
-- Utility views for the project
--
-- 7/2023
-- Compute at bats and update the subjects table
--
create or replace view atbats  AS
  select subjid, count(*) from rsp  group by subjid;

create or replace view hits AS
  select subjid, count(*) from rsp WHERE rsshort IN ('SD', 'PR', 'CR') group by subjid;

create or replace view compute_slg_numerator AS
  SELECT
      subjid,
      SUM(
          CASE
              WHEN rsshort = 'PR' THEN 2
              WHEN rsshort = 'CR' THEN 4
              ELSE 0
          END
      ) AS slg_numerator
  FROM rsp
  GROUP BY subjid;

  create or replace view compute_safety_numerator AS
      select subjid,count(aesevcd) from ae group by subjid;


  create or replace view compute_toxicity_numerator AS
    select subjid,count(lbshort) from lb WHERE lbshort IN ('ALP','ALB') AND outNormal = 't'  group by subjid;
/*
CREATE or replace view scaled_composite_metric
SELECT
    subjid,
    (composite - min_composite) / (max_composite - min_composite) AS scaled_composite
FROM
    (SELECT
        subjid,
        composite,
        MIN(composite) OVER () AS min_composite,
        MAX(composite) OVER () AS max_composite
     FROM subjects) AS subquery;
*/
