create or replace procedure "PROC_INSERE_QUANT_MEDICAMENTO"(p_cpf in varchar2, 
                                                            p_cod_prod in number,
                                                            p_lote in number,
                                                            p_quant in number)
as
    -- declarando as variáveis necessárias
    v_qtd_prod estoque.quant%type;
    v_produto produtos.ds_prod%type;
    v_cod_med medicamentos_auxiliar.id%type;
    v_id_rct receitas.id_rct%type;

begin
    -- informando a quantidade de produto que tem no lote escolhido
    select quant into v_qtd_prod
    from estoque 
    where codigo = p_lote;

    -- pega o nome do produto
    select ds_prod into v_produto
    from produtos
    where cod_prod = p_cod_prod;

    -- codigo 
    select count(*)+1 into v_cod_med
    from medicamentos_auxiliar;

    -- id_receita
    select id_rct into v_id_rct
    from receita_auxiliar;


    -- se for inserido uma quantidade maior do esperado, ele não adiciona na tabela auxiliar
    if p_quant <= v_qtd_prod then
        insert into medicamentos_auxiliar (id_rct, id, cod_prod, cpf_cliente, nm_prod, qtd_prod, lote)
        values (v_id_rct, v_cod_med, p_cod_prod, p_cpf, v_produto, p_quant, p_lote);

        update estoque set
        quant = (v_qtd_prod-p_quant)
        where codigo = p_lote;
                
    else
        null;
    end if;

end "PROC_INSERE_QUANT_MEDICAMENTO";
/