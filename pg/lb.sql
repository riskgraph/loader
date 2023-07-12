DROP TABLE lb CASCADE;
CREATE TABLE lb (
    SUBJID INTEGER,
    LBTEST VARCHAR(255),
    LBBASE CHAR(1),
    LBSTRESN NUMERIC,
    LBSTUNIT VARCHAR(255),
    VISITDY NUMERIC,
    VISIT VARCHAR(255)
);

COPY lb (SUBJID, LBTEST, LBBASE, LBSTRESN, LBSTUNIT, VISITDY, VISIT)
FROM '/tmp/adlb.csv'
WITH (FORMAT CSV, HEADER);
CREATE index idx_lb ON lb(subjid);

-- Remove null results
DELETE from lb WHERE  LBSTRESN is null;

-- Convert to g/dL
UPDATE lb set LBSTRESN = LBSTRESN/10, LBSTUNIT= 'g/dL' where LBTEST = 'Albumin';

-- Add an out of normal range flag
ALTER TABLE lb ADD column outNormal boolean;

-- Set flag for ALB and ALP in order to calculate liver toxicity
-- 3.4 <= ALB <= 5.4 g/dL
-- 20 <= ALP <= 140 U/L


-- Add columns for ahortened biomarker ames
ALTER TABLE lb ADD column lbshort  VARCHAR;
-- Set the abbreviations
UPDATE lb set lbshort = 'ALB' WHERE LBTEST = 'Albumin';
UPDATE lb set lbshort = 'ALP' WHERE LBTEST = 'Alkaline Phosphatase';

-- Set out of range flag using short codes
-- default false
UPDATE lb set outNormal = 'f';
UPDATE lb set outNormal = 't' WHERE lbshort = 'ALB' and (LBSTRESN > 1.2*5.4 OR LBSTRESN < .8*3.4);
UPDATE lb set outNormal = 't' WHERE lbshort = 'ALP' and (LBSTRESN > 1.2*140 OR LBSTRESN < .8*20);
