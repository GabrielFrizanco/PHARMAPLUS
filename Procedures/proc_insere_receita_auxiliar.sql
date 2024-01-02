create or replace procedure "PROC_INSERE_RECEITA_AUXILIAR"(p_descricao in varchar2,
                                                           p_cpf in varchar2,
                                                           p_posto in number,
                                                           p_medico in varchar2)
as

    v_id_rct receita_auxiliar.id_rct%type;
    v_cont number := 0;

begin

    select count(*) into v_cont
    from receita_auxiliar;

    if v_cont > 0 then
        delete from receita_auxiliar;
        commit;
    end if;

    -- id_seq ele pega sequencia de valores de 1 em 1, e insere como valor de PK 
    v_id_rct := id_seq.NEXTVAL;
    
    -- insere na tabela auxiliar
    insert into receita_auxiliar(id_rct, ds_rct, nm_medico, cpf_cliente, id_posto)
    values(v_id_rct, p_descricao, p_medico, p_cpf,  p_posto);

    commit;
    
end "PROC_INSERE_RECEITA_AUXILIAR";
/