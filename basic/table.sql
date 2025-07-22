-- table types
-- number, integer, float, decimal
-- varchar2, char
-- date, timestamp

create table pessoa_fisica(
    id number primary key,
    nome varchar2(100) not null,
    altura number(3,2) not null,
    cpf varchar2(11) not null unique,
    data_nascimento date not null
    created_at timestamp default current_timestamp not null,
);

    insert into pessoa_fisica (id, nome, altura, cpf, data_nascimento) values (1, 'João da Silva', 1.75, '12345678901', to_date('1990-01-01', 'YYYY-MM-DD'));

select * from pessoa_fisica;

create table uf(
    id number primary key,
    nome varchar2(100) not null,
    cod_uf_ibge number(2) not null unique,
    sigla char(2) not null unique
);

    insert into uf (id, nome, cod_uf_ibge, sigla) values (1, 'São Paulo', 35, 'SP');

create table cidade(
    id number primary key,
    nome varchar2(100) not null,
    cod_cidade_ibge number(7) not null unique,
    uf_id number not null references uf(id) -- relacionamento com uf(id) (chave estrangeira),
);

    insert into cidade (id, nome, cod_cidade_ibge, uf_id) values (1, 'São Paulo', 3550308, 1);

create table pessoa_endereco(
    id number primary key,
    pessoa_fisica_id number not null references pessoa_fisica(id), -- relacionamento com pessoa_fisica(id) (chave estrangeira),
    cidade_id number not null references cidade(id), -- relacionamento com cidade(id) (chave estrangeira),
    logradouro varchar2(200) not null,
    numero varchar2(10) not null,
    complemento varchar2(100),
    bairro varchar2(100) not null,
    cep varchar2(8) not null
);

    insert into pessoa_endereco (id, pessoa_fisica_id, cidade_id, logradouro, numero, complemento, bairro, cep) 
        values (1, 1, 1, 'Rua A', '123', 'Apto 1', 'Centro', '01234-567');

    select * from pessoa_endereco where pessoa_fisica_id = 1;

---- Alter
create table test(
    id number primary key,
    nome varchar2(100) not null
);

alter table test add(
    descricao varchar2(255)
);
alter table test modify(
    descricao varchar2(500) not null
);
alter table test rename column descricao to detalhes;
alter table test rename column detalhes to descricao;
alter table test drop(
    descricao
);

-- rename table
alter table test rename to teste;
alter table teste rename to test;

---- Drop Table
drop table pessoa_fisica;