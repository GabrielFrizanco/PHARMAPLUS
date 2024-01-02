create or replace procedure "PROC_DESCARTAR"(p_lista in varchar2, p_produto in varchar2) as

begin

    if instr(p_lista, 10) > 0 then
        delete from estoque
        where valid_prod < sysdate and
              nm_prod = p_produto;
    end if;

    if instr(p_lista, 20) > 0 then
        delete from estoque
        where quant = 0 and
              nm_prod = p_produto;
    end if;

    commit;

end "PROC_DESCARTAR";
/