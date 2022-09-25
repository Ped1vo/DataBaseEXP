-- -----------------------------------------------------
-- Schema Oficina
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Oficina` ;

-- -----------------------------------------------------
-- Schema Oficina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Oficina` DEFAULT CHARACTER SET utf8 ;
USE `Oficina` ;

DROP TABLE IF EXISTS `Oficina`.`Cliente` ;

CREATE TABLE Cliente (
	idCliente int auto_increment primary key ,
    TipoPessoa  varchar(2) NOT NULL CHECK (TipoPessoa IN ('PF', 'PJ')) DEFAULT 'PF',
    Documento VARCHAR(18),
	Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(45) NOT NULL,
    Telefone VARCHAR(45) NOT NULL,
    Email VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Cliente_Documento UNIQUE (Documento));

DROP TABLE IF EXISTS `Oficina`.`StatusOrdemServico` ;

CREATE TABLE StatusOrdemServico (
    idStatusOs INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    CONSTRAINT unique_StatusOrdemServico_Identificacao UNIQUE (Identificacao)
);
    
DROP TABLE IF EXISTS `Oficina`.`OrdemServico` ;

CREATE TABLE OrdemServico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    idStatusOrdemServico INT NOT NULL,
    Codigo VARCHAR(10) NOT NULL,
    DataEmissao DATETIME NOT NULL,
    DataParaConclusao DATETIME,
    Valor DECIMAL(18 , 2 ),
    DataAutorizacao DATETIME,
    Obs TEXT,
    CONSTRAINT unique_OrdemServico_Codigo UNIQUE (Codigo),
    CONSTRAINT fk_OrdemServico_idCliente FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente),
    CONSTRAINT fk_OrdemServico_idStatusOrdemServico FOREIGN KEY (idStatusOrdemServico)
        REFERENCES StatusOrdemServico (idStatusOs)
);
    
DROP TABLE IF EXISTS `Oficina`.`Marca` ;

CREATE TABLE Marca (
    idMarca INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    CONSTRAINT unique_Marca_Identificacao UNIQUE (Identificacao)
);

DROP TABLE IF EXISTS `Oficina`.`Modelo` ;

CREATE TABLE Modelo (
    idModelo INT AUTO_INCREMENT PRIMARY KEY,
    idMarca INT NOT NULL,
    Identificacao VARCHAR(45) NOT NULL,
    Ano INT NOT NULL,
    CONSTRAINT unique_Modelo_Identificacao UNIQUE (Identificacao),
    CONSTRAINT fk_Modelo_idMarca FOREIGN KEY (idMarca)
        REFERENCES Marca (idMarca)
);
    
DROP TABLE IF EXISTS `Oficina`.`Equipe` ;
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    CONSTRAINT unique_Equipe_Identificacao UNIQUE (Identificacao)
);
    
DROP TABLE IF EXISTS `Oficina`.`StatusServico` ;

CREATE TABLE StatusServico (
    idStatusServico INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    CONSTRAINT unique_StatusServico_Identificacao UNIQUE (Identificacao)
);
    
DROP TABLE IF EXISTS `Oficina`.`TabelaServico` ;
    
CREATE TABLE TabelaServico (
    idTabelaServico INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(100) NOT NULL,
    ValorTabela DECIMAL(18 , 2 ),
    CONSTRAINT unique_TabelaServico_Identificacao UNIQUE (Identificacao)
);

DROP TABLE IF EXISTS `Oficina`.`Veiculo` ;

CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idOrdemServico INT NOT NULL,
    idModelo INT NOT NULL,
    Cor INT NOT NULL,
    Placa VARCHAR(20),
    CONSTRAINT fk_Veiculo_idOrdemServico FOREIGN KEY (idOrdemServico)
        REFERENCES OrdemServico (id),
    CONSTRAINT fk_Veiculo_idModelo FOREIGN KEY (idModelo)
        REFERENCES Modelo (idModelo)
);
 
DROP TABLE IF EXISTS `Oficina`.`Servico` ;

CREATE TABLE Servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idVeiculo INT NOT NULL,
    idTabelaServico INT NOT NULL,
    idEquipe INT NOT NULL,
    idStatusServico INT NOT NULL,
    Descricao TEXT NOT NULL,
    ValorPecas DECIMAL(18 , 2 ) NOT NULL,
    ValorMaoDeObra DECIMAL(18 , 2 ) NOT NULL,
    DataInicio DATETIME,
    DataTermino DATETIME,
    CONSTRAINT fk_Servico_idVeiculo FOREIGN KEY (idVeiculo)
        REFERENCES Veiculo (idVeiculo),
    CONSTRAINT fk_Servico_idTabelaServico FOREIGN KEY (idTabelaServico)
        REFERENCES TabelaServico (idTabelaServico),
    CONSTRAINT fk_Servico_idEquipe FOREIGN KEY (idEquipe)
        REFERENCES Equipe (idEquipe),
    CONSTRAINT fk_Servico_idStatusServico FOREIGN KEY (idStatusServico)
        REFERENCES StatusServico (idStatusServico)
);

