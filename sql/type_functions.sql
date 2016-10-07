--
-- Check if the operator is a valid topological relationship
--
CREATE FUNCTION _ast_isTopologicalRelationship(operator text) RETURNS BOOLEAN AS $$
DECLARE
   tr _ast_topologicalrelationship;
BEGIN
   tr := operator;
   RETURN TRUE;
EXCEPTION
   WHEN invalid_text_representation THEN
      RETURN FALSE;
END;
$$  LANGUAGE plpgsql;
