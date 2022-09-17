--Fernando Luis Murillo Chacon 20141001980

USE master
GO

DROP DATABASE IF EXISTS ejercicioRepaso
GO

CREATE DATABASE ejercicioRepaso
GO

USE ejercicioRepaso
GO

CREATE TABLE aerolinea(
	codigo_aerolinea varchar(9) primary key not null,
	descuento decimal
)	
GO

CREATE TABLE boleto(
	codigo_boleto varchar(10) primary key not null,
	num_vuelo varchar(10) not null,
	fecha DATE, 
	destino varchar(50) not null,
	codigo_aerolinea varchar(9) not null
)
GO

ALTER TABLE boleto ADD CONSTRAINT fk_boleto_aero foreign key (codigo_aerolinea) references aerolinea(codigo_aerolinea)
ALTER TABLE boleto ADD CONSTRAINT ck_bol CHECK (destino IN ('México','Guatemala','Panamá'))
GO

ALTER TABLE aerolinea ADD CONSTRAINT ck_desc CHECK (descuento >= 10.00)
GO


CREATE TABLE hotel(
	codigo_hotel varchar(8) primary key not null,
	nombre varchar(20) not null,
	direccion varchar(50),
)
GO

CREATE TABLE cliente(
	identidad varchar(13) primary key not null,
	nombre varchar(50) not null,
	telefono varchar(11) not null,
	codigo_boleto varchar(10) not null
)
GO

ALTER TABLE cliente ADD CONSTRAINT fk_boleto_Cliente foreign key (codigo_boleto) references boleto(codigo_boleto)
GO

CREATE TABLE cliente_hotel(
	codigo_hotel varchar(8) not null,
	identidad varchar(13) not null,
	fechain DATE,
	fechaout DATE,
	cantidad_personas integer,

	CONSTRAINT fk_codigo_hotel foreign key (codigo_hotel) REFERENCES hotel(codigo_hotel),
	CONSTRAINT fk_identidad foreign key (identidad) REFERENCES cliente(identidad),
)
GO

ALTER TABLE cliente_hotel ADD CONSTRAINT pk_cl_hotel primary key(codigo_hotel,identidad)
ALTER TABLE cliente_hotel ADD CONSTRAINT df_cant_personas DEFAULT '0' for cantidad_personas
GO


/*
INSERT's de Pruebas
*/

insert into aerolinea values ('000010000',11.00)
insert into aerolinea values ('000010001',1.00)
insert into aerolinea values ('000010002',18.00)
insert into aerolinea values ('000010003',10.00)
GO

--En esta insercion SOLO México y Panamá entra como valor por las "´"
insert into boleto values ('0000000001','0000mx0000','2022/9/17','Mexico','000010000')
insert into boleto values ('0000000002','0000mx0001','2022/9/17','mexico','000010000')
insert into boleto values ('0000000003','0000mx0002','2022/9/17','México','000010000')

insert into boleto values ('0000000004','0000gt0000','2022/9/17','Guatemala','000010002')
insert into boleto values ('0000000005','0000gt0001','2022/9/17','guatemala','000010002')
insert into boleto values ('0000000006','0000gt0002','2022/9/17','GUATEMALA','000010002')

insert into boleto values ('0000000007','0000pn0000','2022/9/17','Panama','000010003')
insert into boleto values ('0000000008','0000pn0001','2022/9/17','Panamá','000010003')
insert into boleto values ('0000000009','0000pn0002','2022/9/17','panama','000010003')
GO

insert into hotel values ('00000cln','Clarion','Col. Alameda, Av. Juan Manuel Galvez, Teg.')
insert into hotel values ('00000llm','Las Lomas','Blv. Suyapa Contiguo a DAVIVIENDA, Teg.')
insert into hotel values ('00000inv','Inventado','Desconocido')
GO

insert into cliente values ('0801197000001','Jose Juan Laines Mendez','50397582200','0000000003')
insert into cliente values ('0802195500101','Maria Concepcion Portuaria','50388880033','0000000004')
insert into cliente values ('0811198002100','Fulano De Tal Carrasco','50398987880','0000000008')
GO

insert into cliente_hotel values ('00000cln','0801197000001','2022/9/17','2022/9/24',1)
insert into cliente_hotel values ('00000llm','0802195500101','2022/9/17','2022/9/27',2)
insert into cliente_hotel values ('00000inv','0811198002100','2022/9/17','2022/9/30',3)
GO

select * from boleto
select * from aerolinea
select * from cliente
select * from hotel
select * from cliente_hotel
GO
