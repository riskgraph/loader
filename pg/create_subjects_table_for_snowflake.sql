--

CREATE TABLE subjects (
    subjid      integer,                  -- SUBJID a runnig number from 1 to infinity
    diagtype    varchar,                  -- diagnosis type
    ab          float DEFAULT 0,          -- AB  At bats : number of observations of tumor
    hits        float DEFAULT 0,          -- Numerator for obp, 'SD', 'PR', 'CR'
    slugs       float DEFAULT 0,          -- Numerator for slg,  2PR + 4CR
    obp         float DEFAULT 0,          -- OBP = hits/AB
    slg         float DEFAULT 0,          -- SLG = slugs/AB
    efficacy    float DEFAULT 0,          -- Efficacy = OBP + SLG  (LIKE OPS)
    events      float DEFAULT 0,          -- Count of adverse events by severity
    safety      float DEFAULT 0,          -- Safety = events/AB
    outs        float DEFAULT 0,          -- Count of ALP and ALB out of their normql ranges
    toxicity    float DEFAULT 0           -- Toxicity = outs/AB
);
