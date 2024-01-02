create or replace procedure "PROC_INSERE_ESTOQUE"(p_posto in number) as

cursor a1 is
        select a.codigo,
               a.produto,
               a.quantidade,
               a.validade,
               a.entrega,
               a.posto
        from estoque_auxiliar a;

    v_cod produtos.cod_prod%type;
    v_cont number := 0;
    v_id_func estoque.id_func%type;
    v_desc varchar2(120) := null;
    v_novo_codigo number := 0;
    v_contar_lote number := 0;

begin

    for aux1 in a1 loop

        select count(*) into v_contar_lote
        from estoque e
        where e.codigo = aux1.codigo;

        select p.cod_prod into v_cod
        from produtos p
        where p.ds_prod like aux1.produto;


        select u.id_func into v_id_func
        from usuarios u
        where upper(u.usuario) = upper(APEX_APPLICATION.G_USER);

        if aux1.quantidade > 0 and aux1.validade >= sysdate and v_contar_lote = 0 then
            insert into estoque (codigo, cod_prod, nm_prod, valid_prod, dta_entrega, id_posto, quant, id_func)
            values(aux1.codigo, v_cod, aux1.produto, to_date(aux1.validade, 'MM/DD/YYYY'), to_date(aux1.entrega, 'MM/DD/YYYY HH24:MI'), p_posto, aux1.quantidade, v_id_func);

            delete from estoque_auxiliar
            where codigo = aux1.codigo;

            v_desc := 'Foi enviado +'||aux1.quantidade|| ' ' ||aux1.produto||' para o estoque.';
            insert into registro (usuario, data, ds_reg) values (v_id_func, SYSTIMESTAMP, v_desc);

        else
            null;
        end if;
        
        -- para não ficar sobrecarregado o banco, coloquei para ele dar commit a cada 500 registro
        v_cont := v_cont + 1;

        if v_cont >= 500 then
            commit;
            v_cont := 0;
        end if;

    end loop;

commit;

end "PROC_INSERE_ESTOQUE";
/