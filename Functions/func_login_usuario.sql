create or replace FUNCTION FUNC_LOGIN_USUARIO(p_usuario IN VARCHAR2, p_senha IN VARCHAR2) 
RETURN BOOLEAN
AS
MVAL NUMBER := 0;
BEGIN
select count(*) into mval from usuarios u
where u.usuario = p_usuario and
      u.senha = p_senha and
      u.status = 'Y';
if mval > 0 then
    return true;
end if;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN FALSE;

END;
/