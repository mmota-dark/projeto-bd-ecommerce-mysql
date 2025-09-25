-- =====================================================
-- Banco e criação de tabelas para cenário Ecommerce (IDs manuais, sem AUTO_INCREMENT por eu usar SQL online)
-- =====================================================
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabela cliente
CREATE TABLE IF NOT EXISTS client(
    idClient INT PRIMARY KEY,
    Fname VARCHAR(25) NOT NULL,
    Lname VARCHAR(25) NOT NULL,
    document VARCHAR(14) NOT NULL UNIQUE, -- CPF(11) ou CNPJ(14)
    ClientType ENUM('PF','PJ') DEFAULT 'PF',
    phone CHAR(11) NOT NULL UNIQUE,
    mail VARCHAR(100) NOT NULL UNIQUE,
    DateBirth DATE,
    address VARCHAR(255) NOT NULL,
    neighborhood VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    StateAcronym CHAR(2) NOT NULL,
    cep CHAR(9) NOT NULL,
    ClientDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela fornecedor
CREATE TABLE IF NOT EXISTS supplier(
    idSupplier INT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    neighborhood VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    StateAcronym CHAR(2) NOT NULL,
    cep CHAR(9) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    phone CHAR(11) NOT NULL
);

-- Tabela produtos
CREATE TABLE IF NOT EXISTS product(
    idProduct INT PRIMARY KEY,
    Pname VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    category ENUM('ELETRONICOS', 'VESTUARIO', 'MOVEIS', 'BRINQUEDOS') NOT NULL,
    weight FLOAT(6,2),
    color VARCHAR(20),
    width FLOAT(5,2),
    height FLOAT(5,2),
    length FLOAT(5,2),
    price DECIMAL(10,2),
    ProductDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Produto-Fornecedor (N:N)
CREATE TABLE IF NOT EXISTS ProductSupplier(
    idProduct INT,
    idSupplier INT,
    SupplierPrice DECIMAL(10,2),
    PRIMARY KEY(idProduct, idSupplier),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier)
);

-- Tabela pedidos
CREATE TABLE IF NOT EXISTS orders(
    idOrder INT PRIMARY KEY,
    OrdersDescription VARCHAR(255) NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    idClient INT,
    OrdersStatus ENUM('PROCESSANDO', 'EM ANDAMENTO', 'ENVIADO', 'ENTREGUE', 'CANCELADO') DEFAULT 'PROCESSANDO',
    freight DECIMAL(10,2) DEFAULT 15,
    OrdersDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- tabela pagamentos
CREATE TABLE IF NOT EXISTS payments(
    idPayment INT PRIMARY KEY,
    methodPayment ENUM('PIX', 'BOLETO', 'CARTAO', 'MAIS_CARTOES') NOT NULL,
    DatePayments DATE,
    PaymentsStatus ENUM('PROCESSANDO', 'APROVADO', 'NEGADO', 'PENDENTE') DEFAULT 'PROCESSANDO'
);

-- tabela pagamento_pedido (N:N)
CREATE TABLE IF NOT EXISTS PaymentOrder(
    idPayment INT,
    idOrder INT,
    Installments INT,
    ValuePayments DECIMAL(10,2) NOT NULL,
    TypePayment VARCHAR(45),
    PRIMARY KEY(idPayment, idOrder),
    FOREIGN KEY (idPayment) REFERENCES payments(idPayment),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- tabela estoque
CREATE TABLE IF NOT EXISTS storages(
    idStorage INT PRIMARY KEY,
    StorageLocation VARCHAR(100)
);

-- tabela produto_estoque (N:N)
CREATE TABLE IF NOT EXISTS ProductStorage(
    idProduct INT,
    idStorage INT,
    Quantity INT DEFAULT 0,
    PRIMARY KEY(idProduct, idStorage),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idStorage) REFERENCES storages(idStorage)
);

-- tabela VendedorTerceiro
CREATE TABLE IF NOT EXISTS seller(
    idSeller INT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    TradeName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) UNIQUE,
    Address VARCHAR(255)
);

-- tabela produto_vendedor (N:N)
CREATE TABLE IF NOT EXISTS ProductSeller(
    idSeller INT,
    idProduct INT,
    quantity INT DEFAULT 0,
    PRIMARY KEY (idSeller, idProduct),
    FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct)    
);

-- tabela produto_pedido (itens de pedido) (N:N)
CREATE TABLE IF NOT EXISTS ProductOrder(
    idProduct INT,
    idOrder INT,
    poQuantity INT,
    PRIMARY KEY(idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)   
);