DROP TABLE IF EXISTS `Oficina`.`Especialidade` ;

CREATE TABLE Especialidade (
    idEspecialidade INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    CONSTRAINT unique_Especialidade_Identificacao UNIQUE (Identificacao)
);

DROP TABLE IF EXISTS `Oficina`.`Mecanico` ;

CREATE TABLE Mecanico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idEspecialidade INT NOT NULL,
    idEquipe INT NOT NULL,
    Codigo VARCHAR(45) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(10) NOT NULL,
    CONSTRAINT unique_Mecanico_Codigo UNIQUE (Codigo),
    CONSTRAINT fk_Mecanico_idEspecialidade FOREIGN KEY (idEspecialidade)
        REFERENCES Especialidade (idEspecialidade),
    CONSTRAINT fk_Mecanico_idEquipe FOREIGN KEY (idEquipe)
        REFERENCES Equipe (idEquipe)
);

DROP TABLE IF EXISTS `Oficina`.`Peca` ;

CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Identificacao VARCHAR(45) NOT NULL,
    ValorReferencia DECIMAL(18 , 2 ) NOT NULL,
    CONSTRAINT unique_Peca_Identificacao UNIQUE (Identificacao)
);

DROP TABLE IF EXISTS `Oficina`.`ServicoPeca` ;

CREATE TABLE ServicoPeca (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idServico INT NOT NULL,
    idPeca INT NOT NULL,
    ValorPeca DECIMAL(18 , 2 ) NOT NULL,
    CONSTRAINT fk_ServicoPeca_idServico FOREIGN KEY (idServico)
        REFERENCES Servico (id),
    CONSTRAINT fk_ServicoPeca_idPeca FOREIGN KEY (idPeca)
        REFERENCES Peca (idPeca)
);

-- INSERÇÃO --
-- Clientes --
SELECT * FROM cliente;
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '380153084', 'Celinka Pozzi', '085 Warrior Parkway', '(72) 80245-6570', 'cpozzi0@go.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '416895046', 'Siana Patroni', '565 West Way', '(36) 42843-7404', 'spatroni1@printfriendly.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '702248231', 'Tory Armand', '4735 Bashford Junction', '(32) 72763-5772', 'tarmand2@bloomberg.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '516026532', 'Jayme Langthorn', '683 Summit Circle', '(06) 22681-3776', 'jlangthorn3@storify.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '501640699', 'Benedikta Dallow', '6063 Rowland Drive', '(46) 21973-3675', 'bdallow4@simplemachines.org');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '389405945', 'Inglis Arkell', '078 Prentice Plaza', '(76) 22717-1160', 'iarkell5@google.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '256640384', 'Lida Chatband', '72468 Coolidge Drive', '(81) 18064-4728', 'lchatband6@booking.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '164959643', 'Michaeline Fludder', '8 Buhler Hill', '(91) 29159-2492', 'mfludder7@thetimes.co.uk');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '206821820', 'Dara Jorioz', '026 Chinook Way', '(30) 93217-0900', 'djorioz8@theglobeandmail.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '764981920', 'Basilius Bugler', '3 Mesta Way', '(29) 04662-4773', 'bbugler9@sphinn.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '510042221', 'Lyda Deighton', '38 Debs Drive', '(89) 12737-3182', 'ldeightona@clickbank.net');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '709142014', 'Garik Battista', '3075 Marquette Hill', '(80) 11835-2642', 'gbattistab@tiny.cc');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '989317309', 'Valida Loughton', '0 Oak Valley Street', '(15) 08160-7017', 'vloughtonc@ehow.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '479296012', 'Carol-jean Tumini', '5 Jana Crossing', '(97) 12682-0442', 'ctuminid@usatoday.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '482648823', 'Nissy Sharper', '9 Brentwood Circle', '(56) 69691-1352', 'nsharpere@dedecms.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '114163151', 'Merralee Mantram', '111 Hanover Crossing', '(88) 79411-7577', 'mmantramf@naver.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PF', '215328672', 'Hymie Bootton', '083 Luster Trail', '(65) 22128-9010', 'hboottong@hud.gov');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '517350311', 'Margery Fidler', '359 American Ash Alley', '(70) 89667-0740', 'mfidlerh@dailymotion.com');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '962654826', 'Doralia Simek', '1 Ridgeway Avenue', '(42) 59650-8266', 'dsimeki@telegraph.co.uk');
insert into Cliente (TipoPessoa, Documento, Nome, Endereco, Telefone, Email) values ('PJ', '030879577', 'Shirlee Beeken', '89311 Esker Lane', '(68) 85953-7485', 'sbeekenj@apple.com');

