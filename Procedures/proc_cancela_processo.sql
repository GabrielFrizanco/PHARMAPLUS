create or replace procedure "PROC_CANCELA_PROCESSO"
as

cursor m1 is
    select m.cod_prod,
           m.cpf_cliente,
           m.qtd_prod,
           m.id,
           m.id_rct
    from medicamentos_auxiliar m;

begin

    for m2 in m1 loop

        update estoque set
        quant = (quant+m2.qtd_prod)
        where cod_prod = m2.cod_prod;

    end loop;

    delete from medicamentos_auxiliar;
    commit;

    delete from receita_auxiliar;
    commit;
    
end "PROC_CANCELA_PROCESSO";
/