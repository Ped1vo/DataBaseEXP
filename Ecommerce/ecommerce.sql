-- -----------------------------------------------------
-- Schema Ecommerce
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Ecommerce` ;

-- -----------------------------------------------------
-- Schema Ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `Ecommerce` ;

DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente (
	id int auto_increment primary key ,
	Nome VARCHAR(100) NOT NULL,
	Documento VARCHAR(18),
	TipoPessoa  varchar (2) NOT NULL check (TipoPessoa IN('PF', 'PJ')) DEFAULT 'PF',
	CONSTRAINT unique_Cliente_Documento UNIQUE (Documento));
    desc Cliente;

DROP TABLE IF EXISTS StatusPedido;
CREATE TABLE StatusPedido (
	id int auto_increment primary key ,
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_StatusPedido_Identificacao UNIQUE (Identificacao));
    desc StatusPedido;

DROP TABLE IF EXISTS TipoPagamento;
CREATE TABLE TipoPagamento (
	id int auto_increment primary key ,
	Identificacao VARCHAR(50) NOT NULL,
	CONSTRAINT unique_TipoPagamento_Identificacao UNIQUE (Identificacao));
    desc TipoPagamento;
    
DROP TABLE IF EXISTS StatusEntrega;
CREATE TABLE StatusEntrega (
	id INT auto_increment primary key ,
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_StatusEntrega_Identificacao UNIQUE (Identificacao));
    desc StatusEntrega;
    
DROP TABLE IF EXISTS EnderecoEntrega;
CREATE TABLE EnderecoEntrega (
	id INT auto_increment primary key ,
	IDStatusEntrega INT NOT NULL,
	CodRastreio VARCHAR(50) NOT NULL,
	CEP VARCHAR(15) NOT NULL,
	Logradouro VARCHAR(150) NOT NULL,
	Numero VARCHAR(10) NOT NULL,
	Complemento VARCHAR(10),
	DataEntrega DATETIME,
	CONSTRAINT fk_EnderecoEntrega_idStatusEntrega_StatusEntrega_id FOREIGN KEY (IDStatusEntrega) REFERENCES StatusEntrega(id) ON DELETE NO ACTION);
    desc EnderecoEntrega;
    
DROP TABLE IF EXISTS Estoque;
CREATE TABLE Estoque (
	id INT auto_increment key,
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Estoque_Identificacao UNIQUE (Identificacao));
    desc Estoque;

DROP TABLE IF EXISTS VendedorTerceiro;
CREATE TABLE VendedorTerceiro (
	id INT auto_increment primary key ,
	RazaoSocial VARCHAR(100) NOT NULL,
	CNPJ VARCHAR(45) NOT NULL,
	CONSTRAINT unique_VendedorTerceiro_CNPJ UNIQUE (CNPJ));
    desc VendedorTerceiro;
    
DROP TABLE IF EXISTS Fornecedor;
CREATE TABLE Fornecedor (
	id INT auto_increment primary key,
	RazaoSocial VARCHAR(100) NOT NULL,
	CNPJ VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Fornecedor_CNPJ UNIQUE (CNPJ));
    desc Fornecedor;
    
DROP TABLE IF EXISTS Categoria;
CREATE TABLE Categoria (
	id int auto_increment primary key ,
	Identificacao VARCHAR(45) NOT NULL,
	CONSTRAINT unique_Categoria_Identificacao UNIQUE (Identificacao));
    desc Categoria;
    
DROP TABLE IF EXISTS Produto; 
CREATE TABLE Produto (
	id INT auto_increment primary key,
	idCategoria INT NOT NULL,
	Identificacao VARCHAR(100) NOT NULL,
	Descricao TEXT NOT NULL,
	Valor DECIMAL(18,2) NOT NULL,
	CONSTRAINT unique_Produto_Identificacao UNIQUE (Identificacao),
	CONSTRAINT fk_Produto_idCategoria_Categoria_id FOREIGN KEY (idCategoria) REFERENCES Categoria(id) ON DELETE NO ACTION);
    desc Produto;

DROP TABLE IF EXISTS ProdutoFornecedor;
CREATE TABLE ProdutoFornecedor (
	id int auto_increment primary key ,
	idProduto INT NOT NULL,
	idFornecedor INT NOT NULL,
	CONSTRAINT fk_ProdutoFornecedor_idProduto FOREIGN KEY (idProduto) REFERENCES Produto(id) 
    ON DELETE NO ACTION,
	CONSTRAINT fk_ProdutoFornecedor_idFornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(id) 
    ON DELETE NO ACTION);
    desc ProdutoFornecedor;
    
DROP TABLE IF EXISTS ProdutoVendedorTerceiro;
CREATE TABLE ProdutoVendedorTerceiro (
	id int auto_increment primary key,
	idProduto INT NOT NULL,
	idVendedorTerceiro INT NOT NULL,
	CONSTRAINT fk_ProdutoVendedorTerceiro_idProduto FOREIGN KEY (idProduto) REFERENCES Produto(id),
	CONSTRAINT fk_ProdutoVendedorTerceiro_idVendedorTerceiro FOREIGN KEY (idVendedorTerceiro) REFERENCES VendedorTerceiro(id));
    desc ProdutoVendedorTerceiro;
    
DROP TABLE IF EXISTS ProdutoEstoque;
CREATE TABLE ProdutoEstoque (
	id int auto_increment primary key,
	idProduto INT NOT NULL,
	idEstoque INT NOT NULL,
	Quantidade INT NOT NULL,
	CONSTRAINT fk_ProdutoEstoque_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION,
	CONSTRAINT fk_ProdutoEstoque_idEstoque_Estoque_id FOREIGN KEY (idEstoque) REFERENCES Estoque(id) ON DELETE NO ACTION);
    desc ProdutoEstoque;
    
DROP TABLE IF EXISTS Pedido;
CREATE TABLE Pedido (
	id int auto_increment primary key,
	idEnderecoEntrega INT NOT NULL,
	idCliente INT NOT NULL,
	idStatusPedido INT NOT NULL,
    Codigo VARCHAR(45) NOT NULL, 
	DataPedido DATETIME NOT NULL,
	VlrFrete DECIMAL(18,2),
	VlrPedido DECIMAL(18,2),
	VlrTotal DECIMAL(18,2),
	CONSTRAINT unique_Pedido_Codigo UNIQUE (Codigo),
	CONSTRAINT fk_Pedido_idEnderecoEntrega_EnderecoEntrega_id FOREIGN KEY (idEnderecoEntrega) REFERENCES EnderecoEntrega(id) ON DELETE NO ACTION,
	CONSTRAINT fk_Pedido_idCliente_Cliente_id FOREIGN KEY (idCliente) REFERENCES Cliente(id) ON DELETE NO ACTION,
	CONSTRAINT fk_Pedido_idStatusPedido_StatusPedido_id FOREIGN KEY (idStatusPedido) REFERENCES StatusPedido(id) ON DELETE NO ACTION);
    desc Pedido;
    
    
DROP TABLE IF EXISTS PedidoProduto;
CREATE TABLE PedidoProduto (
	id int auto_increment primary key,
	idPedido INT NOT NULL,
	idProduto INT NOT NULL,
	CONSTRAINT fk_PedidoProduto_idPedido_Pedido_id FOREIGN KEY (idPedido) REFERENCES Pedido(id) ON DELETE NO ACTION,
	CONSTRAINT fk_PedidoProduto_idProduto_Produto_id FOREIGN KEY (idProduto) REFERENCES Produto(id) ON DELETE NO ACTION);
    desc PedidoProduto;
    
DROP TABLE IF EXISTS TipoPagamentoPedido;
CREATE TABLE TipoPagamentoPedido (
	id int auto_increment primary key,
	idPedido INT NOT NULL,
	idTipoPagamento INT NOT NULL,
	Valor DECIMAL(18,2),
	CONSTRAINT fk_TipoPagamentoPedido_idPedido_Pedido_id FOREIGN KEY (idPedido) REFERENCES Pedido(id) ON DELETE NO ACTION,
	CONSTRAINT fk_TipoPagamentoPedido_idTipoPagamento_TipoPagamento_id FOREIGN KEY (idTipoPagamento) REFERENCES TipoPagamento(id) ON DELETE NO ACTION);
    desc TipoPagamentoPedido;

-- povoando o banco --
-- clientes --
insert into Cliente (Nome, Documento, TipoPessoa) values ('Denyse Wallbutton', 1003297429, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Kirbee Aylmer', 1016837415, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Vernen Byrom', 1025440827, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Walsh Manville', 1029031922000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Harriott Emes', 1008630493, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Jessi Harwell', 1008547525000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Iormina Tubridy', 1061043927000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Dorita Breen', 1102170238000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Bernetta Konert', 1002298827, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Dian Seely', 1052214570, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Fritz Clyant', 1031654711, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Melonie Henrique', 1046038543000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Hendrika Attril', 1047219752, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Bonita Rain', 1014019942, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Tedie Ronnay', 1000063122000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Collin Dale', 1084680197000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Lamond Wearden', 1106231633, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Tomi Rasch', 1085572445000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Meggi Von Hindenburg', 1108840771000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Hamlen Carlucci', 1096131968, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Coop Longfut', 1030182794, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Hayes Eakens', 1062266351000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Lazar Woolford', 1035036201, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Kimberly Rishman', 1052454532, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Maxie Tzar', 1064359406, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Addia Frenchum', 1076874065000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Julianna Shobbrook', 1032838136, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Wakefield Pude', 1066230313, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Pebrook Olensby', 1067368098, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Brit Astbery', 1069226947000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Rubie Brownill', 1016402283000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Margret Schneidar', 1077490938, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Andie Brian', 1092860462000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Torrey Phlippsen', 1057372607000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Renee Pitkeathly', 1041029865, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Tobiah Carrane', 1014737518, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Winnie Mowsley', 1086815432, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Tully Sayburn', 1110344078000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Alberta Silverlock', 1043124204, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Emile Trevett', 1094473256, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Hadley Burnie', 1097770491, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Kurt Ohrt', 1109079611000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Philly Quadri', 1009047795, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Meryl Largan', 1000636548000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Theo Nassy', 1044689425, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Christiane Alvey', 1070718903, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Orrin Raddenbury', 1000843315, 'PF');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Christi Maryin', 1044427712000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Hagan Berford', 1078285566000000, 'PJ');
insert into Cliente (Nome, Documento, TipoPessoa) values ('Brantley Ziemsen', 1081263960, 'PF');
select * from Cliente;

-- statuspedido --
insert into StatusPedido (Identificacao) values ('ABERTO');
insert into StatusPedido (Identificacao) values ('EM ANDAMENTO');
insert into StatusPedido (Identificacao) values ('EM PAUSA');
insert into StatusPedido (Identificacao) values ('CONCLUIDO');
insert into StatusPedido (Identificacao) values ('CANCELADO');
Select * from StatusPedido;

-- TipoPagamento --
insert into TipoPagamento (Identificacao) values ('DEBITO');
insert into TipoPagamento (Identificacao) values ('CREDITO');
insert into TipoPagamento (Identificacao) values ('DINHEIRO');
insert into TipoPagamento (Identificacao) values ('BOLETO');
insert into TipoPagamento (Identificacao) values ('PIX');

-- StatusEntrega --
INSERT INTO StatusEntrega (Identificacao) VALUES ('Aguardando separação');
INSERT INTO StatusEntrega (Identificacao) VALUES ('Retirado pela transportadora');
INSERT INTO StatusEntrega (Identificacao) VALUES ('Cancelado');
INSERT INTO StatusEntrega (Identificacao) VALUES ('Entregue');

-- EnderecoEntrega --
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (1, '9679653', '13403-796', '4781 South Circle', 190, 'Sherman');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (2, '8815197', '15790-713', '65 Iowa Junction', 394, 'Marquette');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (3, '3933032', '72631-482', '98 Crownhardt Place', 361, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (4, '9693493', '92309-441', '52095 Fuller Crossing', 343, 'Pleasure');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (5, '0234789', '57948-347', '1 Grayhawk Hill', 296, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (6, '7401330', '98850-405', '90 Mallard Street', 378, 'Dwight');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (7, '9165021', '99306-506', '75009 Almo Lane', 58, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (8, '5228473', '16451-304', '329 Sunfield Point', 161, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (9, '2668650', '64042-561', '02 Lakewood Gardens Place', 249, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (10, '3713680', '02445-796', '5972 Hanover Drive', 475, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (11, '5139823', '82907-523', '46858 Corry Pass', 77, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (12, '9353802', '06254-100', '527 Reindahl Street', 154, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (13, '1321850', '93410-675', '7 Sachs Park', 418, 'Shoshone');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (14, '3891437', '96177-134', '8390 Stoughton Plaza', 393, 'Rowland');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (15, '5961068', '64327-148', '3 Monica Plaza', 2, 'Stephen');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (16, '7823683', '03108-325', '8493 Northland Drive', 31, 'Kedzie');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (17, '4419951', '79941-532', '63 Northwestern Junction', 87, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (18, '0453831', '91255-505', '1 Logan Alley', 429, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (19, '8357282', '56720-561', '408 Brickson Park Street', 423, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (20, '9660848', '77710-276', '24416 Morrow Drive', 261, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (21, '0808985', '67421-475', '15 Petterle Junction', 148, 'Spaight');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (22, '2234458', '14667-826', '72 Talmadge Way', 340, 'Nobel');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (23, '0654646', '41870-993', '397 Roth Alley', 251, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (24, '5156983', '79197-263', '68899 Buell Plaza', 152, 'Pond');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (25, '7462467', '79662-855', '13613 Rieder Terrace', 454, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (26, '7098668', '41473-875', '69 Ilene Street', 196, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (27, '6432474', '40514-008', '391 2nd Court', 428, 'Columbus');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (28, '2860047', '01002-379', '216 Brown Park', 488, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (29, '3956370', '00958-739', '4658 Corben Terrace', 91, 'Thierer');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (30, '7551445', '07091-348', '16 Center Circle', 431, 'Fremont');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (31, '4434936', '93560-508', '765 Forest Alley', 32, 'Ilene');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (32, '9397789', '97277-296', '9 Mendota Hill', 294, 'Bay');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (33, '2329109', '70604-616', '9361 Darwin Plaza', 193, 'Linden');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (34, '9533292', '96071-745', '50667 Garrison Point', 136, 'Vera');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (35, '3760374', '00874-507', '20032 Lighthouse Bay Park', 439, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (36, '9783337', '85059-232', '3 Stuart Court', 38, 'Straubel');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (37, '8583777', '24118-149', '0 Hayes Lane', 26, 'Victoria');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (38, '4237754', '49656-437', '35644 Manufacturers Parkway', 214, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (39, '3439022', '84037-779', '74 Lotheville Trail', 476, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (40, '5247707', '52577-577', '2 Butterfield Road', 86, 'Pine View');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (41, '6234993', '54148-502', '826 Barnett Parkway', 165, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (42, '1250311', '25224-657', '65 Harbort Terrace', 149, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (43, '1232779', '68400-180', '94186 Myrtle Park', 346, 'Tennessee');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (44, '1664384', '75762-604', '7136 Dennis Terrace', 188, 'Harper');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (45, '8450063', '10979-972', '49 Armistice Crossing', 14, 'Hansons');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (46, '8420370', '15682-460', '5 Clemons Crossing', 134, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (47, '3810928', '44843-325', '203 Waxwing Avenue', 432, 'Kropf');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (48, '6740977', '11796-011', '4 Messerschmidt Point', 427, 'Arkansas');
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (49, '5526913', '56974-870', '40 Mayer Terrace', 300, null);
insert into EnderecoEntrega (IDStatusEntrega, CodRastreio, CEP, Logradouro, Numero, Complemento) values (50, '5323450', '27110-475', '82921 Forest Dale Road', 140, null);

-- Estoque --
INSERT INTO Estoque (Identificacao) VALUES ('Setor Oeste');
INSERT INTO Estoque (Identificacao) VALUES ('Setor Leste');
INSERT INTO Estoque (Identificacao) VALUES ('Setor Central');
INSERT INTO Estoque (Identificacao) VALUES ('Setor Norte');
INSERT INTO Estoque (Identificacao) VALUES ('Setor Sul');

-- Vendedor Terceiro --
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Tazz', 968326671465167);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Jabberstorm', 949479891546117);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Wordify', 822195495678093);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Jetwire', 181267640540557);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Kare', 365665639242444);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Edgewire', 193949323289612);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Oyondu', 932491258589187);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Livefish', 308595391997068);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('LiveZ', 490194887247537);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Innojam', 202164010896638);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Mudo', 410194917451037);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Babbleset', 855588899378919);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Cogidoo', 685436718690234);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Linktype', 491569648343142);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Gigabox', 729602125583377);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Skidoo', 418917679451789);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Quire', 130939662475262);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Fivespan', 563550615795607);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Dabshots', 810345293015230);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Myworks', 153004217322273);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Browsezoom', 431423847606598);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Skinte', 792735208301246);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Jabbersphere', 404166109092770);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Yakidoo', 346856509087400);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Livefish', 996094383141621);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Chatterbridge', 823748183037685);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Meevee', 865337839098218);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Kazu', 530292894633518);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Linkbridge', 270635177887021);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Dabfeed', 888043092561693);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Photobug', 163783007733109);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Quimba', 447964045183003);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Jatri', 635622667299728);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Tagchat', 451446014765657);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Quinu', 137572753775964);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Realcube', 929277604527176);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Twinder', 628427395800164);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Blognation', 452412230909052);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Avamba', 465576446039467);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Photofeed', 633978549504800);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Flipbug', 249661742839027);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Oba', 642219707394673);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Skyble', 305410129262595);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Topicshots', 701826370909866);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Tazzy', 732085105319784);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Dabfeed', 445376734918629);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Topdrive', 198063624318610);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Rhynyx', 755199222141558);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Rhynoodle', 232839022930577);
insert into VendedorTerceiro  (RazaoSocial, CNPJ) values ('Feednation', 606511535865643);
select count(*) from VendedorTerceiro;

-- Fornecedor --
insert into Fornecedor (RazaoSocial, CNPJ) values ('Voolith', 487304333916282);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Buzzshare', 323380193736239);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Quimm', 269603216383789);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Wordtune', 493652991518124);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Feedspan', 190866517129756);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Photobean', 598053409515216);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Vinder', 360341638987035);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Centimia', 235484949400452);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Kanoodle', 531508842679450);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Dabvine', 917860135794732);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Topdrive', 716645002226632);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Livetube', 114938016942871);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Yombu', 351386884829751);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Voonte', 955081022835774);
insert into Fornecedor (RazaoSocial, CNPJ) values ('Oyondu', 709488708775258);

-- Categoria --
insert into Categoria (Identificacao) values ('Books');
insert into Categoria (Identificacao) values ('Shoes');
insert into Categoria (Identificacao) values ('Games');
insert into Categoria (Identificacao) values ('Garden');
insert into Categoria (Identificacao) values ('Automotive');
insert into Categoria (Identificacao) values ('Home');
insert into Categoria (Identificacao) values ('Tools');
insert into Categoria (Identificacao) values ('Mantimento');
insert into Categoria (Identificacao) values ('Movies');

-- Produto --
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Guinea Fowl', 'Curabitur convallis.', 32.7);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Container Clear 8 Oz', 'Nulla mollis molestie lorem.', 54.3);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Venison - Striploin', 'Aliquam erat volutpat. In congue.', 53.23);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Wine - Lou Black Shiraz', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 5.53);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (9, 'Mushroom - King Eryingii', 'Sed vel enim sit amet nunc viverra dapibus.', 78.57);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (4, 'Goldschalger', 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 8.93);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Tuna - Canned, Flaked, Light', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', 23.81);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Cheese - Perron Cheddar', 'Vestibulum sed magna at nunc commodo placerat.', 21.95);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Buffalo - Striploin', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 60.62);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Sherry - Dry', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', 45.5);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Pastry - Raisin Muffin - Mini', 'Proin risus. Praesent lectus.', 71.96);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (1, 'Beer - Maudite', 'In sagittis dui vel nisl.', 98.52);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (2, 'Sole - Fillet', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 92.16);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Veal - Sweetbread', 'Suspendisse potenti.', 81.51);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'The Pop Shoppe - Black Cherry', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', 97.61);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Truffle Cups Green', 'In eleifend quam a odio. In hac habitasse platea dictumst.', 76.15);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (1, 'Lid - 3oz Med Rec', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 18.41);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (7, 'Olives - Black, Pitted', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', 49.93);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Coffee Cup 8oz 5338cd', 'Aenean sit amet justo. Morbi ut odio.', 63.92);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (1, 'Boogies', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', 99.26);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (4, 'Nut - Peanut, Roasted', 'Duis bibendum. Morbi non quam nec dui luctus rutrum.', 84.09);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (4, 'Bread - English Muffin', 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 69.15);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Bread Base - Italian', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 4.48);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (9, 'Cinnamon Buns Sticky', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 75.37);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Basil - Thai', 'Etiam faucibus cursus urna.', 29.64);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Beets - Candy Cane, Organic', 'Maecenas rhoncus aliquam lacus.', 57.44);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (7, 'Fruit Salad Deluxe', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', 56.61);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Coffee - Ristretto Coffee Capsule', 'Vestibulum sed magna at nunc commodo placerat.', 70.35);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Pasta - Fett Alfredo, Single Serve', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.', 96.24);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Browning Caramel Glace', 'Aliquam non mauris.', 75.91);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Olives - Stuffed', 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 48.61);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Cheese - Boursin, Garlic / Herbs', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 75.88);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Icecream Bar - Del Monte', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 20.98);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Bread - Pita', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 90.49);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (1, 'Juice - Apple 284ml', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 9.38);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (6, 'Oil - Grapeseed Oil', 'Phasellus in felis.', 77.42);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Capon - Whole', 'Aenean sit amet justo. Morbi ut odio.', 33.57);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (4, 'Flower - Potmums', 'Pellentesque viverra pede ac diam.', 78.17);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (8, 'Molasses - Fancy', 'Duis mattis egestas metus.', 22.24);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (3, 'Gherkin - Sour', 'Nulla tellus. In sagittis dui vel nisl.', 31.19);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (7, 'Cup - 3.5oz, Foam', 'Ut at dolor quis odio consequat varius.', 92.2);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (4, 'Carbonated Water - Wildberry', 'Quisque porta volutpat erat.', 26.9);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (9, 'Venison', 'Nulla ac enim.', 72.99);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (9, 'Tomatoes Tear Drop Yellow', 'Cras non velit nec nisi vulputate nonummy.', 31.53);
insert into Produto (idCategoria, Identificacao, Descricao, Valor) values (5, 'Vinegar - Tarragon', 'Integer a nibh. In quis justo.', 27.57);

-- produto fornecedor --
insert into ProdutoFornecedor (idProduto, idFornecedor) values (41, 11);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (35, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (10, 15);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (32, 2);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (44, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (39, 7);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (14, 14);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (5, 6);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (3, 1);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (20, 5);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (42, 6);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (29, 12);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (4, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (28, 2);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (37, 9);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (6, 3);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (31, 1);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (13, 14);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (3, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (19, 6);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (38, 7);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (6, 12);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (2, 1);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (27, 15);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (17, 14);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (11, 7);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (22, 1);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (40, 15);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (8, 2);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (18, 11);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (26, 13);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (15, 13);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (24, 7);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (9, 12);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (41, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (11, 9);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (8, 8);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (37, 6);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (28, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (38, 5);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (23, 4);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (12, 8);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (24, 15);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (42, 8);
insert into ProdutoFornecedor (idProduto, idFornecedor) values (5, 10);

-- produto vendedor terceiro --
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (40, 42);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (2, 39);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (7, 7);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (35, 7);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (23, 27);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (27, 40);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (1, 15);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (21, 17);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (29, 35);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (27, 38);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (21, 30);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (16, 19);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (36, 23);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (11, 20);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (28, 26);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (13, 20);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (5, 24);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (19, 16);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (43, 31);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (43, 37);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (17, 45);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (7, 38);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (34, 1);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (31, 13);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (39, 28);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (26, 15);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (35, 33);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (45, 44);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (5, 44);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (13, 2);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (25, 9);
insert into ProdutoVendedorTerceiro (idProduto, idVendedorTerceiro) values (15, 11);

-- produto estoque --
-- select count(*) from produto;
-- select count(*) from estoque;
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (37, 5, 392);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (8, 2, 18);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (32, 1, 111);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (25, 2, 345);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (21, 4, 403);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (43, 3, 366);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (11, 1, 27);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (30, 1, 311);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (9, 3, 329);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (44, 4, 60);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (10, 5, 53);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (7, 4, 375);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (36, 2, 113);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (13, 3, 252);
insert into ProdutoEstoque (idProduto, idEstoque, Quantidade) values (14, 2, 176);

-- pedido --
-- select count(*) from EnderecoEntrega;
-- select count(*) from cliente;
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (21, 42, 3, '563657', '2021-12-27', 32, 846, 878);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (10, 3, 4, '017338', '2022-06-02', 38, 6199, 6237);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (35, 16, 3, '679434', '2022-02-22', 41, 1406, 1447);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (38, 18, 4, '736428', '2021-10-31', 37, 8681, 8718);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (13, 36, 4, '498006', '2022-02-21', 28, 4481, 4509);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (48, 40, 1, '689442', '2022-06-23', 28, 8402, 8430);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (20, 6, 4, '307886', '2022-09-22', 14, 3218, 3232);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (23, 23, 3, '121149', '2022-07-31', 15, 8263, 8278);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (24, 9, 2, '747978', '2022-07-19', 30, 389, 419);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (40, 8, 2, '570513', '2022-08-31', 39, 1106, 1145);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (40, 48, 1, '047685', '2021-09-27', 33, 6216, 6249);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (40, 6, 4, '226311', '2022-06-19', 2, 4420, 4422);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (19, 46, 4, '778549', '2022-09-09', 24, 3735, 3759);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (16, 27, 4, '127428', '2022-01-01', 2, 5731, 5733);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (1, 16, 2, '490257', '2022-06-15', 49, 4293, 4342);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (43, 10, 2, '350832', '2022-01-27', 8, 1249, 1257);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (35, 44, 4, '104638', '2021-10-08', 44, 1849, 1893);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (22, 32, 2, '526313', '2022-08-11', 38, 5282, 5320);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (33, 35, 5, '188674', '2022-07-10', 45, 6657, 6702);
insert into Pedido (idEnderecoEntrega, idCliente, idStatusPedido, Codigo, DataPedido, vlrFrete, vlrPedido, VlrTotal) values (49, 13, 5, '897625', '2021-09-24', 36, 9217, 9253);

-- PedidoProduto --
INSERT INTO PedidoProduto (idPedido, idProduto) VALUES (1, 2);
INSERT INTO PedidoProduto (idPedido, idProduto) VALUES (3, 3);
INSERT INTO PedidoProduto (idPedido, idProduto) VALUES (4, 5);

-- TipoPagamentoPedido -- 
INSERT INTO TipoPagamentoPedido (idPedido, idTipoPagamento, Valor) VALUES (1, 1, 100);
INSERT INTO TipoPagamentoPedido (idPedido, idTipoPagamento, Valor) VALUES (3, 2, 120);
INSERT INTO TipoPagamentoPedido (idPedido, idTipoPagamento, Valor) VALUES (4, 3, 180);
INSERT INTO TipoPagamentoPedido (idPedido, idTipoPagamento, Valor) VALUES (5, 4, 100);

-- queries --
-- Recuperações simples com SELECT Statement
select * from pedido;

-- Filtros com WHERE Statement
select codigo from pedido;
select * from pedido where codigo>'200000';

-- Crie expressões para gerar atributos derivados
select (sum(vlrFrete)+sum(vlrPedido)) as ValorTotal from Pedido;

-- Defina ordenações dos dados com ORDER BY
select Identificacao, Valor from Produto order by valor desc;

-- Condições de filtros aos grupos – HAVING Statement
select idCategoria, sum(Valor) from Produto group by idCategoria having count(idCategoria)>1;

-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
select c.Identificacao, p.Identificacao, p.Descricao, p.Valor from Produto p inner join Categoria c on p.idCategoria = c.id;
	
    
-- PERGUNTAS A SEREM RESPONDIDAS
-- 1) Quantos pedidos foram feitos por cada cliente?
select Count(p.idCliente), c.Nome  from Pedido p  inner join Cliente c on p.idCliente = c.id   group by p.idCliente, c.Nome;

-- 2) Algum vendedor também é fornecedor?
select f.RazaoSocial from Fornecedor f where f.CNPJ in (select t.CNPJ from VendedorTerceiro t);

-- 3) Relação de produtos fornecedores e estoques;
select f.RazaoSocial, p.Identificacao, pe.Quantidade
    from Produto p
    inner join ProdutoFornecedor pf on p.id = pf.idProduto
    inner join Fornecedor f on f.id = pf.idFornecedor
    inner join ProdutoEstoque pe on p.id = pe.idProduto;

-- 4) Relação de nomes dos fornecedores e nomes dos produtos;-- 
select f.RazaoSocial as Fornecedor, p.Identificacao as Produto
    from Produto p
    inner join ProdutoFornecedor pf on p.id = pf.idProduto
    inner join Fornecedor f on f.id = pf.idFornecedor;