-- StatusOrdemServico --

INSERT INTO StatusOrdemServico (Identificacao) VALUES ('ABERTO');
INSERT INTO StatusOrdemServico (Identificacao) VALUES ('EM ANDAMENTO');
INSERT INTO StatusOrdemServico (Identificacao) VALUES ('EM PAUSA');
INSERT INTO StatusOrdemServico (Identificacao) VALUES ('CANCELADO');
INSERT INTO StatusOrdemServico (Identificacao) VALUES ('CONCLUÍDO');

-- Ordem Serviço --
INSERT INTO OrdemServico (idCliente, idStatusOrdemServico, Codigo, DataEmissao, DataParaConclusao, Valor, DataAutorizacao, Obs) VALUES (1, 3, '1000', '2022-09-09', null, 250, '2022-09-09', null);
INSERT INTO OrdemServico (idCliente, idStatusOrdemServico, Codigo, DataEmissao, DataParaConclusao, Valor, DataAutorizacao, Obs) VALUES (2, 1, '1001', '2022-09-10', null, 123, '2022-09-08', null);
INSERT INTO OrdemServico (idCliente, idStatusOrdemServico, Codigo, DataEmissao, DataParaConclusao, Valor, DataAutorizacao, Obs) VALUES (3, 2, '1002', '2022-09-11', null, 125, '2022-09-07', null);
INSERT INTO OrdemServico (idCliente, idStatusOrdemServico, Codigo, DataEmissao, DataParaConclusao, Valor, DataAutorizacao, Obs) VALUES (4, 5, '1003', '2022-09-12', null, 300, '2022-09-06', null);
INSERT INTO OrdemServico (idCliente, idStatusOrdemServico, Codigo, DataEmissao, DataParaConclusao, Valor, DataAutorizacao, Obs) VALUES (5, 4, '1004', '2022-09-10', null, 500, '2022-09-05', null);

-- Marca --
INSERT INTO Marca (Identificacao) VALUES ('Ford');
INSERT INTO Marca (Identificacao) VALUES ('Toyota');
INSERT INTO Marca (Identificacao) VALUES ('Volkswagen');
INSERT INTO Marca (Identificacao) VALUES ('Peugeot');

-- Modelo --
INSERT INTO Modelo (idMarca, Identificacao, Ano) VALUES (1, 'Chevette SL', 1973);
INSERT INTO Modelo (idMarca, Identificacao, Ano) VALUES (1, 'Chevrolet Monza SL/E', 1996);
INSERT INTO Modelo (idMarca, Identificacao, Ano) VALUES (2, 'Fiat 147', 1999);
INSERT INTO Modelo (idMarca, Identificacao, Ano) VALUES (3, 'Maverick ', 1800);
INSERT INTO Modelo (idMarca, Identificacao, Ano) VALUES (3, 'Fusca ', 1980);

-- Equipe -- 
INSERT INTO Equipe (Identificacao) VALUES ('Mecanica');
INSERT INTO Equipe (Identificacao) VALUES ('Elétrica');
INSERT INTO Equipe (Identificacao) VALUES ('Lantergen');
INSERT INTO Equipe (Identificacao) VALUES ('Pintura');
INSERT INTO Equipe (Identificacao) VALUES ('Funilaria');
INSERT INTO Equipe (Identificacao) VALUES ('TOT - TROCA DE OLEO');

-- Status Servico --
INSERT INTO StatusServico (Identificacao) VALUES ('TRIAGEM');
INSERT INTO StatusServico (Identificacao) VALUES ('SERVICO INICIADO');
INSERT INTO StatusServico (Identificacao) VALUES ('AGUARDANDO TROCA DE PEÇA');
INSERT INTO StatusServico (Identificacao) VALUES ('CONCLUÍDO');
INSERT INTO StatusServico (Identificacao) VALUES ('AGUARDANDO CLIENTE');
INSERT INTO StatusServico (Identificacao) VALUES ('CANCELADO');

-- Tabela Servico --
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Pintura geral', 3000);
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Troca do motor', 1800);
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Troca de lampada do farol', 30);
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Troca de pneu', 50);
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Troca de Oleo', 90);
INSERT INTO TabelaServico (Identificacao, ValorTabela) VALUES ('Alinhamento', 100);

