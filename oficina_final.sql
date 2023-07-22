-- CRIANDO AS ESTRUTURAS DAS TABELAS

-- Criando tabela Cliente
create table cliente(
	idCliente int auto_increment primary key,
    pNome varchar(20) not null,
    uNome varchar(20) not null,
    cpf char(11) not null,
    endereco varchar(45),
    contato varchar(45),
    constraint cliente_unique unique (CPF)
    );

-- Criando tabela Veiculo
create table veiculo(
	idVeiculo int auto_increment primary key,
    idCliente int not null,
    modelo varchar(20) not null,
    marca varchar(20) not null,
    ano int,
    placa char(7) not null,
    chassi varchar(20) not null,
    constraint veiculo_unique unique (placa, chassi),
    constraint fk_cliente foreign key (idCliente) references cliente(idCliente)
    );
    
-- criando tabela Ordem de Servico
create table os(
	idOs int auto_increment primary key,
    idVeiculo int not null,
    dtEmissao DATE,
    dtEntrega DATE not null,
    status_os ENUM('aguardando', 'processando', 'finalizada') not null,
    constraint fk_veiculo foreign key (idVeiculo) references veiculo(idVeiculo)
    );
    
-- criando tabela Equipe/Serviço
create table servico(
	idServico int auto_increment primary key,
    especialidade ENUM('concerto', 'revisão') not null,
    valor float not null
    );

-- criando tabela mecanicos
create table mecanico(
	idMecanico int auto_increment primary key,
    idServico int not null,
    pNome varchar(45) not null,
    uNome varchar(45) not null,
    especialidade ENUM('concerto', 'revisão'),
    endereco varchar(45),
    constraint fk_servico foreign key (idServico) references servico(idServico)
    );
    

-- criando tabela Produtos
create table produto(
	idProduto int auto_increment primary key,
    nProduto varchar(45) not null,
    descricao varchar(45),
    valor float not null
    );
    
-- criando n:m servico por ordem de servico
create table servicos_por_os(
	idOs int not null,
    idServico int not null,
    constraint fk_servico_os foreign key (idOs) references os(idOs),
    constraint fk_servico_servico foreign key (idServico) references servico(idServico)
    );

-- criando n:m produto por OS
create table produtos_na_os(
	idOs int not null,
    idProduto int not null,
    quantidade int not null,
    constraint fk_produto_os foreign key (idOs) references os(idOs),
    constraint fk_produto_produto foreign key (idProduto) references produto(idProduto)
    );


-- INSERINDO DADOS NAS TABELAS

-- inserindo clientes
insert into cliente (pNome, uNome, cpf, endereco, contato)
	values
	('Joao', 'Silva', '12345678900', 'RUA 1, NUMERO 2', '+551935353535'),
    ('Jose', 'Souza', '09876543211', 'RUA 1, NUMERO 3', '+5511999999999'),
    ('Maria', 'Lima', '11234567890', 'RUA 2, NUMERO 2', '+5519998765432'),
    ('Mohamed', 'Afif', '00987654321', 'RUA 2, NUMERO 1', '+551132123212');

-- inserindo veiculos 
insert into veiculo (idCliente, modelo, marca, ano, placa, chassi)
	values
    (1, 'Jetta', 'Volkswagen', 2023, 'ABC1111', '1234567890'),
    (2, 'Azera', 'Hyundai', 2022, 'ABC2222', '0987654321'),
    (3, 'Corvete', 'Chevrolet', 2021, 'ABC3333', '1111111111'),
    (4, '500', 'Fiat', 2020, 'ABC4444', '2222222222');
    
-- inserindo equipe/serviço
insert into servico(especialidade, valor)
	values
    ('concerto', 500),
    ('revisão', 200);
    
