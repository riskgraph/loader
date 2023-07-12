DROP TABLE subjects;
CREATE TABLE subjects (
    SUBJID    integer,
  --  TRT       varchar,
  --  ATRT      varchar,
  --  B_ECOG    varchar,
    DIAGTYPE  varchar
);
/*
Guessing what the column names mean:
  TRT - treatment
  ATRT - assigned treatment
  B_ECOG" baseline ECOG scale
      0: Fully active, able to carry on all pre-disease performance without restriction
      1: Restricted in physically strenuous activity but ambulatory and able to carry out work of a light or sedentary nature, e.g., light house work, office work
      2: Ambulatory and capable of all self-care but unable to carry out any work activities. Up and about more than 50% of waking hours
      3: Capable of only limited self-care, confined to bed or chair more than 50% of waking hours
      4: Completely disabled. Cannot carry on any self-care. Totally confined to bed or chair
      5: Dead
*/

COPY subjects
FROM '/tmp/subjects.csv'
WITH (FORMAT CSV, HEADER);
CREATE index idx_subjects ON subjects(subjid);
--
-- add columns for metrics calculation and for red flags
--
ALTER TABLE subjects add column customer_id    integer default 0;  -- denominator
ALTER TABLE subjects add column study_id       integer default 0;  -- numerator

ALTER TABLE subjects add column ab    float default 0;  -- denominator
ALTER TABLE subjects add column hits  float default 0;  -- numerator
ALTER TABLE subjects add column slugs  float default 0; -- numerator

-- Efficacy
ALTER TABLE subjects add column obp float default 0; -- hits/ab
ALTER TABLE subjects add column slg float default 0;  -- slugs/slg
ALTER TABLE subjects add column efficacy float default 0;  -- obp + slg
--
-- Adverse events
ALTER TABLE subjects add column events      float default 0;  -- numerator
ALTER TABLE subjects add column safety      float default 0;      -- events/AB
-- toxicity
ALTER TABLE subjects add column outs            float default 0;    -- numerator
ALTER TABLE subjects add column toxicity        float default 0;    -- outs/ab
