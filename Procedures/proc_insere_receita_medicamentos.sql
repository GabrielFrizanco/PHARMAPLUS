create or replace procedure "PROC_INSERE_RECEITA_MEDICAMENTOS"(p_cpf in varchar2, p_nm_pessoa in varchar2)
as

-- cursor receita_auxiliar
cursor r1 is
    select r.id_rct,
           r.ds_rct,
           r.cpf_cliente,
           r.nm_medico,
           r.id_posto
    from receita_auxiliar r;

-- cursor medicamentos_auxiliar
cursor m1 is
    select m.cod_prod,
           m.cpf_cliente,
           m.nm_prod,
           m.qtd_prod,
           m.id_rct,
           m.lote
    from medicamentos_auxiliar m;

    v_cont number := 0;
    v_contar_registro number := 0;
    v_id_func number := 0;
    v_nome_prod varchar2(100) := null;
    v_desc_reg varchar2(120) := null;

begin
    -- se caso não existir nenhum medicamento, não será possivel criar a receita
    select count(*) into v_contar_registro
    from medicamentos_auxiliar;

    -- funcionário que registrou a retirada
    select u.id_func into v_id_func
    from usuarios u
    where upper(u.usuario)=upper(v('APP_USER'));

    if v_contar_registro > 0 then
        for r2 in r1 loop

            -- adicionar receita
            insert into receitas(id_rct, ds_rct, nm_medico, cpf_cliente, id_posto, dta_ped, nm_pessoa, id_func)
            values(r2.id_rct, r2.ds_rct, r2.nm_medico, r2.cpf_cliente, r2.id_posto, sysdate, p_nm_pessoa, v_id_func);

            delete from receita_auxiliar
            where id_rct = r2.id_rct;

        end loop;

        for m2 in m1 loop
            select ds_prod into v_nome_prod
            from produtos
            where cod_prod = m2.cod_prod;

            -- adicionar medicamentos
            insert into receitas_produtos(cod_prod, id_rct, qtd_prod, cod_lote)
            values (m2.cod_prod, m2.id_rct, m2.qtd_prod, m2.lote);

            -- inserir registro no log
            v_desc_reg := 'Foi retirado -'||m2.qtd_prod|| ' ' ||v_nome_prod||' do estoque. Lote Usado: '||m2.lote;
            
            insert into registro (usuario, data, ds_reg, tipo)
            values (v_id_func, sysdate, v_desc_reg, 'Saída');

            delete from medicamentos_auxiliar
            where id_rct = m2.id_rct;

        end loop;


        -- se caso sobrar medicamentos, vai devolver para o estoque
        select count(*) into v_cont
        from medicamentos_auxiliar;

        if v_cont > 0 then
            for m3 in m1 loop

                update estoque set
                quant = (quant+m3.qtd_prod)
                where cod_prod = m3.cod_prod;

            end loop;
            commit;
        end if;

    end if;

    -- excluir dados existente nas tabelas auxiliares
    -- receita
    delete from receita_auxiliar;
    commit;

    -- medicamentos
    delete from medicamentos_auxiliar;
    commit;

end "PROC_INSERE_RECEITA_MEDICAMENTOS";
/