-- Veiculo -- 
INSERT INTO Veiculo (idOrdemServico, idModelo, Cor, Placa) VALUES (1, 1, 250025, 2015);
INSERT INTO Veiculo (idOrdemServico, idModelo, Cor, Placa) VALUES (1, 2, 250025, 2013);
INSERT INTO Veiculo (idOrdemServico, idModelo, Cor, Placa) VALUES (3, 3, 250025, 2015);
INSERT INTO Veiculo (idOrdemServico, idModelo, Cor, Placa) VALUES (3, 4, 250025, 2010);


-- Servico -- 
INSERT INTO Servico (idVeiculo, idTabelaServico, idEquipe, idStatusServico, Descricao, ValorPecas, ValorMaoDeObra, DataInicio, DataTermino) VALUES (1, 1, 1, 1, 'Trocar Pneu', 0, 50, '2022-09-10', '2022-09-10');
INSERT INTO Servico (idVeiculo, idTabelaServico, idEquipe, idStatusServico, Descricao, ValorPecas, ValorMaoDeObra, DataInicio, DataTermino) VALUES (2, 2, 2, 2, 'Instalar som', 1500, 250, '2022-09-10', '2022-09-10');
INSERT INTO Servico (idVeiculo, idTabelaServico, idEquipe, idStatusServico, Descricao, ValorPecas, ValorMaoDeObra, DataInicio, DataTermino) VALUES (3, 3, 3, 3, 'Trocar Setas', 1000, 300, '2022-09-10', '2022-09-10');
INSERT INTO Servico (idVeiculo, idTabelaServico, idEquipe, idStatusServico, Descricao, ValorPecas, ValorMaoDeObra, DataInicio, DataTermino) VALUES (4, 4, 4, 4, 'Refazer motor', 100, 1000, '2022-09-10', '2022-09-10');

-- Especialidade --
INSERT INTO Especialidade (Identificacao) VALUES ('Trocar Pneu');
INSERT INTO Especialidade (Identificacao) VALUES ('Pintar');
INSERT INTO Especialidade (Identificacao) VALUES ('Lixar');
INSERT INTO Especialidade (Identificacao) VALUES ('Mecanica Hidráulico');
INSERT INTO Especialidade (Identificacao) VALUES ('Instalar som');
INSERT INTO Especialidade (Identificacao) VALUES ('Ar Condicionado');

-- Mecanico --
INSERT INTO Mecanico (idEspecialidade, idEquipe, Codigo, Nome, Endereco) VALUES (1, 1, '001', 'João da Silva', 'Rua B');
INSERT INTO Mecanico (idEspecialidade, idEquipe, Codigo, Nome, Endereco) VALUES (2, 2, '002', 'José da Silva', 'Rua C');
INSERT INTO Mecanico (idEspecialidade, idEquipe, Codigo, Nome, Endereco) VALUES (3, 3, '003', 'jEFFE', 'Rua D');
INSERT INTO Mecanico (idEspecialidade, idEquipe, Codigo, Nome, Endereco) VALUES (4, 4, '004', 'Baixinnn', 'Rua e');

-- Peca --
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Tinta Galão', 150);
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Óloe 1lt', 40);
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Lâmpada do farol', 30);
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Pneu', 450);
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Filtro de óleo', 50);
INSERT INTO Peca (Identificacao, ValorReferencia) VALUES ('Ar condicionado completo', 1000);

-- ServicoPeca --
INSERT INTO ServicoPeca (idServico, idPeca, ValorPeca) VALUES (1, 1, 50);
INSERT INTO ServicoPeca (idServico, idPeca, ValorPeca) VALUES (2, 2, 50);
INSERT INTO ServicoPeca (idServico, idPeca, ValorPeca) VALUES (3, 3, 50);
INSERT INTO ServicoPeca (idServico, idPeca, ValorPeca) VALUES (4, 4, 50);

-- QUERIES --
-- Recuperações simples com SELECT Statement
select * from Cliente;

-- Filtros com WHERE Statement
select * from Cliente where Nome like 'L%';

-- Crie expressões para gerar atributos derivados
-- Select * from servico;
select (sum(ValorPecas)+sum(ValorMaoDeObra)) as ValorTotal from Servico;

-- Defina ordenações dos dados com ORDER BY
select Descricao, (ValorPecas + ValorMaoDeObra) as Total from Servico order by Total asc;

-- Condições de filtros aos grupos – HAVING Statement
select * From ServicoPeca;
select idPeca from ServicoPeca group by idPeca having count(idPeca)<2;

-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
 select * from cliente;
 select * From StatusOrdemServico;
 select * from OrdemServico;
 
SELECT c.Nome FROM Cliente c
INNER JOIN OrdemServico o ON c.idCliente = o.idCliente
INNER JOIN StatusOrdemServico so ON so.idStatusOs = o.idStatusOrdemServico
WHERE Identificacao = 'CANCELADO'


