DROP TABLE rsp CASCADE;
CREATE TABLE rsp (
    SUBJID INTEGER,
    RSRESP VARCHAR(255),
    VISITDY NUMERIC,
    VISIT VARCHAR(255),
    RSCONFYN VARCHAR(255),
    RSTRESP VARCHAR(255),
    RSNTRESP VARCHAR(255),
    RSNEW CHAR(1),
    RSREADER VARCHAR(255)
);

COPY rsp (SUBJID, RSRESP, VISITDY, VISIT, RSCONFYN, RSTRESP, RSNTRESP, RSNEW, RSREADER)
FROM '/tmp/adrsp.csv'
WITH (FORMAT CSV, HEADER);
CREATE index idx_rsp ON rsp(subjid);
/*
Stable disease (SD)
Partial response (PR)
Progressive disease (PD)
Unable to evaluate (UE)
Complete response (CR)
*/

ALTER TABLE rsp add column  rsshort varchar  default '';
UPDATE  rsp set rsshort = 'SD' WHERE RSRESP = 'Stable disease';
UPDATE  rsp set rsshort = 'PR' WHERE RSRESP = 'Partial response';
UPDATE  rsp set rsshort = 'PD' WHERE RSRESP = 'Progressive disease';
UPDATE  rsp set rsshort = 'UE' WHERE RSRESP = 'Unable to evaluate';
UPDATE  rsp set rsshort = 'CR' WHERE RSRESP = 'Complete response';
