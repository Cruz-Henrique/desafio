-- Desafio Dio Oficina


create database oficina;
use oficina;

-- criar tabela clientes

create table clientes(
	idCliente int auto_increment primary key,
	nomeCliente varchar(100),
	CPF_Cliente char(11) not null,
	enderecoCliente varchar(255),
	bairroCliente varchar(75),
	siglaEstadoCliente char(2),
	emailCliente varchar(100),
	contatoCliente char(11),
    
    	constraint unique_CPF_Cliente unique (CPF_Cliente)
);

-- criar tabela com informações dos veículos

create table veiculos (
	idCliente int not null,
	idVeiculo int auto_increment,
	tipoVeiculo varchar(20) null,
	marca varchar(50),
	modelo varchar(15),
	ano char(4),
	cor varchar(15),
	placa varchar(10),
	quilometragem varchar(7),
	combustivel varchar(12),
	capacidadeTanque int null,
    constraint primary key (idVeiculo, idCliente),
	constraint fk_ClienteVeiculo foreign key (idCliente) references clientes(idCliente)    
);
-- criar tabela com informações das motos
-- potênica =cilindrada  
create table motos (
  	idMoto int auto_increment,
	idVeiculoMoto int,
	tipoMoto varchar(20),
	potencia varchar(6),
	transmissao varchar(15),
	freiosSistema varchar(10),
	marchas int null,
 	constraint primary key(idMoto, idVeiculoMoto),
  	constraint unique_VeiculoMoto unique (idVeiculoMoto),
	constraint fk_veiculoMoto foreign key (idVeiculoMoto) references veiculos(idVeiculo)   
);
-- criar tabela com informações dos carros
create table carros(
    	idCarro int auto_increment,
    	idVeiculoCarro int not null,
    	refrigeracao boolean default false,
    	volume varchar(35) null,
    	vidroEletrico boolean default True,
    	carroceria varchar(20),
       	constraint primary key(idCarro, idVeiculoCarro),
    	constraint unique_veiculoCarro unique (idCeiculoCarro),
    	constraint fk_carro_moto foreign key (idVeiculoCarro) references veiculos(idVeiculo)
);
-- criar tabela com informações dos funcionários
create table funcionarios (
	idFunc int auto_increment primary key,
	nomeFunc varchar(125),
	CPF_Func char(11) not null,
	cargoFunc varchar(20),
    emailFunc varchar(150),
	contatoFunc char(18),
	dataContratacao date not null,
	salario numeric(12,2) not null,
	enderecoFunc varchar(255),
	bairroFunc varchar(50),
	siglaEstadoFunc char(2),
constraint unique_CPF_Func unique (CPF_Func)

);
-- criar tabela com informações dos fornecedores
create table fornecedores (
	idFornecedor int auto_increment primary key,
    CNPJ_Fornecedor char(15) not null,
	razaoSocialFornecedor varchar(255) not null,
	nomeContatoFornecedor varchar(100) not null,
	telefoneFornecedor char(11) not null,
	enderecoFornecedor varchar(100)not null,
	bairroFornecedor varchar(50),
	estadoFornecedor char(2),
	cpfContatoFornecedor char(11) not null,
	telefoneContatoFornecedor char(11) not null,
    constraint unique_cpfContatoFornecedor unique (cpfContatoFornecedor),
	constraint unique_cnpj_Fornecedor unique (CNPJ_Fornecedor)
);
-- criar tabela com informações das peças
create table pecas (
	idPeca int auto_increment primary key, 
    fabricante varchar(50),
    seriePeca varchar(25) not null,
	tipoPeca enum('carro','moto') not null,
	nomePeca varchar(100) not null,
	precoPeca numeric(10,2) not null,
	quantidadePeca int not null
);
-- criar tabela com as informações das compras
create table compras (
	idCompra int auto_increment primary key,
	idPecaComprada int,
	idFornecedor int not null,
	dataCompra date not null,
	quantidadePecaComprada int not null,
	valorUnitPeca numeric(10,2),
	totalCompraPeca numeric(10,2),
	constraint fk_pecaComprada foreign key (idPecaComprada) references pecas(idPeca),
    constraint fk_fornecedorPecaComprada foreign key (idFornecedor) references fornecedores(idFornecedor)
);
-- criar tabela com as informações de OS (Ordem de serviço)

create table def_servicos (
	idServico int auto_increment primary key,
	idFuncionario int not null,
	descricaoServico varchar(350),
	valorServico numeric(10,2),
    constraint fk_funcionarioServico foreign key (idFuncionario) references funcionarios(idFunc)  
    
);
-- criar tabela com as informações de serviço

create table servicos (
	id_pk_serico int auto_increment primary key,
	idServico int,
    idVeiculoServico int null,
	idPecaServico int null,
	idFuncionario int not null,
	statusServico varchar(350),
	aberturaDataServico date not null, 
	fechamentoDataServico date  null,
    
	constraint fk_pecaServico foreign key (idPecaServico) references pecas(idPeca),
	constraint fk_servico_defServico foreign key (idServico) references def_servicos(idServico),
	constraint fk_veiculoServico foreign key (idVeiculoServico) references veiculos(idVeiculo) 
);
-- criar tabela com as informações sobre o pagamento
create table pagtos_nota (
	idNotaFiscal int not null,
    dataNota date not null, 
	idServicoPgtoNota int not null,
	idClientePgtoNota int not null,
	valorTotalPgtoNota numeric(10,2),
	pagamentoTipo enum('Boleto','Crédito', 'Débito', 'Pix','Dinheiro', 'Crediário', 'Cartão da Loja', 'Tranferência'),
	dataPgtoNota date not null,
    
	constraint primary key (idNotaFiscal, idServicoPgtoNota, idClientePgtoNota),
	constraint fk_cliente_pgto_nota foreign key (idClientePgtoNota) references clientes(idCliente),
	constraint fk_servico_pgto_nota foreign key (idServicoPgtoNota ) references servicos(id_pk_serico)
);