-- inserindo mecanico
insert into mecanico (idServico, pNome, uNome, especialidade, endereco)
	values
    (1, 'Juvenal', 'Souza', 'concerto', 'Rua 9, Numero 0'),
    (1, 'Roberval', 'Souza', 'concerto', 'Rua 9, Numero 1'),
    (2, 'Jose', 'Silva', 'revisão', 'Rua 9, Numero 2');
    
-- inserindo produtos
insert into produto (nProduto, descricao, valor)
	values
    ('motor', null, 10000),
    ('cambio', null, 3000),
    ('freios', null, 500),
    ('oleo', null, 100);
    
-- inserindo ordem de servico
insert into os(idVeiculo, dtEmissao, dtEntrega, status_os)
	values
    (1, null, '2023-01-15', 'processando'),
    (2, '2022-12-30', '2023-01-02', 'finalizada'),
    (3, '2023-01-04', '2023-01-06', 'processando'),
    (4, null, '2023-01-20', 'aguardando');

-- inserindo serviõs por os
insert into servicos_por_os (idOs, idServico)
	values
    (1, 1),
    (2, 2),
    (3, 1),
    (4, 2);
    
-- inserindo produtos por os
insert into produtos_na_os (idOs, idProduto, quantidade)
	values
    (1, 1, 1),
    (2, 4, 1),
    (3, 2, 2),
    (4, 3, 4),
    (1, 3, 4),
    (2, 3, 4),
    (1, 4, 1);
    
    
insert into cliente (pNome,uNome, cpf, endereco, contato)
	values
    ('Julia', 'Smith', '7777777777', 'Rua 10, Numero 1000', '+551991111111');

insert into veiculo (idCliente, modelo, marca, ano, placa, chassi)
	values
    (5, 'Mustang', 'Ford', 2020, 'MMM9999', '1212121212');

insert into os(idVeiculo, dtEmissao, dtEntrega, status_os)
	values
    (5, null, '2023-01-18', 'processando');
    
insert into servicos_por_os(idOs, idServico)
	values
    (5, 1);

insert into produtos_na_os(idOs, idProduto, quantidade)
	values
	(5,1,1),
	(5,2,2),
	(5,3,4),
	(5,4,1);
    

-- QUERIES DE TESTE DO BANCO DE DADOS

-- quantidade de ordens de servicos no período

select count(*) from os;
	-- 5

-- quantiade de clientes ativos
select count(*) from cliente;
	-- 5

-- receita do período por serviços prestados
select sum(valor) valor_total from servicos_por_os so
	inner join servico es
    on so.idServico = es.idServico;
        
-- receita do período por produtos vendidos
select sum(po.quantidade * pd.valor) valor_total from produtos_por_os po
	inner join produto pd
    on po.idProduto = pd.idProduto;

-- receita total do período
select sum(valor) valor_total from (
	select os.idOs os ,es.valor valor from os os
    inner join servicos_por_os so
    on os.idOs = so.idOs
    inner join servico es
    on so.idServico = es.idServico
    UNION ALL
   select po.idOs, (po.quantidade * pd.valor) valor from produtos_por_os po
	inner join produto pd
    on po.idProduto = pd.idProduto
    ) valores;

-- OS e seus valores
select servico, sum(valor) valor_total from (
	select so.idOs os,es.valor valor from servicos_por_os so
    inner join servico es
    on so.idServico = es.idServico
    UNION ALL
   select po.idOs, (po.quantidade * pd.valor) valor from produtos_por_os po
	inner join produto pd
    on po.idProduto = pd.idProduto
    ) valores
	group by os
    order by valor_total desc;
    
-- mecanicos que mais prestaram servico
    select concat(me.pNome, ' ', me.uNome) Mecanico, count(me.pNome) Servicos from servicos_por_os so
    inner join os os
    on so.idOs = os.idOs
	inner join servico es
    on so.idservico = es.idServico
    inner join mecanico me
    on es.idServico = me.idServico
    where os.status_os <> 'aguardando'
    group by Mecanico
    order by Servicos desc;
    
    
    
    
    
    
    
