--
-- Utility functions for the project
--
-- 6/2023
-- is_numeric

create or replace function isnumeric(text) returns boolean
as $BODY$
begin
  if $1 is null or rtrim($1)='' then
    return false;
  else
    return (select $1 ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$');
  end if;
end;
$BODY$
 language 'plpgsql';

 CREATE OR REPLACE FUNCTION utility_function (v_from_subjid integer, v_to_subjid integer, m1 float, m2 float, m3 float)
 RETURNS TABLE (subjid integer, efficacy float, safety float, toxicity float, composite float) AS $$
 BEGIN
    RETURN QUERY
    SELECT s.subjid, s.efficacy, s.safety, s.toxicity, (m1*s.efficacy - m2*s.safety - m3*s.toxicity) as composite
    FROM subjects s
    WHERE s.subjid between v_from_subjid AND v_to_subjid AND s.ab is not null
    ORDER BY composite;
 END;
 $$ LANGUAGE plpgsql;