-- tabela entrega
CREATE TABLE IF NOT EXISTS Delivery(
    idDelivery INT PRIMARY KEY,
    idOrder INT NOT NULL,
    Status ENUM('PENDENTE','EM TRANSPORTE','ENTREGUE','NAO ENTREGUE','CANCELADO','DEVOLVIDO') DEFAULT 'PENDENTE',
    TrackingCode VARCHAR(45),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- =====================================================
-- INSERTS: CLIENTS 
-- =====================================================
INSERT INTO client (idClient, Fname, Lname, document, ClientType, phone, mail, DateBirth, address, neighborhood, city, StateAcronym, cep) VALUES
(1,'Ana','Silva','12345678901','PF','11999990001','ana.silva@example.com','1990-05-10','Rua das Flores, 100','Centro','São Paulo','SP','01000-000'),
(2,'Bruno','Souza','98765432100','PF','11999990002','bruno.souza@example.com','1985-07-15','Av. Paulista, 200','Bela Vista','São Paulo','SP','01311-000'),
(3,'Carla','Oliveira','11223344556','PF','11999990003','carla.oliveira@example.com','1992-09-20','Rua Afonso, 45','Moema','São Paulo','SP','04000-000'),
(4,'Diego','Mendes','55443322119','PF','11999990004','diego.mendes@example.com','1988-12-01','Rua das Acacias, 78','Itaim','São Paulo','SP','04500-000'),
(5,'EmpresaX','Comercio','12345678000195','PJ','11333330001','finance@empresax.com',NULL,'Av. Brasil, 500','Bela Vista','São Paulo','SP','01310-000'),
(6,'Fernanda','Costa','77889900123','PF','11999990005','fernanda.costa@example.com','1995-03-11','Rua Frei Caneca, 12','Consolação','São Paulo','SP','01302-000'),
(7,'Gustavo','Pereira','66554433221','PF','11999990006','gustavo.pereira@example.com','1993-08-25','Rua Augusta, 310','Consolação','São Paulo','SP','01305-000'),
(8,'Helena','Martins','11224455789','PF','11999990007','helena.martins@example.com','1996-04-09','Rua Cerqueira César, 22','Consolação','São Paulo','SP','01306-000'),
(9,'Igor','Santos','99887766554','PF','11999990008','igor.santos@example.com','1991-01-19','Av. Sumaré, 90','Vila Madalena','São Paulo','SP','05435-000'),
(10,'Juliana','Alves','44332211009','PF','11999990009','juliana.alves@example.com','1989-10-12','Rua do Oratório, 10','Mooca','São Paulo','SP','03110-000'),
(11,'Ricardo','Ferreira','98765012345','PF','11999990010','ricardo.ferreira@example.com','1987-02-18','Rua Conselheiro, 120','Centro','Campinas','SP','13000-000'),
(12,'Mariana','Vieira','87654098765','PF','11999990011','mariana.vieira@example.com','1991-06-22','Rua Guilherme, 130','Taquaral','Campinas','SP','13001-000'),
(13,'André','Ramos','76543087654','PF','11999990012','andre.ramos@example.com','1994-11-05','Rua Barão, 140','Barra Funda','São Paulo','SP','01110-000'),
(14,'Paula','Teixeira','65432076543','PF','11999990013','paula.teixeira@example.com','1986-08-12','Rua Henrique, 150','Pinheiros','São Paulo','SP','05422-000'),
(15,'Eduardo','Lima','54321065432','PF','11999990014','eduardo.lima@example.com','1990-01-25','Av. Ipiranga, 160','Bela Vista','São Paulo','SP','01302-001'),
(16,'Joao','Barbosa','43210054321','PF','21999990015','joao.barbosa@example.com','1993-04-17','Rua Presidente, 170','Centro','Rio de Janeiro','RJ','20000-000'),
(17,'Luana','Rodrigues','32100043210','PF','21999990016','luana.rodrigues@example.com','1995-12-28','Rua Atlantica, 180','Copacabana','Rio de Janeiro','RJ','22021-000'),
(18,'Felipe','Cardoso','21000032109','PF','21999990017','felipe.cardoso@example.com','1988-09-09','Rua Voluntários, 190','Botafogo','Rio de Janeiro','RJ','22240-000'),
(19,'Tatiane','Pires','10900021098','PF','31999990018','tatiane.pires@example.com','1992-03-03','Av. Afonso Pena, 200','Centro','Belo Horizonte','MG','30130-000'),
(20,'Marcelo','Dias','09800010987','PF','31999990019','marcelo.dias@example.com','1985-07-27','Rua Curitiba, 210','Savassi','Belo Horizonte','MG','30140-000'),
(21,'EmpresaY','Distribuidora','44556677000188','PJ','31333330020','comercial@empresay.com',NULL,'Av. Amazonas, 220','Industrial','Contagem','MG','32100-000'),
(22,'Beatriz','Monteiro','12345098765','PF','41999990021','beatriz.monteiro@example.com','1994-06-14','Rua das Palmeiras, 230','Centro','Curitiba','PR','80000-000'),
(23,'Thiago','Moraes','23456109876','PF','41999990022','thiago.moraes@example.com','1990-09-01','Rua Marechal, 240','Agua Verde','Curitiba','PR','80010-000'),
(24,'Larissa','Campos','34567210987','PF','51999990023','larissa.campos@example.com','1989-02-22','Av. Borges, 250','Centro','Porto Alegre','RS','90000-000'),
(25,'EmpresaZ','ME','55667788000199','PJ','51333330024','vendas@empresaz.com',NULL,'Rua Padre, 260','Zona Norte','Porto Alegre','RS','91000-000'),
(26,'Rodrigo','Batista','45678321098','PF','47999990025','rodrigo.batista@example.com','1986-05-08','Rua João, 270','Centro','Florianopolis','SC','88000-000'),
(27,'Camila','Ferraz','56789432109','PF','47999990026','camila.ferraz@example.com','1992-11-19','Rua das Laranjeiras, 280','Trindade','Florianopolis','SC','88010-000'),
(28,'Mateus','Fonseca','67890543210','PF','81999990027','mateus.fonseca@example.com','1991-01-30','Av. Boa Viagem, 290','Boa Viagem','Recife','PE','51000-000'),
(29,'Aline','Gomes','78901654321','PF','81999990028','aline.gomes@example.com','1993-07-21','Rua do Sossego, 300','Casa Forte','Recife','PE','51010-000'),
(30,'Pedro','Santana','89012765432','PF','71999990029','pedro.santana@example.com','1988-04-02','Rua da França, 310','Centro','Salvador','BA','40000-000'),
(31,'Lucas','Araújo','90123876543','PF','71999990030','lucas.araujo@example.com','1990-08-18','Av. Sete, 320','Barra','Salvador','BA','40140-000'),
(32,'Marcos','Pinto','81234567890','PF','71999990031','marcos.pinto@example.com','1982-03-12','Rua das Acácias, 330','Graça','Salvador','BA','40220-000'),
(33,'Felicia','Almeida','70123456789','PF','81999990032','felicia.almeida@example.com','1996-10-05','Rua Alegre, 340','Boa Vista','Fortaleza','CE','60000-000'),
(34,'Sergio','Nunes','60123456780','PF','81999990033','sergio.nunes@example.com','1979-12-20','Av. Beira Mar, 350','Meireles','Fortaleza','CE','60100-000'),
(35,'EmpresaA','Logistica','99887766000177','PJ','11444440035','contato@empresaA.com',NULL,'Rod. Anhanguera, 360','Distrito Industrial','Campinas','SP','13010-000'),
(36,'Renata','Barros','55123467890','PF','11999990036','renata.barros@example.com','1990-11-11','Rua 7 de Abril, 370','Jardins','São Paulo','SP','01404-000'),
(37,'Claudio','Machado','44123456789','PF','11999990037','claudio.machado@example.com','1983-05-23','Rua Visconde, 380','Cerqueira César','São Paulo','SP','01306-001'),
(38,'Paulo','Moraes','33123456788','PF','21999990038','paulo.moraes@example.com','1984-02-02','Rua do Catete, 390','Laranjeiras','Rio de Janeiro','RJ','22220-000'),
(39,'Sofia','Lopes','22123456787','PF','21999990039','sofia.lopes@example.com','1997-09-09','Rua Ibituruna, 400','Centro','Belo Horizonte','MG','30150-000'),
(40,'Anderson','Ribeiro','11123456786','PF','31999990040','anderson.ribeiro@example.com','1981-06-06','Av. do Contorno, 410','Savassi','Belo Horizonte','MG','30160-000'),
(41,'EmpresaB','Atacado','77665544000166','PJ','11333330041','contato@empresaB.com',NULL,'Av. Industrial, 420','Distrito','São Paulo','SP','07000-000'),
(42,'Marta','Santos','66123456785','PF','11999990042','marta.santos@example.com','1988-01-15','Rua das Oliveiras, 430','Vila Mariana','São Paulo','SP','04110-000'),
(43,'Rafael','Cavalcanti','55123456784','PF','11999990043','rafael.cavalcanti@example.com','1992-07-07','Rua Princesa Isabel, 440','Jardim','Campinas','SP','13015-000'),
(44,'Bea','Carvalho','44123456783','PF','81999990044','bea.carvalho@example.com','1994-05-05','Rua do Limoeiro, 450','Boa Viagem','Recife','PE','51020-000'),
(45,'Vitor','Rocha','33123456782','PF','81999990045','vitor.rocha@example.com','1987-03-03','Av. Herculano, 460','Centro','Recife','PE','51030-000'),
(46,'EmpresaC','Com', '88990011222333','PJ','11333330046','finance@empresaC.com',NULL,'Rua Comercial, 470','Zona Oeste','São Paulo','SP','07010-000'),
(47,'Daniela','Moreira','22109876543','PF','11999990047','daniela.moreira@example.com','1991-12-01','Rua Maria, 480','Pinheiros','São Paulo','SP','05423-000'),
(48,'Igor','Azevedo','33109876542','PF','21999990048','igor.azevedo@example.com','1986-09-09','Rua Tenente, 490','Botafogo','Rio de Janeiro','RJ','22250-000'),
(49,'Patricia','Nogueira','44109876541','PF','31999990049','patricia.nogueira@example.com','1990-02-20','Rua das Pedras, 500','Centro','Belo Horizonte','MG','30170-000'),
(50,'Eduarda','Pimentel','55109876540','PF','11999990050','eduarda.pimentel@example.com','1993-08-08','Rua Nova, 510','Vila Madalena','São Paulo','SP','05424-000'),
(51,'EmpresaD','Servicos','22334455000177','PJ','11444440051','contato@empresaD.com',NULL,'Av. Comércio, 520','Distrito','Campinas','SP','13020-000'),
(52,'Gisele','Freitas','66109876539','PF','11999990052','gisele.freitas@example.com','1985-11-11','Rua das Palmeiras, 530','Jardim Botânico','Rio de Janeiro','RJ','22460-000'),
(53,'Tomas','Henrique','77123456788','PF','31999990053','tomas.henrique@example.com','1992-06-16','Rua XV de Novembro, 540','Savassi','Belo Horizonte','MG','30180-000'),
(54,'Camila','Ribeiro','88123456789','PF','41999990054','camila.ribeiro@example.com','1994-02-02','Av. do Comércio, 550','Centro','Curitiba','PR','80020-000'),
(55,'Rodrigo','Alves','99123456780','PF','51999990055','rodrigo.alves@example.com','1989-09-09','Rua Marechal, 560','Centro','Porto Alegre','RS','90010-000'),
(56,'Larissa','Melo','10123456781','PF','51999990056','larissa.melo@example.com','1990-10-10','Rua Souza, 570','Centro','Porto Alegre','RS','90020-000'),
(57,'Fabio','Lima','12123456782','PF','71999990057','fabio.lima@example.com','1982-05-05','Rua Direita, 580','Barra','Salvador','BA','40230-000'),
(58,'Bianca','Torres','13123456783','PF','71999990058','bianca.torres@example.com','1996-01-01','Rua Costa, 590','Ondina','Salvador','BA','40140-001'),
(59,'EmpresaE','Comercial','33445566000188','PJ','11444440059','vendas@empresaE.com',NULL,'Av. Comércio, 600','Distrito','Campinas','SP','13030-000'),
(60,'Marcos','Santos','14123456784','PF','81999990060','marcos.santos@example.com','1991-07-07','Rua Nova, 610','Boa Viagem','Recife','PE','51100-000');

-- =====================================================
-- INSERTS: FORNECEDORES 
-- =====================================================
INSERT INTO supplier (idSupplier, SocialName, cnpj, address, neighborhood, city, StateAcronym, cep, mail, phone) VALUES
(1,'Tech Eletronicos LTDA','11111111000101','Av. Tecnologia, 100','Distrito Tecnológico','São Paulo','SP','01010-000','comercial@techeletro.com','11980001111'),
(2,'Moda Brasil EIRELI','22222222000102','Rua da Moda, 200','Centro','São Paulo','SP','01020-000','contato@modabrasil.com','11980002222'),
(3,'Moveis Premium SA','33333333000103','Av. Casa, 300','Bela Vista','São Paulo','SP','01030-000','vendas@moveispremium.com','11980003333'),
(4,'Brinquedos Divertidos LTDA','44444444000104','Rua dos Brinquedos, 10','Vila Kids','São Paulo','SP','01040-000','contato@brinquedos.com','11980004444'),
(5,'Eletro World Comercio','55555555000105','Av. Eletro, 55','Centro','Rio de Janeiro','RJ','20010-000','vendas@eletroworld.com','21980005555'),
(6,'Fashion Store Ltda','66666666000106','Rua Fashion, 66','Jardins','São Paulo','SP','01410-000','contato@fashionstore.com','11980006666'),
(7,'Casa & Conforto ME','77777777000107','Av. Lar, 77','Zona Sul','Belo Horizonte','MG','30100-000','info@casaconforto.com','31980007777'),
(8,'Kids Mania Ltda','88888888000108','Rua Alegria, 88','Boa Vista','Recife','PE','51000-000','contato@kidsmania.com','81980008888'),
(9,'Tech Solutions SA','99999999000109','Av. Soluções, 99','Distrito Industrial','Campinas','SP','13010-000','suporte@techsolutions.com','19980009999'),
(10,'Roupas Estilo EIRELI','10101010000110','Rua Estilo, 101','Centro','Fortaleza','CE','60010-000','vendas@roupasestilo.com','85980001010'),
(11,'Moveis Planejados LTDA','11111112000111','Av. Design, 111','Bairro Nobre','Salvador','BA','40020-000','contato@moveisplanejados.com','71980001112'),
(12,'Brinquedos Criativos ME','12121212000112','Rua Criativa, 121','Vila Kids','Porto Alegre','RS','90020-000','contato@brinquedoscriativos.com','51980001212'),
(13,'Eletro Mais Ltda','13131313000113','Av. Eletro Mais, 131','Centro','São Paulo','SP','01050-000','vendas@eletromais.com','11980001313'),
(14,'Moda Fashion','14141414000114','Rua Fashion, 141','Zona Sul','Rio de Janeiro','RJ','22030-000','contato@modafashion.com','21980001414'),
(15,'Moveis Luxo SA','15151515000115','Av. Luxo, 151','Bairro Nobre','Brasília','DF','70010-000','vendas@moveisluxo.com','61380001515');

-- =====================================================
-- INSERTS: PRODUTOS
-- =====================================================
INSERT INTO product (idProduct, Pname, description, category, weight, color, width, height, length, price) VALUES
(1,'Smartphone X','Smartphone 128GB, 6GB RAM','ELETRONICOS',0.18,'Preto',7.2,14.8,0.8,2499.90),
(2,'Notebook Y','Notebook 15.6", i7, 16GB','ELETRONICOS',1.9,'Cinza',35.0,24.5,2.0,4599.00),
(3,'Tablet Z','Tablet 10", 64GB','ELETRONICOS',0.45,'Prata',24.6,16.5,0.8,1799.90),
(4,'Smart TV 50','TV LED 50" 4K','ELETRONICOS',11.5,'Preto',112.0,65.0,9.0,2899.90),
(5,'Headphone Pro','Headphone Bluetooth com cancelamento','ELETRONICOS',0.35,'Preto',18.0,20.0,8.0,699.90),
(6,'Smartwatch S','Relógio inteligente com GPS','ELETRONICOS',0.05,'Prata',4.0,4.5,1.2,999.90),
(7,'Câmera Ação','Câmera ação 4K','ELETRONICOS',0.12,'Preto',6.0,4.5,3.0,899.90),
(8,'Caixa Som','Speaker Bluetooth 20W','ELETRONICOS',1.2,'Preto',25.0,10.0,10.0,299.90),
(9,'Monitor 27','Monitor 27" 144Hz','ELETRONICOS',4.5,'Preto',62.0,37.0,6.0,1599.90),
(10,'SSD 1TB','SSD NVMe 1TB','ELETRONICOS',0.05,'Cinza',8.0,2.2,0.8,699.90),
(11,'Camiseta Básica','Camiseta algodão unissex','VESTUARIO',0.18,'Branca',NULL,NULL,NULL,49.90),
(12,'Calça Jeans','Calça jeans masculina','VESTUARIO',0.6,'Azul',NULL,NULL,NULL,129.90),
(13,'Jaqueta Couro','Jaqueta couro legítimo','VESTUARIO',1.2,'Preto',NULL,NULL,NULL,599.90),
(14,'Vestido Floral','Vestido feminino','VESTUARIO',0.25,'Colorido',NULL,NULL,NULL,199.90),
(15,'Blusa Moletom','Moletom unissex','VESTUARIO',0.55,'Cinza',NULL,NULL,NULL,179.90),
(16,'Sapato Social','Sapato masculino couro','VESTUARIO',0.9,'Preto',NULL,NULL,NULL,349.90),
(17,'Tênis Esportivo','Tênis corrida','VESTUARIO',0.8,'Branco',NULL,NULL,NULL,269.90),
(18,'Shorts Praia','Shorts masculino','VESTUARIO',0.2,'Azul',NULL,NULL,NULL,69.90),
(19,'Meia Esportiva','Par de meias','VESTUARIO',0.05,'Preto',NULL,NULL,NULL,19.90),
(20,'Boné Trucker','Boné estilo trucker','VESTUARIO',0.1,'Vermelho',NULL,NULL,NULL,59.90),
(21,'Sofá 3 Lugares','Sofá tecido, 3 lugares','MOVEIS',40.0,'Bege',200.0,90.0,100.0,2499.90),
(22,'Mesa Jantar 6','Mesa madeira 6 lugares','MOVEIS',60.0,'Marrom',180.0,80.0,100.0,1799.90),
(23,'Cadeira Gamer','Cadeira ergonômica','MOVEIS',25.0,'Preto',70.0,120.0,70.0,999.90),
(24,'Estante 4 Prateleiras','Estante MDF 4 prateleiras','MOVEIS',18.0,'Branco',100.0,180.0,35.0,899.90),
(25,'Rack TV','Rack para TV 50"','MOVEIS',20.0,'Nogal',150.0,50.0,40.0,699.90),
(26,'Mesa Escrivaninha','Escrivaninha com gaveta','MOVEIS',22.0,'Castanho',120.0,75.0,60.0,599.90),
(27,'Cama Casal','Cama box casal','MOVEIS',50.0,'Branco',160.0,50.0,200.0,1999.90),
(28,'Poltrona','Poltrona de leitura','MOVEIS',18.0,'Cinza',90.0,100.0,90.0,799.90),
(29,'Mesa Lateral','Mesa lateral pequena','MOVEIS',8.0,'Branco',40.0,55.0,40.0,249.90),
(30,'Armário Cozinha','Armário 3 portas','MOVEIS',35.0,'Branco',120.0,180.0,40.0,1599.90),
(31,'Boneca Interativa','Boneca com som e luz','BRINQUEDOS',1.2,'Rosa',30.0,50.0,15.0,199.90),
(32,'Carrinho Controle','Carrinho elétrico','BRINQUEDOS',2.2,'Vermelho',40.0,25.0,20.0,299.90),
(33,'Lego Classic','Kit blocos criativos','BRINQUEDOS',1.5,'Multicolorido',40.0,30.0,15.0,299.90),
(34,'Quebra-cabeça 1000p','Puzzle 1000 peças','BRINQUEDOS',1.0,'Multicolorido',50.0,35.0,5.0,79.90),
(35,'Pelucia Grande','Urso pelucia 80cm','BRINQUEDOS',1.8,'Marrom',40.0,80.0,30.0,149.90),
(36,'Jogo de Tabuleiro','Jogo família 4-6 jogadores','BRINQUEDOS',0.9,'Multicolorido',30.0,30.0,6.0,99.90),
(37,'Kit Arte','Kit desenho para crianças','BRINQUEDOS',0.7,'Colorido',30.0,20.0,5.0,59.90),
(38,'Boneco Aventura','Boneco articulado 30cm','BRINQUEDOS',0.6,'Verde',15.0,30.0,10.0,89.90),
(39,'Bola Futebol','Bola oficial tamanho 5','BRINQUEDOS',0.5,'Branco',22.0,22.0,22.0,79.90),
(40,'Pista HotWheels','Pista com loop','BRINQUEDOS',2.0,'Colorido',60.0,40.0,10.0,249.90);

-- =====================================================
-- Produto-Fornecedor (liga produtos e fornecedores) - alguns exemplos
-- =====================================================
INSERT INTO ProductSupplier (idProduct, idSupplier, SupplierPrice) VALUES
(1,1,2100.00),(2,5,4000.00),(3,2,120.00),(4,13,1500.00),(5,7,2200.00),
(6,1,850.00),(7,9,600.00),(8,1,220.00),(9,9,1400.00),(10,13,550.00),
(11,6,30.00),(12,14,350.00),(13,7,700.00),(14,15,650.00),(15,12,180.00),
(16,12,40.00),(17,6,450.00),(18,1,700.00),(19,2,120.00),(20,10,30.00),
(21,3,1800.00),(22,11,1300.00),(23,7,750.00),(24,15,450.00),(25,11,500.00),
(26,11,350.00),(27,3,1500.00),(28,15,700.00),(29,3,90.00),(30,15,1100.00),
(31,4,140.00),(32,8,220.00),(33,12,200.00),(34,11,50.00),(35,12,100.00),
(36,12,40.00),(37,12,20.00),(38,4,60.00),(39,8,50.00),(40,4,200.00);

-- =====================================================
-- INSERT: ESTOQUE (3 locais)
-- =====================================================
INSERT INTO storages (idStorage, StorageLocation) VALUES
(1,'Estoque Central - Galpao A'),
(2,'Estoque Zona Norte'),
(3,'Estoque Zona Sul');

-- =====================================================
-- INSERT: produto_estoque (quantidades iniciais)
-- =====================================================
INSERT INTO ProductStorage (idProduct, idStorage, Quantity) VALUES
(1,1,50),(2,1,30),(3,1,200),(4,1,40),(5,1,10),
(6,1,25),(7,2,60),(8,2,40),(9,1,20),(10,1,70),
(11,2,150),(12,2,80),(13,1,15),(14,3,20),(15,2,55),
(16,2,90),(17,1,45),(18,1,80),(19,3,100),(20,3,120),
(21,1,5),(22,1,6),(23,1,10),(24,3,14),(25,1,8),
(26,1,12),(27,3,4),(28,3,7),(29,2,20),(30,1,3),
(31,2,40),(32,2,30),(33,1,25),(34,2,60),(35,3,35),
(36,2,50),(37,2,80),(38,3,90),(39,1,110),(40,1,15);

-- =====================================================
-- INSERT: VENDEDORES (parceiros)
-- =====================================================
INSERT INTO seller (idSeller, SocialName, TradeName, CNPJ, Address) VALUES
(1,'Vendas Auto LTDA','AutoVendas','55110022000101','Rua dos Vendedores, 10'),
(2,'MotoCom Comercio','MotoCom','55220033000102','Av. Moto, 200'),
(3,'Outlet Fashion','Outlet Fashion','55330044000103','Rua Moda, 33'),
(4,'Brinquedos Revenda','BrinqRev','55440055000104','Rua Kids, 44'),
(5,'Casa Comercio','CasaCom','55550066000105','Av. Lar, 55');

-- =====================================================
-- INSERT: produto_vendedor (ofertas por seller)
-- =====================================================
INSERT INTO ProductSeller (idSeller, idProduct, quantity) VALUES
(1,1,10),(1,2,5),(2,7,20),(3,11,50),(3,12,30),
(4,31,40),(4,32,25),(5,21,2),(5,25,3),(3,20,15);

-- =====================================================
-- INSERTS: PEDIDOS 
-- =====================================================
INSERT INTO orders (idOrder, OrdersDescription, value, idClient, OrdersStatus, freight, OrdersDate) VALUES
(1,'Compra de Smartphone e acessorios',2799.90,1,'ENTREGUE',25.00,'2025-06-01 10:00:00'),
(2,'Compra Notebook',4599.00,2,'ENTREGUE',30.00,'2025-06-02 11:00:00'),
(3,'Camisetas e moletom',229.80,3,'ENTREGUE',15.00,'2025-06-03 12:00:00'),
(4,'Sofá 3 lugares',2499.90,4,'PROCESSANDO',120.00,'2025-06-04 13:00:00'),
(5,'Mesa jantar 6 lugares',1799.90,5,'ENVIADO',100.00,'2025-06-05 14:00:00'),
(6,'Brinquedos variados',559.80,6,'ENTREGUE',20.00,'2025-06-06 15:00:00'),
(7,'Tablet e capa',1899.90,7,'ENTREGUE',20.00,'2025-06-07 16:00:00'),
(8,'Headphone Pro',699.90,8,'ENTREGUE',15.00,'2025-06-08 17:00:00'),
(9,'Cadeira Gamer',999.90,9,'EM ANDAMENTO',60.00,'2025-06-09 10:00:00'),
(10,'Smartwatch e acessorios',1099.90,10,'ENTREGUE',15.00,'2025-06-10 10:30:00'),
(11,'Pneu e servicos',1200.00,11,'ENTREGUE',50.00,'2025-06-11 09:00:00'),
(12,'Jaqueta couro',599.90,12,'ENTREGUE',15.00,'2025-06-11 10:00:00'),
(13,'Cama casal',1999.90,13,'ENTREGUE',150.00,'2025-06-12 11:00:00'),
(14,'Microfone e acessórios',499.90,14,'ENTREGUE',15.00,'2025-06-12 12:00:00'),
(15,'Kit Lego e brinquedos',379.80,15,'ENTREGUE',20.00,'2025-06-13 13:00:00'),
(16,'SSD e monitor',2299.80,16,'ENTREGUE',25.00,'2025-06-14 14:00:00'),
(17,'Poltrona e decoração',899.90,17,'EM ANDAMENTO',60.00,'2025-06-15 15:00:00'),
(18,'Relógio Smartwatch',999.90,18,'ENTREGUE',15.00,'2025-06-16 16:00:00'),
(19,'Sapato social',349.90,19,'ENTREGUE',15.00,'2025-06-17 11:00:00'),
(20,'Mesa lateral e livros',349.90,20,'ENTREGUE',20.00,'2025-06-18 12:00:00'),
(21,'Varios eletrônicos',5399.70,1,'ENTREGUE',40.00,'2025-06-18 13:00:00'),
(22,'Roupas e acessórios',499.70,2,'PROCESSANDO',20.00,'2025-06-19 14:00:00'),
(23,'Brinquedos e jogos',179.80,3,'ENTREGUE',15.00,'2025-06-20 15:00:00'),
(24,'Estante modular',899.90,4,'EM ANDAMENTO',80.00,'2025-06-21 16:00:00'),
(25,'Cadeira gamer e mouse',1299.80,5,'CANCELADO',60.00,'2025-06-22 17:00:00'),
(26,'TV 50 polegadas',2899.90,6,'ENTREGUE',100.00,'2025-06-23 10:00:00'),
(27,'Mesa escritorio',599.90,7,'ENTREGUE',50.00,'2025-06-24 11:00:00'),
(28,'Jogos de tabuleiro',99.90,8,'ENTREGUE',15.00,'2025-06-24 12:00:00'),
(29,'Blusa moletom e camiseta',229.80,9,'ENTREGUE',15.00,'2025-06-25 13:00:00'),
(30,'Sapatos e meias',419.80,10,'ENTREGUE',15.00,'2025-06-26 14:00:00'),
(31,'Equipamentos de som',1299.90,11,'ENTREGUE',40.00,'2025-06-27 15:00:00'),
(32,'Acessorios carro',159.90,12,'ENTREGUE',20.00,'2025-06-28 16:00:00'),
(33,'Cozinha completa',3599.90,13,'PROCESSANDO',150.00,'2025-06-29 17:00:00'),
(34,'Mobiliario sala',3499.90,14,'ENTREGUE',120.00,'2025-06-30 10:00:00'),
(35,'Kit bebe',199.90,15,'ENTREGUE',20.00,'2025-07-01 11:00:00'),
(36,'Relogio e fone',1699.80,16,'ENTREGUE',20.00,'2025-07-02 12:00:00'),
(37,'Montagem armario',700.00,17,'EM ANDAMENTO',80.00,'2025-07-03 13:00:00'),
(38,'Brinquedos educativos',159.90,18,'ENTREGUE',15.00,'2025-07-04 14:00:00'),
(39,'Peças automotivas',499.90,19,'ENTREGUE',30.00,'2025-07-05 15:00:00'),
(40,'Material escritório',249.90,20,'ENTREGUE',20.00,'2025-07-06 16:00:00'),
(41,'Segundo pedido Ana - acessórios',199.90,1,'EM ANDAMENTO',15.00,'2025-07-07 10:00:00'),
(42,'Segundo pedido Bruno - roupa',299.90,2,'ENTREGUE',15.00,'2025-07-08 11:00:00'),
(43,'Terceiro pedido Ana - TV',2899.90,1,'PROCESSANDO',100.00,'2025-07-09 12:00:00'),
(44,'Pedido fornecedor EmpresaX',1500.00,5,'ENTREGUE',200.00,'2025-07-10 13:00:00'),
(45,'Pedido revenda',850.00,21,'ENTREGUE',50.00,'2025-07-11 14:00:00'),
(46,'Pedido empresaD',1200.00,51,'EM ANDAMENTO',80.00,'2025-07-12 15:00:00'),
(47,'Campanha promocional',999.90,25,'CANCELADO',40.00,'2025-07-13 09:00:00'),
(48,'Compra atacado',4599.00,41,'ENTREGUE',200.00,'2025-07-14 10:00:00'),
(49,'Pedido cliente 59',199.90,59,'ENTREGUE',20.00,'2025-07-15 11:00:00'),
(50,'Pedido de teste',49.90,60,'PROCESSANDO',15.00,'2025-07-16 12:00:00');

-- =====================================================
-- INSERTS: produto_pedido (itens por pedido) 
-- =====================================================
INSERT INTO ProductOrder (idProduct, idOrder, poQuantity) VALUES
(1,1,1),(5,1,2),(2,2,1),(11,3,3),(21,4,1),(22,5,1),
(7,6,2),(3,6,1),(3,7,2),(9,7,1),(5,8,1),(13,9,1),
(6,10,1),(12,11,1),(27,13,1),(14,14,1),(15,15,2),(10,16,1),
(23,17,1),(18,18,1),(16,19,1),(29,20,1),(1,21,1),(17,21,1),
(11,22,2),(31,23,1),(24,24,1),(23,25,1),(4,26,1),(26,27,1),
(36,28,1),(11,29,1),(16,30,1),(8,31,1),(25,32,1),(30,33,1),
(34,34,1),(31,35,1),(10,36,1),(37,37,1),(32,38,2),(39,39,4),
(19,40,2),(5,41,1),(11,42,3),(10,43,1),(2,44,2),(33,45,1),
(2,48,1),(31,49,1),(20,50,1),(40,24,1),(28,24,1);

-- =====================================================
-- INSERTS: Pagamento (um pagamento por pedido onde aplicavel) e PaymentOrder
-- =====================================================
INSERT INTO payments (idPayment, methodPayment, DatePayments, PaymentsStatus) VALUES
(1,'CARTAO','2025-06-01','APROVADO'),
(2,'PIX','2025-06-02','APROVADO'),
(3,'BOLETO','2025-06-03','APROVADO'),
(4,'PIX','2025-06-04','APROVADO'),
(5,'CARTAO','2025-06-05','APROVADO'),
(6,'PIX','2025-06-06','APROVADO'),
(7,'CARTAO','2025-06-07','APROVADO'),
(8,'CARTAO','2025-06-08','APROVADO'),
(9,'PIX','2025-06-09','PROCESSANDO'),
(10,'PIX','2025-06-10','APROVADO'),
(11,'BOLETO','2025-06-11','APROVADO'),
(12,'CARTAO','2025-06-11','APROVADO'),
(13,'PIX','2025-06-12','APROVADO'),
(14,'PIX','2025-06-12','APROVADO'),
(15,'PIX','2025-06-13','APROVADO'),
(16,'CARTAO','2025-06-14','APROVADO'),
(17,'BOLETO','2025-06-15','APROVADO'),
(18,'CARTAO','2025-06-16','APROVADO'),
(19,'BOLETO','2025-06-17','APROVADO'),
(20,'PIX','2025-06-18','APROVADO'),
(21,'CARTAO','2025-06-18','APROVADO'),
(22,'PIX','2025-06-19','PROCESSANDO'),
(23,'PIX','2025-06-20','APROVADO'),
(24,'CARTAO','2025-06-21','APROVADO'),
(25,'BOLETO','2025-06-22','APROVADO'),
(26,'PIX','2025-06-23','APROVADO'),
(27,'CARTAO','2025-06-24','APROVADO'),
(28,'PIX','2025-06-24','APROVADO'),
(29,'CARTAO','2025-06-25','APROVADO'),
(30,'PIX','2025-06-26','APROVADO'),
(31,'CARTAO','2025-06-27','APROVADO'),
(32,'PIX','2025-06-28','APROVADO'),
(33,'BOLETO','2025-06-29','PROCESSANDO'),
(34,'CARTAO','2025-06-30','APROVADO'),
(35,'PIX','2025-07-01','APROVADO'),
(36,'CARTAO','2025-07-02','APROVADO'),
(37,'PIX','2025-07-03','PROCESSANDO'),
(38,'PIX','2025-07-04','APROVADO'),
(39,'BOLETO','2025-07-05','APROVADO'),
(40,'PIX','2025-07-06','APROVADO'),
(41,'CARTAO','2025-07-07','PROCESSANDO'),
(42,'PIX','2025-07-08','APROVADO'),
(43,'CARTAO','2025-07-09','PROCESSANDO'),
(44,'PIX','2025-07-10','APROVADO'),
(45,'BOLETO','2025-07-11','APROVADO'),
(46,'PIX','2025-07-12','PROCESSANDO'),
(47,'CARTAO','2025-07-13','APROVADO'),
(48,'BOLETO','2025-07-14','APROVADO'),
(49,'PIX','2025-07-15','APROVADO'),
(50,'PIX','2025-07-16','PROCESSANDO');

-- =====================================================
-- PaymentOrder: relacionando pagamentos com pedidos (idPayment,idOrder)
-- =====================================================
INSERT INTO PaymentOrder (idPayment, idOrder, Installments, ValuePayments, TypePayment) VALUES
(1,1,6,2799.90,'CARTAO'),
(2,2,1,4599.00,'PIX'),
(3,3,1,229.80,'BOLETO'),
(4,4,1,2499.90,'PIX'),
(5,5,1,1799.90,'CARTAO'),
(6,6,2,559.80,'PIX'),
(7,7,1,1899.90,'CARTAO'),
(8,8,1,699.90,'CARTAO'),
(9,9,1,999.90,'PIX'),
(10,10,1,1099.90,'PIX'),
(11,11,1,1200.00,'BOLETO'),
(12,12,1,599.90,'CARTAO'),
(13,13,1,1999.90,'PIX'),
(14,14,1,499.90,'PIX'),
(15,15,1,379.80,'PIX'),
(16,16,1,2299.80,'CARTAO'),
(17,17,1,899.90,'BOLETO'),
(18,18,1,999.90,'CARTAO'),
(19,19,1,349.90,'BOLETO'),
(20,20,1,349.90,'PIX'),
(21,21,1,5399.70,'CARTAO'),
(22,22,2,499.70,'PIX'),
(23,23,1,179.80,'PIX'),
(24,24,1,899.90,'CARTAO'),
(25,25,1,1299.80,'BOLETO'),
(26,26,1,2899.90,'PIX'),
(27,27,1,599.90,'CARTAO'),
(28,28,1,99.90,'PIX'),
(29,29,1,229.80,'CARTAO'),
(30,30,1,419.80,'PIX'),
(31,31,1,1299.90,'CARTAO'),
(32,32,1,159.90,'PIX'),
(33,33,1,3599.90,'BOLETO'),
(34,34,1,3499.90,'CARTAO'),
(35,35,1,199.90,'PIX'),
(36,36,1,1699.80,'CARTAO'),
(37,37,1,700.00,'PIX'),
(38,38,1,159.90,'PIX'),
(39,39,1,499.90,'BOLETO'),
(40,40,1,249.90,'PIX'),
(41,41,1,199.90,'CARTAO'),
(42,42,1,299.90,'PIX'),
(43,43,1,2899.90,'CARTAO'),
(44,44,1,1500.00,'PIX'),
(45,45,1,850.00,'BOLETO'),
(46,46,1,1200.00,'PIX'),
(47,47,1,999.90,'CARTAO'),
(48,48,1,4599.00,'BOLETO'),
(49,49,1,199.90,'PIX'),
(50,50,1,49.90,'PIX');

-- =====================================================
-- INSERTS: ENTREGAS 
-- =====================================================
INSERT INTO Delivery (idDelivery, idOrder, Status, TrackingCode) VALUES
(1,1,'ENTREGUE','BRSP000111'),
(2,2,'ENTREGUE','BRSP000222'),
(3,3,'ENTREGUE','BRSP000333'),
(4,4,'PENDENTE',''),
(5,5,'EM TRANSPORTE','BRSP000555'),
(6,6,'ENTREGUE','BRSP000666'),
(7,7,'ENTREGUE','BRSP000777'),
(8,8,'ENTREGUE','BRSP000888'),
(9,9,'EM TRANSPORTE','BRSP000999'),
(10,10,'ENTREGUE','BRSP001000'),
(11,11,'ENTREGUE','BH00011122'),
(12,12,'ENTREGUE','BH00022233'),
(13,13,'ENTREGUE','CP00033344'),
(14,14,'ENTREGUE','SP00044455'),
(15,15,'ENTREGUE','SP00055566'),
(16,16,'ENTREGUE','RJ00066677'),
(17,17,'EM TRANSPORTE','SP00077788'),
(18,18,'ENTREGUE','RJ00088899'),
(19,19,'ENTREGUE','BH00099900'),
(20,20,'ENTREGUE','BA00111122'),
(21,21,'ENTREGUE','SP00122233'),
(22,22,'PENDENTE',''),
(23,23,'ENTREGUE','RE00133344'),
(24,24,'EM TRANSPORTE','SP00144455'),
(25,25,'CANCELADO',''),
(26,26,'ENTREGUE','RJ00166677'),
(27,27,'ENTREGUE','CP00177788'),
(28,28,'ENTREGUE','RE00188899'),
(29,29,'ENTREGUE','SP00199900'),
(30,30,'ENTREGUE','SP00200011'),
(31,31,'ENTREGUE','SP00211122'),
(32,32,'ENTREGUE','SP00222233'),
(33,33,'PENDENTE',''),
(34,34,'ENTREGUE','SP00244455'),
(35,35,'ENTREGUE','SP00255566'),
(36,36,'ENTREGUE','SP00266677'),
(37,37,'EM TRANSPORTE','SP00277788'),
(38,38,'ENTREGUE','SP00288899'),
(39,39,'ENTREGUE','BH00300011'),
(40,40,'ENTREGUE','SP00311122'),
(41,41,'EM TRANSPORTE','SP00322233'),
(42,42,'ENTREGUE','SP00333344'),
(43,43,'NAO ENTREGUE',''),
(44,44,'DEVOLVIDO','SP00355566'),
(45,45,'DEVOLVIDO','SP00366677'),
(46,46,'PENDENTE',''),
(47,47,'CANCELADO','PO00477788'),
(48,48,'ENTREGUE','SP00488899'),
(49,49,'ENTREGUE','CP00499900'),
(50,50,'PENDENTE','');
