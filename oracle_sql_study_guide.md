# Guia de Estudo - Oracle SQL Completo

## Índice

1. [Consultando Dados com SELECT](#1-consultando-dados-com-select)
2. [Restringindo e Ordenando Dados](#2-restringindo-e-ordenando-dados)
3. [Funções Single-Row, de Conversão e Expressões Condicionais](#3-funções-single-row-de-conversão-e-expressões-condicionais)
4. [Agregando Dados com Funções de Grupo](#4-agregando-dados-com-funções-de-grupo)
5. [Exibindo Dados de Múltiplas Tabelas (JOINs)](#5-exibindo-dados-de-múltiplas-tabelas-joins)
6. [Utilizando Subconsultas](#6-utilizando-subconsultas)
7. [Operadores SET](#7-operadores-set)
8. [Comandos DML (Manipulação de Dados)](#8-comandos-dml-manipulação-de-dados)
9. [Comandos DDL (Criação e Gerenciamento de Tabelas)](#9-comandos-ddl-criação-e-gerenciamento-de-tabelas)
10. [Criando e Gerenciando Constraints](#10-criando-e-gerenciando-constraints)
11. [Criando e Gerenciando Visões (Views)](#11-criando-e-gerenciando-visões-views)
12. [Criando e Gerenciando Sequências (Sequences)](#12-criando-e-gerenciando-sequências-sequences)
13. [Criando e Gerenciando Índices (Indexes)](#13-criando-e-gerenciando-índices-indexes)
14. [Criando Sinônimos (Synonyms)](#14-criando-sinônimos-synonyms)
15. [Utilizando o SQL*Plus](#15-utilizando-o-sqlplus)
16. [Objetos do Banco de Dados e Dicionário de Dados](#16-objetos-do-banco-de-dados-e-dicionário-de-dados)
17. [Manipulação de Dados Avançada](#17-manipulação-de-dados-avançada)
18. [Recuperação de Dados com FLASHBACK](#18-recuperação-de-dados-com-flashback)
19. [Consultas Hierárquicas](#19-consultas-hierárquicas)
20. [Expressões Regulares](#20-expressões-regulares)
21. [Tabelas Temporárias](#21-tabelas-temporárias)
22. [Globalização e Fuso Horário](#22-globalização-e-fuso-horário)
23. [Subconsultas Avançadas](#23-subconsultas-avançadas)
24. [Gerando Scripts SQL Dinâmicos](#24-gerando-scripts-sql-dinâmicos)
25. [Aperfeiçoando a Cláusula GROUP BY](#25-aperfeiçoando-a-cláusula-group-by)
26. [Visões Materializadas](#26-visões-materializadas)

---

## 1. Consultando Dados com SELECT

Esta seção aborda os fundamentos da recuperação de dados de tabelas no Oracle.

### 1.1 Comando DESCRIBE
Utilizado para visualizar a estrutura de uma tabela, como nomes de colunas, tipos de dados e se aceitam valores nulos.

```sql
DESCRIBE employees;
DESCRIBE departments;
```

### 1.2 Selecionando Todas as Colunas
O asterisco (*) é um coringa para selecionar todas as colunas de uma tabela.

```sql
SELECT * 
FROM departments;
```

### 1.3 Selecionando Colunas Específicas
Para otimizar a consulta, liste apenas as colunas desejadas.

```sql
SELECT employee_id, first_name, last_name, salary
FROM employees;
```

### 1.4 Operadores Aritméticos
É possível realizar cálculos diretamente no SELECT. A ordem de precedência é a mesma da matemática (multiplicação/divisão antes de adição/subtração), e parênteses podem ser usados para alterar essa ordem.

```sql
-- Aumento de 15% no salário
SELECT first_name, salary, salary * 1.15
FROM employees;

-- Usando parênteses para alterar a precedência
SELECT first_name, salary, (salary + 100) * 1.15
FROM employees;
```

### 1.5 Valores Nulos (NULL)
Um valor NULL representa ausência de valor. Qualquer operação aritmética com NULL resulta em NULL.

```sql
-- O cálculo de comissão será nulo se commission_pct for nulo
SELECT first_name, 200000 * commission_pct
FROM employees;
```

### 1.6 Alias de Coluna
Renomeia o cabeçalho de uma coluna na saída da consulta, usando a palavra-chave AS ou simplesmente um espaço. Aspas duplas são necessárias para aliases com espaços ou caracteres especiais.

```sql
SELECT first_name AS nome, 
       last_name "Sobrenome", 
       salary "Salário ($)"
FROM employees;
```

### 1.7 Operador de Concatenação (||)
Une duas ou mais strings ou colunas em uma única coluna de saída.

```sql
SELECT first_name || ' ' || last_name "Funcionário"
FROM employees;
```

#### Operador q
Permite definir um delimitador para strings que contêm aspas simples, evitando a necessidade de escapar o caractere.

```sql
SELECT department_name || q'[ Department's Manager Id: ]' || manager_id
FROM departments;
```

### 1.8 Eliminando Linhas Duplicadas com DISTINCT
Retorna apenas os valores únicos de uma ou mais colunas.

```sql
SELECT DISTINCT department_id
FROM employees;
```

---

## 2. Restringindo e Ordenando Dados

Aprenda a filtrar e ordenar as linhas retornadas por uma consulta.

### 2.1 Cláusula WHERE
Filtra as linhas com base em uma condição. É sensível a maiúsculas e minúsculas para strings e requer um formato de data específico.

```sql
SELECT employee_id, last_name, job_id, department_id
FROM employees
WHERE department_id = 60;

SELECT first_name, last_name
FROM employees
WHERE last_name = 'King';
```

### 2.2 Operadores de Comparação

#### BETWEEN ... AND ...
Seleciona valores dentro de um intervalo inclusivo.

```sql
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 5000 AND 10000;
```

#### IN (...)
Compara com uma lista de valores.

```sql
SELECT first_name, department_id
FROM employees
WHERE department_id IN (10, 20, 30);
```

#### LIKE
Utilizado para buscar padrões em strings. `%` representa zero ou mais caracteres, e `_` representa um único caractere.

```sql
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'S%';

SELECT first_name, last_name
FROM employees
WHERE first_name LIKE '_teve_';
```

#### IS NULL / IS NOT NULL
A única forma correta de testar valores nulos.

```sql
SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NULL;

SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;
```

### 2.3 Operadores Lógicos (AND, OR, NOT)
Combinam múltiplas condições na cláusula WHERE. AND tem precedência sobre OR. Use parênteses para garantir a ordem de avaliação desejada.

```sql
-- Sem parênteses, AND é avaliado primeiro
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = 'SA_REP' OR job_id = 'IT_PROG' AND salary > 10000;

-- Com parênteses, OR é avaliado primeiro
SELECT last_name, job_id, salary
FROM employees
WHERE (job_id = 'SA_REP' OR job_id = 'IT_PROG') AND salary > 10000;
```

### 2.4 Cláusula ORDER BY
Ordena as linhas retornadas.

- **ASC** para ordem ascendente (padrão)
- **DESC** para descendente

Pode-se ordenar por um alias de coluna, pela posição da coluna na lista SELECT, ou por múltiplas colunas.

```sql
SELECT last_name, department_id, salary
FROM employees
ORDER BY department_id, salary DESC;
-- Ordena por departamento e, dentro de cada um, por salário decrescente
```

### 2.5 Variáveis de Substituição (&, &&)
Usadas em ferramentas como SQL*Plus para tornar os scripts interativos, solicitando um valor ao usuário no momento da execução.

```sql
SELECT first_name, salary
FROM employees
WHERE salary > &salario_minimo;
```

---

## 3. Funções Single-Row, de Conversão e Expressões Condicionais

Funções que operam em linhas individuais para manipular dados.

### 3.1 Funções de Caractere

#### Conversão de Caso
```sql
SELECT UPPER(first_name), LOWER(last_name)
FROM employees;
```

#### Manipulação de Strings
```sql
-- CONCAT - Concatena strings
SELECT CONCAT(first_name, last_name) "Nome Completo"
FROM employees;

-- SUBSTR - Extrai substring
SELECT SUBSTR(first_name, 1, 3) "Iniciais"
FROM employees;

-- LENGTH - Retorna o tamanho da string
SELECT first_name, LENGTH(first_name) "Tamanho"
FROM employees;

-- INSTR - Encontra posição de substring
SELECT INSTR(first_name, 'a') "Posição do 'a'"
FROM employees;

-- LPAD/RPAD - Preenche à esquerda/direita
SELECT LPAD(first_name, 15, '*') "Nome Preenchido"
FROM employees;

-- REPLACE - Substitui caracteres
SELECT REPLACE(phone_number, '.', '-') "Telefone"
FROM employees;
```

### 3.2 Funções Numéricas

```sql
-- ROUND - Arredonda números
SELECT ROUND(salary/12, 2) "Salário Mensal"
FROM employees;

-- TRUNC - Trunca números
SELECT TRUNC(salary/12, 2) "Salário Mensal Truncado"
FROM employees;

-- MOD - Resto da divisão
SELECT MOD(salary, 1000) "Resto"
FROM employees;

-- ABS - Valor absoluto
SELECT ABS(-100) "Valor Absoluto" FROM dual;

-- SQRT - Raiz quadrada
SELECT SQRT(salary) "Raiz do Salário"
FROM employees;
```

### 3.3 Funções de Data

```sql
-- SYSDATE - Data e hora atuais
SELECT SYSDATE FROM dual;

-- Cálculos com datas
SELECT first_name, hire_date, SYSDATE - hire_date "Dias Trabalhados"
FROM employees;

-- MONTHS_BETWEEN - Diferença em meses
SELECT first_name, MONTHS_BETWEEN(SYSDATE, hire_date) "Meses Trabalhados"
FROM employees;

-- ADD_MONTHS - Adiciona meses
SELECT ADD_MONTHS(SYSDATE, 6) "Daqui 6 meses" FROM dual;

-- NEXT_DAY - Próximo dia da semana
SELECT NEXT_DAY(SYSDATE, 'MONDAY') "Próxima Segunda" FROM dual;

-- LAST_DAY - Último dia do mês
SELECT LAST_DAY(SYSDATE) "Último dia do mês" FROM dual;
```

### 3.4 Funções de Conversão

#### TO_CHAR
Converte números ou datas para o formato de string, utilizando máscaras de formatação.

```sql
-- Formatando números
SELECT salary, TO_CHAR(salary, '$999,999.99') "Salário Formatado"
FROM employees;

-- Formatando datas
SELECT hire_date, TO_CHAR(hire_date, 'DD/MM/YYYY') "Data Contratação"
FROM employees;
```

#### TO_NUMBER
Converte uma string para número.

```sql
SELECT TO_NUMBER('123.45') "Número" FROM dual;
```

#### TO_DATE
Converte uma string para o formato de data, especificando a máscara de entrada.

```sql
SELECT TO_DATE('01/01/2023', 'DD/MM/YYYY') "Nova Data" FROM dual;
```

### 3.5 Funções para Tratamento de NULL

#### NVL
Se a primeira expressão for nula, retorna a segunda; caso contrário, retorna a primeira.

```sql
SELECT first_name, NVL(commission_pct, 0) "Comissão"
FROM employees;
```

#### NVL2
Se a primeira expressão não for nula, retorna a segunda; se for nula, retorna a terceira.

```sql
SELECT first_name, NVL2(commission_pct, 'COM COMISSÃO', 'SEM COMISSÃO') "Status"
FROM employees;
```

#### COALESCE
Retorna a primeira expressão não nula na lista.

```sql
SELECT COALESCE(commission_pct, salary * 0.1, 0) "Comissão Calculada"
FROM employees;
```

### 3.6 Expressões Condicionais

#### CASE
Implementa lógica IF-THEN-ELSE dentro do SQL. É o padrão ANSI e mais flexível.

```sql
SELECT last_name, job_id, salary,
       CASE job_id
           WHEN 'IT_PROG' THEN 1.10 * salary
           WHEN 'ST_CLERK' THEN 1.15 * salary
           ELSE salary
       END "NOVO SALARIO"
FROM employees;
```

#### DECODE
Função específica do Oracle que realiza a mesma tarefa do CASE de forma mais compacta, mas menos legível.

```sql
SELECT last_name, job_id, salary,
       DECODE(job_id, 
              'IT_PROG', 1.10 * salary,
              'ST_CLERK', 1.15 * salary,
              salary) "NOVO SALARIO"
FROM employees;
```

---

## 4. Agregando Dados com Funções de Grupo

Funções que operam sobre um conjunto de linhas para retornar um único resultado.

### 4.1 Funções Comuns
- **AVG()** - média
- **SUM()** - soma
- **MIN()** - mínimo
- **MAX()** - máximo
- **COUNT()** - contagem

```sql
SELECT AVG(salary) "Salário Médio",
       SUM(salary) "Total Salários",
       MIN(salary) "Menor Salário",
       MAX(salary) "Maior Salário",
       COUNT(*) "Total Funcionários"
FROM employees;
```

### 4.2 Tratamento de NULL
Funções de grupo ignoram valores NULL, exceto COUNT(*). Para incluí-los, use NVL.

```sql
-- Média incluindo valores nulos como zero
SELECT AVG(NVL(commission_pct, 0)) "Média Comissão"
FROM employees;
```

### 4.3 Variações do COUNT

```sql
-- COUNT(*) - Conta todas as linhas
SELECT COUNT(*) "Total Funcionários" FROM employees;

-- COUNT(column) - Conta as linhas onde a coluna não é nula
SELECT COUNT(commission_pct) "Funcionários com Comissão" FROM employees;

-- COUNT(DISTINCT column) - Conta os valores distintos não nulos
SELECT COUNT(DISTINCT department_id) "Departamentos com Funcionários" FROM employees;
```

### 4.4 Cláusula GROUP BY
Agrupa linhas que têm os mesmos valores em colunas especificadas, para que as funções de grupo possam operar em cada grupo. Qualquer coluna na lista SELECT que não seja uma função de grupo deve estar na cláusula GROUP BY.

```sql
SELECT department_id, AVG(salary) "Salário Médio"
FROM employees
GROUP BY department_id
ORDER BY department_id;
```

### 4.5 Cláusula HAVING
Filtra os resultados depois do agrupamento. Enquanto WHERE filtra linhas antes de agrupar, HAVING filtra os grupos.

```sql
SELECT department_id, MAX(salary) "Maior Salário"
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;
```

---

## 5. Exibindo Dados de Múltiplas Tabelas (JOINs)

Combina linhas de duas ou mais tabelas com base em colunas relacionadas.

### 5.1 Tipos de JOIN (Sintaxe ANSI - Recomendada)

#### INNER JOIN
Retorna apenas as linhas que possuem correspondência em ambas as tabelas. A palavra-chave INNER é opcional.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

#### LEFT OUTER JOIN
Retorna todas as linhas da tabela à esquerda e as correspondentes da tabela à direita. Se não houver correspondência, as colunas da direita virão como NULL.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON e.department_id = d.department_id;
```

#### RIGHT OUTER JOIN
O oposto do LEFT JOIN. Retorna todas as linhas da tabela à direita.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;
```

#### FULL OUTER JOIN
Retorna todas as linhas de ambas as tabelas, preenchendo com NULL onde não houver correspondência.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;
```

#### CROSS JOIN
Gera um produto cartesiano, combinando cada linha de uma tabela com cada linha da outra.

```sql
SELECT e.first_name, d.department_name
FROM employees e
CROSS JOIN departments d;
```

#### SELF JOIN
Junta uma tabela com ela mesma. É necessário usar aliases de tabela para distinguir as "duas" tabelas.

```sql
SELECT emp.first_name "Funcionário", mgr.first_name "Gerente"
FROM employees emp
JOIN employees mgr ON emp.manager_id = mgr.employee_id;
```

### 5.2 Cláusulas de Junção

#### ON
A condição de junção mais comum e flexível, especificando as colunas que se relacionam.

```sql
SELECT e.first_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

#### USING
Usada quando as colunas de junção têm o mesmo nome em ambas as tabelas.

```sql
SELECT first_name, department_name
FROM employees e
JOIN departments d USING (department_id);
```

#### NATURAL JOIN
Realiza a junção em todas as colunas que têm o mesmo nome. Deve ser usado com cautela.

```sql
SELECT first_name, department_name
FROM employees
NATURAL JOIN departments;
```

### 5.3 Junções Não Equi (Nonequijoins)
A condição de junção usa um operador diferente de igualdade, como BETWEEN.

```sql
SELECT e.first_name, e.salary, j.grade_level
FROM employees e
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;
```

### 5.4 Sintaxe Antiga do Oracle
Coloca as tabelas na cláusula FROM e as condições de junção na cláusula WHERE. Para outer joins, o operador (+) é usado. Esta sintaxe não é recomendada.

```sql
-- Sintaxe antiga (não recomendada)
SELECT e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

-- Outer join com sintaxe antiga
SELECT e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);
```

---

## 6. Utilizando Subconsultas

Uma subconsulta (ou subquery) é um SELECT aninhado dentro de outro comando SQL.

### 6.1 Subconsulta Single-Row
Retorna no máximo uma linha. Pode ser usada com operadores de comparação simples (=, >, <).

```sql
-- Encontrar funcionários que ganham mais que a média salarial
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

### 6.2 Subconsulta Multiple-Row
Retorna múltiplas linhas. Deve ser usada com operadores que suportam listas:

#### IN
Igual a qualquer valor na lista retornada.

```sql
SELECT first_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id 
                        FROM departments 
                        WHERE location_id = 1700);
```

#### ANY
Compara um valor com cada valor retornado. `< ANY` significa "menor que o máximo".

```sql
SELECT first_name, salary
FROM employees
WHERE salary < ANY (SELECT salary 
                    FROM employees 
                    WHERE department_id = 30);
```

#### ALL
Compara um valor com todos os valores retornados. `< ALL` significa "menor que o mínimo".

```sql
SELECT first_name, salary
FROM employees
WHERE salary < ALL (SELECT salary 
                    FROM employees 
                    WHERE department_id = 30);
```

### 6.3 Subconsulta Correlacionada
A subconsulta interna depende de um valor da consulta externa para ser processada. Ela é executada uma vez para cada linha da consulta externa.

```sql
SELECT first_name, salary, department_id
FROM employees e1
WHERE salary > (SELECT AVG(salary) 
                FROM employees e2 
                WHERE e2.department_id = e1.department_id);
```

### 6.4 Operador EXISTS
Testa a existência de linhas em um resultado de subconsulta. Retorna TRUE se a subconsulta retornar pelo menos uma linha. NOT EXISTS faz o oposto.

```sql
SELECT first_name, last_name
FROM employees e
WHERE EXISTS (SELECT 1 
              FROM departments d 
              WHERE d.department_id = e.department_id 
              AND d.location_id = 1700);
```

### 6.5 Subconsultas na Cláusula FROM (Inline View)
A subconsulta cria uma tabela virtual que pode ser usada na consulta principal.

```sql
SELECT first_name, salary
FROM (SELECT first_name, salary 
      FROM employees 
      ORDER BY salary DESC)
WHERE ROWNUM <= 5;
```

---

## 7. Operadores SET

Combinam os resultados de duas ou mais consultas SELECT em um único resultado. As consultas devem ter o mesmo número de colunas e tipos de dados correspondentes.

### 7.1 UNION
Retorna todas as linhas distintas de ambas as consultas.

```sql
SELECT employee_id, first_name FROM employees
UNION
SELECT customer_id, first_name FROM customers;
```

### 7.2 UNION ALL
Retorna todas as linhas de ambas as consultas, incluindo as duplicatas. É mais rápido por não verificar duplicidade.

```sql
SELECT employee_id, first_name FROM employees
UNION ALL
SELECT customer_id, first_name FROM customers;
```

### 7.3 INTERSECT
Retorna apenas as linhas que aparecem em ambas as consultas.

```sql
SELECT employee_id FROM employees
INTERSECT
SELECT manager_id FROM employees;
```

### 7.4 MINUS
Retorna as linhas da primeira consulta que não estão na segunda.

```sql
SELECT employee_id FROM employees
MINUS
SELECT manager_id FROM employees WHERE manager_id IS NOT NULL;
```

---

## 8. Comandos DML (Manipulação de Dados)

Comandos para inserir, atualizar e excluir dados em tabelas.

### 8.1 INSERT
Adiciona novas linhas a uma tabela.

#### Inserção com valores específicos
```sql
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (280, 'Public Relations', 100, 1700);
```

#### Inserção com valores NULL
```sql
-- NULL explícito
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (290, 'Marketing', NULL, 1700);

-- NULL implícito (omitindo a coluna)
INSERT INTO departments (department_id, department_name, location_id)
VALUES (300, 'Finance', 1700);
```

#### Inserção a partir de subconsulta
```sql
INSERT INTO sales_reps (id, name, salary, commission_pct)
SELECT employee_id, first_name, salary, commission_pct
FROM employees
WHERE job_id = 'SA_REP';
```

### 8.2 UPDATE
Modifica dados existentes em uma tabela. A cláusula WHERE é crucial para especificar quais linhas atualizar; sem ela, todas as linhas serão atualizadas.

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department_id = 60;

-- Update com subconsulta
UPDATE employees
SET (job_id, salary) = (SELECT job_id, salary 
                        FROM employees 
                        WHERE employee_id = 205)
WHERE employee_id = 206;
```

### 8.3 DELETE
Remove linhas de uma tabela. Assim como no UPDATE, a cláusula WHERE determina quais linhas remover.

```sql
DELETE FROM employees
WHERE department_id = 60;

-- Delete com subconsulta
DELETE FROM employees
WHERE department_id = (SELECT department_id 
                       FROM departments 
                       WHERE department_name = 'Finance');
```

### 8.4 Controle de Transação

#### COMMIT
Salva permanentemente todas as alterações feitas na transação atual.

```sql
COMMIT;
```

#### ROLLBACK
Desfaz todas as alterações feitas na transação atual que ainda não foram "commitadas".

```sql
ROLLBACK;
```

#### SAVEPOINT
Cria um ponto de marcação dentro de uma transação, para o qual se pode reverter parcialmente usando ROLLBACK TO SAVEPOINT.

```sql
SAVEPOINT antes_update;
UPDATE employees SET salary = salary * 1.10;
ROLLBACK TO SAVEPOINT antes_update;
```

---

## 9. Comandos DDL (Criação e Gerenciamento de Tabelas)

Comandos para definir e gerenciar a estrutura dos objetos do banco de dados.

### 9.1 CREATE TABLE
Cria uma nova tabela. É possível definir colunas, tipos de dados e valores padrão (DEFAULT).

```sql
CREATE TABLE employees_copy (
    employee_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) UNIQUE,
    hire_date DATE DEFAULT SYSDATE,
    salary NUMBER(8,2) CHECK (salary > 0)
);
```

#### Criação a partir de subconsulta
```sql
CREATE TABLE high_salary_employees AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 10000;
```

### 9.2 ALTER TABLE
Modifica a estrutura de uma tabela existente.

#### ADD - Adiciona uma nova coluna
```sql
ALTER TABLE employees_copy
ADD (phone_number VARCHAR2(20));
```

#### MODIFY - Altera as propriedades de uma coluna
```sql
ALTER TABLE employees_copy
MODIFY (first_name VARCHAR2(30));
```

#### RENAME COLUMN - Renomeia uma coluna
```sql
ALTER TABLE employees_copy
RENAME COLUMN phone_number TO telephone;
```

#### DROP COLUMN - Remove uma coluna
```sql
ALTER TABLE employees_copy
DROP COLUMN telephone;
```

### 9.3 TRUNCATE TABLE
Remove todas as linhas de uma tabela de forma rápida. É um comando DDL, não pode ser desfeito (ROLLBACK) e reseta o High Water Mark da tabela.

```sql
TRUNCATE TABLE employees_copy;
```

### 9.4 DROP TABLE
Remove permanentemente a estrutura e os dados de uma tabela. A tabela vai para a "lixeira" (recyclebin), de onde pode ser restaurada.

```sql
DROP TABLE employees_copy;

-- Para restaurar da lixeira
FLASHBACK TABLE employees_copy TO BEFORE DROP;
```

---

## 10. Criando e Gerenciando Constraints

Regras que garantem a integridade e a validade dos dados em uma tabela.

### 10.1 Tipos de Constraint

#### NOT NULL
Garante que a coluna não pode ter valores nulos.

```sql
ALTER TABLE employees
MODIFY (last_name CONSTRAINT emp_last_name_nn NOT NULL);
```

#### UNIQUE
Garante que todos os valores na coluna (ou conjunto de colunas) sejam únicos. Permite valores nulos.

```sql
ALTER TABLE employees
ADD CONSTRAINT emp_email_uk UNIQUE (email);
```

#### PRIMARY KEY
Identifica de forma única cada linha na tabela. É uma combinação de NOT NULL e UNIQUE.

```sql
ALTER TABLE employees
ADD CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id);
```

#### FOREIGN KEY
Garante a integridade referencial, exigindo que o valor na coluna exista na PRIMARY KEY de outra tabela.

```sql
ALTER TABLE employees
ADD CONSTRAINT emp_dept_fk 
FOREIGN KEY (department_id) REFERENCES departments(department_id);
```

##### Opções de DELETE
```sql
-- ON DELETE CASCADE - Remove registros filhos quando o pai é deletado
ALTER TABLE employees
ADD CONSTRAINT emp_dept_fk 
FOREIGN KEY (department_id) REFERENCES departments(department_id)
ON DELETE CASCADE;

-- ON DELETE SET NULL - Define FK como NULL quando o pai é deletado
ALTER TABLE employees
ADD CONSTRAINT emp_dept_fk 
FOREIGN KEY (department_id) REFERENCES departments(department_id)
ON DELETE SET NULL;
```

#### CHECK
Garante que os valores em uma coluna satisfaçam uma condição específica.

```sql
ALTER TABLE employees
ADD CONSTRAINT emp_salary_min CHECK (salary > 0);
```

### 10.2 Gerenciamento de Constraints

```sql
-- Adicionar constraint
ALTER TABLE employees
ADD CONSTRAINT emp_salary_max CHECK (salary <= 50000);

-- Remover constraint
ALTER TABLE employees
DROP CONSTRAINT emp_salary_max;

-- Desabilitar constraint
ALTER TABLE employees
DISABLE CONSTRAINT emp_salary_min;

-- Habilitar constraint
ALTER TABLE employees
ENABLE CONSTRAINT emp_salary_min;
```

---

## 11. Criando e Gerenciando Visões (Views)

Uma visão é uma consulta SELECT armazenada que se comporta como uma tabela virtual.

### 11.1 Criação de Views

```sql
CREATE OR REPLACE VIEW emp_details_view AS
SELECT employee_id, first_name, last_name, salary, department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

### 11.2 Tipos de Views

#### Visão Simples
Baseada em uma única tabela e não contém funções de grupo, permitindo operações DML.

```sql
CREATE OR REPLACE VIEW high_salary_view AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 10000;
```

#### Visão Complexa
Com joins, funções de grupo, etc. Geralmente não permite DML.

```sql
CREATE OR REPLACE VIEW dept_summary_view AS
SELECT d.department_name, COUNT(e.employee_id) as employee_count, AVG(e.salary) as avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
```

### 11.3 Opções de Views

#### WITH CHECK OPTION
Impede que operações DML na visão criem linhas que não seriam visíveis pela própria visão.

```sql
CREATE OR REPLACE VIEW dept_20_view AS
SELECT employee_id, first_name, last_name, department_id
FROM employees
WHERE department_id = 20
WITH CHECK OPTION;
```

#### WITH READ ONLY
Impede qualquer operação DML na visão.

```sql
CREATE OR REPLACE VIEW emp_readonly_view AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WITH READ ONLY;
```

### 11.4 Remoção de Views

```sql
DROP VIEW emp_details_view;
```

---

## 12. Criando e Gerenciando Sequências (Sequences)

Objetos que geram números sequenciais únicos, ideais para chaves primárias.

### 12.1 Criação de Sequências

```sql
CREATE SEQUENCE emp_seq
START WITH 1000
INCREMENT BY 1
NOMAXVALUE
NOCYCLE
CACHE 20;
```

### 12.2 Uso de Sequências

```sql
-- NEXTVAL - Obtém o próximo valor da sequência
INSERT INTO employees (employee_id, first_name, last_name)
VALUES (emp_seq.NEXTVAL, 'John', 'Doe');

-- CURRVAL - Obtém o valor atual da sequência (deve-se chamar NEXTVAL primeiro na sessão)
SELECT emp_seq.CURRVAL FROM dual;
```

### 12.3 Modificação e Remoção

```sql
-- Modificar sequência
ALTER SEQUENCE emp_seq
INCREMENT BY 5
MAXVALUE 99999;

-- Remover sequência
DROP SEQUENCE emp_seq;
```

---

## 13. Criando e Gerenciando Índices (Indexes)

Estruturas de dados que melhoram a velocidade de recuperação de dados em uma tabela.

### 13.1 Criação de Índices

```sql
CREATE INDEX emp_last_name_idx ON employees(last_name);
```

**Nota:** Oracle cria automaticamente índices para PRIMARY KEY e UNIQUE constraints.

### 13.2 Tipos de Índice

#### B-Tree (Padrão)
Ideal para colunas com alta cardinalidade (muitos valores distintos). Podem ser simples ou compostos.

```sql
-- Índice simples
CREATE INDEX emp_salary_idx ON employees(salary);

-- Índice composto
CREATE INDEX emp_name_idx ON employees(last_name, first_name);
```

#### Bitmap
Ideal para colunas com baixa cardinalidade (poucos valores distintos). Não é recomendado para tabelas com muitas transações (DML).

```sql
CREATE BITMAP INDEX emp_gender_idx ON employees(gender);
```

#### Baseado em Função
O índice é criado sobre o resultado de uma função aplicada a uma coluna, otimizando consultas que usam essa função na cláusula WHERE.

```sql
CREATE INDEX emp_upper_last_name_idx ON employees(UPPER(last_name));

-- Agora esta consulta usará o índice
SELECT * FROM employees WHERE UPPER(last_name) = 'SMITH';
```

### 13.3 Gerenciamento de Índices

```sql
-- Reconstruir índice
ALTER INDEX emp_last_name_idx REBUILD ONLINE;

-- Tornar índice invisível
ALTER INDEX emp_last_name_idx INVISIBLE;

-- Tornar índice visível
ALTER INDEX emp_last_name_idx VISIBLE;

-- Remover índice
DROP INDEX emp_last_name_idx;
```

---

## 14. Criando Sinônimos (Synonyms)

Nomes alternativos (apelidos) para objetos do banco de dados (tabelas, views, etc.), simplificando o acesso e ocultando a complexidade de schemas.

### 14.1 Sinônimo Privado
Pertence ao schema que o criou.

```sql
CREATE SYNONYM dept FOR departments;

-- Agora pode usar 'dept' ao invés de 'departments'
SELECT * FROM dept;
```

### 14.2 Sinônimo Público
Acessível a todos os usuários. Requer privilégios de DBA.

```sql
CREATE PUBLIC SYNONYM dept FOR hr.departments;
```

### 14.3 Remoção de Sinônimos

```sql
DROP SYNONYM dept;
DROP PUBLIC SYNONYM dept;
```

---

## 15. Utilizando o SQL*Plus

Um cliente de linha de comando para interagir com o Oracle.

### 15.1 Comandos Básicos

```sql
-- EDIT - Abre o último comando SQL em um editor de texto
EDIT

-- / ou RUN - Executa o comando no buffer
/
RUN

-- SAVE - Salva o buffer em um arquivo
SAVE meu_script.sql

-- @ ou START - Executa um script a partir de um arquivo
@meu_script.sql
START meu_script.sql

-- SPOOL - Direciona a saída para um arquivo
SPOOL relatorio.txt
SELECT * FROM employees;
SPOOL OFF

-- ACCEPT - Cria uma variável de usuário interativa
ACCEPT dept_id PROMPT 'Digite o ID do departamento: '
SELECT * FROM employees WHERE department_id = &dept_id;

-- SET VERIFY OFF - Oculta a substituição de variáveis na saída
SET VERIFY OFF

-- EXIT ou QUIT - Encerra a sessão
EXIT
QUIT
```

---

## 16. Objetos do Banco de Dados e Dicionário de Dados

Consultando os metadados do banco de dados.

### 16.1 Dicionário de Dados
Um conjunto de visões que fornecem informações sobre a estrutura do banco de dados.

### 16.2 Prefixos das Visões

#### USER_
Objetos pertencentes ao usuário atual.

```sql
SELECT table_name FROM USER_TABLES;
SELECT object_name, object_type FROM USER_OBJECTS;
```

#### ALL_
Objetos que o usuário atual tem permissão para acessar.

```sql
SELECT table_name, owner FROM ALL_TABLES;
```

#### DBA_
Todos os objetos do banco de dados (requer privilégios de DBA).

```sql
SELECT table_name, owner FROM DBA_TABLES;
SELECT username FROM DBA_USERS;
```

### 16.3 Visões Dinâmicas de Performance (V$)
Fornecem informações em tempo real sobre a atividade do banco de dados.

```sql
SELECT name, value FROM V$PARAMETER WHERE name LIKE '%memory%';
SELECT username, status FROM V$SESSION;
SELECT name FROM V$DATAFILE;
```

---

## 17. Manipulação de Dados Avançada

Técnicas avançadas para inserir e sincronizar dados.

### 17.1 INSERT ALL Incondicional
Insere linhas em múltiplas tabelas com base em uma única consulta de origem.

```sql
INSERT ALL
    INTO sales_history VALUES (employee_id, week_id, sales_mon)
    INTO sales_history VALUES (employee_id, week_id, sales_tue)
    INTO sales_history VALUES (employee_id, week_id, sales_wed)
SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed
FROM sales_source_data;
```

### 17.2 INSERT ALL Condicional
Insere em múltiplas tabelas, mas cada inserção é controlada por uma cláusula WHEN.

```sql
INSERT ALL
    WHEN salary > 10000 THEN
        INTO high_salary_emp VALUES (employee_id, first_name, salary)
    WHEN salary BETWEEN 5000 AND 10000 THEN
        INTO medium_salary_emp VALUES (employee_id, first_name, salary)
    ELSE
        INTO low_salary_emp VALUES (employee_id, first_name, salary)
SELECT employee_id, first_name, salary FROM employees;
```

### 17.3 INSERT FIRST Condicional
Avalia as condições WHEN em ordem e executa apenas a primeira que for verdadeira.

```sql
INSERT FIRST
    WHEN salary > 15000 THEN
        INTO high_salary_emp VALUES (employee_id, first_name, salary)
    WHEN salary > 10000 THEN
        INTO medium_salary_emp VALUES (employee_id, first_name, salary)
    ELSE
        INTO low_salary_emp VALUES (employee_id, first_name, salary)
SELECT employee_id, first_name, salary FROM employees;
```

### 17.4 MERGE
Sincroniza uma tabela de destino com uma de origem. Pode executar UPDATE (se a linha corresponder), INSERT (se não corresponder) e DELETE em um único comando. Extremamente útil para ETL e processos de sincronização.

```sql
MERGE INTO employees_copy ec
USING employees e ON (ec.employee_id = e.employee_id)
WHEN MATCHED THEN
    UPDATE SET ec.salary = e.salary, ec.job_id = e.job_id
    DELETE WHERE e.commission_pct IS NOT NULL
WHEN NOT MATCHED THEN
    INSERT (employee_id, first_name, last_name, salary, job_id)
    VALUES (e.employee_id, e.first_name, e.last_name, e.salary, e.job_id);
```

---

## 18. Recuperação de Dados com FLASHBACK

Tecnologia Oracle para visualizar ou reverter dados para um ponto no tempo passado.

### 18.1 FLASHBACK QUERY (AS OF TIMESTAMP)
Permite consultar o estado de uma tabela em um momento específico no passado, sem alterar os dados atuais.

```sql
SELECT * FROM employees
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' HOUR)
WHERE employee_id = 107;
```

### 18.2 FLASHBACK DROP
Restaura uma tabela que foi removida (DROP) da lixeira do Oracle.

```sql
FLASHBACK TABLE employees_copy TO BEFORE DROP;
```

### 18.3 FLASHBACK TABLE
Reverte uma tabela inteira para um ponto no tempo específico. Requer que o ROW MOVEMENT esteja habilitado na tabela.

```sql
-- Habilitar row movement
ALTER TABLE employees ENABLE ROW MOVEMENT;

-- Fazer flashback da tabela
FLASHBACK TABLE employees TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' HOUR);
```

### 18.4 FLASHBACK VERSIONS QUERY
Mostra todas as versões de uma linha entre dois pontos no tempo ou SCNs (System Change Numbers), permitindo auditar alterações.

```sql
SELECT versions_starttime, versions_endtime, versions_operation,
       employee_id, first_name, salary
FROM employees
VERSIONS BETWEEN TIMESTAMP 
    (SYSTIMESTAMP - INTERVAL '2' HOUR) AND SYSTIMESTAMP
WHERE employee_id = 107;
```

---

## 19. Consultas Hierárquicas

Consultas hierárquicas são usadas para processar dados que possuem uma estrutura de árvore, como organogramas de funcionários e gerentes. O Oracle utiliza as cláusulas START WITH e CONNECT BY para navegar nessas hierarquias.

### 19.1 Sintaxe Básica

```sql
-- Consulta hierárquica de cima para baixo (UP to DOWN) a partir da raiz
SELECT LEVEL, employee_id, first_name, last_name, job_id, manager_id
FROM employees
START WITH manager_id IS NULL -- Começa com o presidente
CONNECT BY PRIOR employee_id = manager_id; -- O empregado anterior (pai) é o gerente do atual (filho)
```

**Elementos principais:**
- **START WITH:** Define o(s) registro(s) raiz da hierarquia (o ponto de partida)
- **CONNECT BY:** Especifica a relação entre o registro pai e o filho. PRIOR identifica o registro pai
- **LEVEL:** Uma pseudocoluna que indica o nível do registro na hierarquia (1 para a raiz, 2 para os filhos da raiz, etc.)

### 19.2 Navegação e Poda de Galhos

#### Iniciando de qualquer nó
```sql
-- Iniciar hierarquia a partir de um gerente específico
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM employees
START WITH employee_id = 100 -- Começa com um funcionário específico
CONNECT BY PRIOR employee_id = manager_id;
```

#### Navegação de baixo para cima (BOTTOM to UP)
```sql
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM employees
START WITH employee_id = 107 -- Começa com um funcionário específico
CONNECT BY PRIOR manager_id = employee_id; -- Inverte a lógica
```

#### Filtragem com WHERE
```sql
-- WHERE filtra os resultados após a construção da hierarquia
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM employees
WHERE salary > 5000
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
```

#### Podando galhos
```sql
-- Poda o galho do empregado 205 e todos os seus subordinados
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id AND employee_id <> 205;
```

### 19.3 Formatação e Ordenação

#### Formatação com LPAD
```sql
SELECT LPAD(' ', 2 * (LEVEL - 1)) || first_name || ' ' || last_name "Organograma"
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
```

#### ORDER SIBLINGS BY
Ordena os registros no mesmo nível hierárquico (irmãos), preservando a estrutura da árvore.

```sql
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;
```

---

## 20. Expressões Regulares

Expressões regulares (regex) são um mecanismo poderoso para busca e manipulação de padrões em strings.

### 20.1 Funções de Expressões Regulares

#### REGEXP_LIKE
Similar ao LIKE, mas utiliza a sintaxe de regex para a busca.

```sql
-- Encontra nomes que são 'Steven' ou 'Stephen' (case insensitive)
SELECT *
FROM employees
WHERE REGEXP_LIKE(first_name, '^Ste(v|ph)en, 'i');

-- Busca por emails válidos
SELECT first_name, email
FROM employees
WHERE REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,});
```

#### REGEXP_REPLACE
Encontra um padrão e o substitui por outra string.

```sql
-- Substitui os pontos no número de telefone por hífens
SELECT phone_number, REGEXP_REPLACE(phone_number, '\.', '-') as phone
FROM employees;

-- Remove todos os números de uma string
SELECT REGEXP_REPLACE('abc123def456', '[0-9]', '') "Sem Números" FROM dual;
```

#### REGEXP_SUBSTR
Extrai a parte da string que corresponde ao padrão.

```sql
-- Extrai o primeiro nome de um campo 'nome completo'
SELECT name, REGEXP_SUBSTR(name, '^[A-Z][[:alpha:]]+ ') as first_name
FROM employees_copy;

-- Extrai o domínio do email
SELECT email, REGEXP_SUBSTR(email, '@(.+)', 1, 1, NULL, 1) "Domínio"
FROM employees;
```

#### REGEXP_INSTR
Retorna a posição inicial da substring que corresponde ao padrão.

```sql
SELECT email, REGEXP_INSTR(email, '@') "Posição do @"
FROM employees;
```

#### REGEXP_COUNT
Conta o número de vezes que um padrão ocorre na string.

```sql
SELECT 'Oracle Database 19c', REGEXP_COUNT('Oracle Database 19c', '[aeiou]', 1, 'i') "Vogais"
FROM dual;
```

### 20.2 Modificadores Comuns
- **'i'** - Case insensitive (ignora maiúsculas/minúsculas)
- **'m'** - Multiline mode
- **'x'** - Extended mode (ignora espaços em branco)

---

## 21. Tabelas Temporárias

Tabelas temporárias globais são objetos permanentes do dicionário de dados, mas os dados inseridos nelas são visíveis apenas para a sessão que os inseriu.

### 21.1 Criação de Tabelas Temporárias

```sql
-- Cria uma tabela temporária cujos dados persistem na sessão após um commit
CREATE GLOBAL TEMPORARY TABLE hr.tmp_employees
(
    employee_id NUMBER(6),
    first_name VARCHAR2(20),
    last_name VARCHAR2(25),
    salary NUMBER(8,2)
)
ON COMMIT PRESERVE ROWS;
```

### 21.2 Comportamento dos Dados

#### ON COMMIT PRESERVE ROWS
Os dados da sessão persistem após um COMMIT. Eles são apagados ao final da sessão.

```sql
CREATE GLOBAL TEMPORARY TABLE temp_sales
(
    sale_id NUMBER,
    amount NUMBER(10,2)
)
ON COMMIT PRESERVE ROWS;
```

#### ON COMMIT DELETE ROWS
Os dados são apagados após cada COMMIT.

```sql
CREATE GLOBAL TEMPORARY TABLE temp_calculations
(
    calc_id NUMBER,
    result NUMBER
)
ON COMMIT DELETE ROWS;
```

### 21.3 Características Principais
- A definição da tabela é visível para todas as sessões, mas cada sessão vê apenas seus próprios dados
- Ideal para armazenar resultados intermediários de cálculos complexos dentro de uma transação ou sessão, sem afetar outros usuários
- Não precisam ser criadas e dropadas constantemente
- Melhor performance que tabelas normais para dados temporários

---

## 22. Globalização e Fuso Horário

O Oracle oferece tipos de dados e funções robustas para lidar com datas, horas e fusos horários em aplicações globais.

### 22.1 Tipos de Dados

#### TIMESTAMP WITH TIME ZONE
Armazena data, hora e fuso horário.

```sql
CREATE TABLE events (
    event_id NUMBER,
    event_time TIMESTAMP WITH TIME ZONE
);

INSERT INTO events VALUES (1, TIMESTAMP '2023-12-25 10:30:00 -03:00');
```

#### INTERVAL YEAR TO MONTH
Armazena um período de tempo em anos e meses.

```sql
SELECT employee_id, hire_date, hire_date + INTERVAL '2' YEAR "Data Promoção"
FROM employees;
```

#### INTERVAL DAY TO SECOND
Armazena um período de tempo em dias, horas, minutos e segundos.

```sql
SELECT SYSDATE + INTERVAL '5' DAY + INTERVAL '3' HOUR "Prazo Final"
FROM dual;
```

### 22.2 Funções de Data e Hora

```sql
-- DBTIMEZONE - Retorna o fuso horário do banco de dados
SELECT DBTIMEZONE FROM dual;

-- SESSIONTIMEZONE - Retorna o fuso horário da sessão atual
SELECT SESSIONTIMEZONE FROM dual;

-- CURRENT_DATE - Data da sessão (tipo DATE)
SELECT CURRENT_DATE FROM dual;

-- CURRENT_TIMESTAMP - Data e hora da sessão com fuso horário
SELECT CURRENT_TIMESTAMP FROM dual;

-- LOCALTIMESTAMP - Data e hora da sessão sem fuso horário
SELECT LOCALTIMESTAMP FROM dual;

-- EXTRACT - Extrai componentes específicos
SELECT EXTRACT(YEAR FROM CURRENT_TIMESTAMP) ANO,
       EXTRACT(HOUR FROM CURRENT_TIMESTAMP) HORA,
       EXTRACT(TIMEZONE_REGION FROM CURRENT_TIMESTAMP) TIMEZONE_REGION
FROM dual;

-- TZ_OFFSET - Retorna diferença do fuso horário em relação ao UTC
SELECT TZ_OFFSET('America/Sao_Paulo') FROM dual;

-- FROM_TZ - Converte um TIMESTAMP para TIMESTAMP WITH TIME ZONE
SELECT LOCALTIMESTAMP,
       FROM_TZ(LOCALTIMESTAMP, 'America/Sao_Paulo')
FROM dual;
```

---

## 23. Subconsultas Avançadas

Técnicas adicionais para uso de subconsultas em comandos DML e na organização de consultas complexas.

### 23.1 Cláusula WITH (Common Table Expressions - CTE)
Permite definir um bloco de consulta nomeado que pode ser referenciado posteriormente dentro da consulta principal. Melhora a legibilidade e a organização de consultas complexas.

```sql
WITH max_salaries AS (
    SELECT department_id, MAX(salary) AS maximum_salary
    FROM employees
    GROUP BY department_id
),
dept_info AS (
    SELECT department_id, department_name
    FROM departments
)
SELECT e.employee_id, e.salary, ms.maximum_salary, di.department_name
FROM employees e
JOIN max_salaries ms ON (e.department_id = ms.department_id)
JOIN dept_info di ON (e.department_id = di.department_id)
WHERE e.salary = ms.maximum_salary;
```

### 23.2 UPDATE e DELETE com Subconsultas Correlacionadas
Permitem atualizar ou deletar linhas em uma tabela com base em valores agregados ou relacionados de outra tabela.

```sql
-- Atualiza uma tabela de resumo com a média salarial calculada
UPDATE departments_summary d
SET d.avg_salary = (
    SELECT ROUND(AVG(e.salary), 2)
    FROM employees e
    WHERE d.department_id = e.department_id
)
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.department_id = d.department_id
);

-- Deleta funcionários que ganham menos que a média do departamento
DELETE FROM employees e1
WHERE salary < (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);
```

---

## 24. Gerando Scripts SQL Dinâmicos

Utilização do próprio SQL para gerar outros scripts SQL. Técnica muito comum para tarefas de administração (DBA).

### 24.1 Processo de Geração

```sql
-- 1. Configurar SQL*Plus
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 200

-- 2. Gerar script para dropar todas as tabelas do usuário
SPOOL C:\scripts\drop_tables.sql
SELECT 'DROP TABLE ' || table_name || ' CASCADE CONSTRAINTS;'
FROM user_tables;
SPOOL OFF

-- 3. Gerar script para criar sinônimos
SPOOL C:\scripts\create_synonyms.sql
SELECT 'CREATE SYNONYM ' || table_name || ' FOR hr.' || table_name || ';'
FROM all_tables
WHERE owner = 'HR';
SPOOL OFF

-- 4. Gerar script de backup (INSERT statements)
SPOOL C:\scripts\backup_departments.sql
SELECT 'INSERT INTO departments VALUES (' ||
       department_id || ', ''' || department_name || ''', ' ||
       NVL(TO_CHAR(manager_id), 'NULL') || ', ' ||
       NVL(TO_CHAR(location_id), 'NULL') || ');'
FROM departments;
SPOOL OFF
```

### 24.2 Exemplos Práticos

```sql
-- Gerar comandos para recompilar objetos inválidos
SELECT 'ALTER ' || object_type || ' ' || object_name || ' COMPILE;'
FROM user_objects
WHERE status = 'INVALID';

-- Gerar comandos para analisar tabelas
SELECT 'ANALYZE TABLE ' || table_name || ' COMPUTE STATISTICS;'
FROM user_tables;

-- Gerar comandos para criar índices em colunas de chave estrangeira
SELECT 'CREATE INDEX ' || constraint_name || '_idx ON ' || 
       table_name || '(' || column_name || ');'
FROM user_cons_columns
WHERE constraint_name IN (
    SELECT constraint_name 
    FROM user_constraints 
    WHERE constraint_type = 'R'
);
```

---

## 25. Aperfeiçoando a Cláusula GROUP BY

Extensões da cláusula GROUP BY que permitem a criação de subtotais e totais gerais em uma única consulta, simplificando relatórios complexos.

### 25.1 GROUPING SETS
Especifica múltiplos agrupamentos em uma única consulta. É equivalente a fazer um UNION ALL de várias consultas com GROUP BY diferentes.

```sql
-- Para incluir um total geral, usa-se um par de parênteses vazios ()
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY GROUPING SETS (
    (department_id, job_id),    -- Agrupamento por dept e job
    (department_id),            -- Agrupamento só por dept
    (job_id),                   -- Agrupamento só por job
    ()                          -- Total geral
)
ORDER BY department_id, job_id;
```

### 25.2 ROLLUP
Gera subtotais hierárquicos, do nível mais detalhado para o mais geral (total geral). A ordem das colunas no ROLLUP é importante.

```sql
-- Usando ROLLUP para obter subtotais por continente, país e o total geral
SELECT continent, country, city, SUM(units_sold) "Total Vendas"
FROM sales
GROUP BY ROLLUP(continent, country, city)
ORDER BY continent, country, city;

-- Exemplo prático com funcionários
SELECT department_id, job_id, COUNT(*) "Qtd Funcionários", SUM(salary) "Total Salários"
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id, job_id;
```

### 25.3 CUBE
Gera subtotais para todas as combinações possíveis das colunas fornecidas, criando um "cubo" de dados. Gera mais subtotais que o ROLLUP.

```sql
SELECT department_id, job_id, SUM(salary) "Total Salários"
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id, job_id;
```

### 25.4 Função GROUPING
Identifica se uma linha é resultado de uma operação de agrupamento.

```sql
SELECT 
    CASE WHEN GROUPING(department_id) = 1 THEN 'TODOS OS DEPTS' 
         ELSE TO_CHAR(department_id) END "Departamento",
    CASE WHEN GROUPING(job_id) = 1 THEN 'TODOS OS JOBS' 
         ELSE job_id END "Cargo",
    SUM(salary) "Total Salários"
FROM employees
GROUP BY ROLLUP(department_id, job_id);
```

---

## 26. Visões Materializadas

Visões materializadas (MVs) são objetos que armazenam fisicamente o resultado de uma consulta. Diferente das views normais, que executam a consulta a cada acesso, as MVs oferecem um grande ganho de desempenho para consultas complexas e dados agregados.

### 26.1 Criação e Opções de Refresh

#### REFRESH COMPLETE
A cada atualização, a MV é completamente recriada executando a consulta inteira. É simples, mas pode ser lento.

```sql
CREATE MATERIALIZED VIEW mv_dept_summary
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT d.department_name, COUNT(e.employee_id) as employee_count, 
       AVG(e.salary) as avg_salary, SUM(e.salary) as total_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
```

#### REFRESH FAST
Atualização incremental. Apenas as alterações feitas nas tabelas base desde a última atualização são aplicadas. Requer a criação de MATERIALIZED VIEW LOG nas tabelas base.

```sql
-- Primeiro, criar o log na tabela base
CREATE MATERIALIZED VIEW LOG ON employees
WITH PRIMARY KEY, ROWID (employee_id, job_id, salary, department_id)
INCLUDING NEW VALUES;

-- Depois criar a MV de refresh rápido
CREATE MATERIALIZED VIEW mv_sales_manager
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT *
FROM employees
WHERE job_id = 'SA_MAN';
```

#### REFRESH FORCE
O Oracle tenta primeiro um refresh FAST. Se não for possível, ele executa um COMPLETE.

```sql
CREATE MATERIALIZED VIEW mv_employee_summary
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
START WITH SYSDATE
NEXT SYSDATE + 1/24  -- Atualiza a cada hora
AS
SELECT department_id, COUNT(*) emp_count, AVG(salary) avg_sal
FROM employees
GROUP BY department_id;
```

### 26.2 Modos de Atualização

#### ON COMMIT
A MV é atualizada automaticamente a cada COMMIT nas tabelas base.

```sql
CREATE MATERIALIZED VIEW mv_high_salary_emp
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 10000;
```

#### ON DEMAND
A MV só é atualizada manualmente ou por agendamento (padrão).

```sql
CREATE MATERIALIZED VIEW mv_monthly_sales
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
START WITH SYSDATE
NEXT LAST_DAY(SYSDATE) + 1  -- Atualiza no primeiro dia de cada mês
AS
SELECT TO_CHAR(sale_date, 'YYYY-MM') month_year,
       SUM(amount) total_sales,
       COUNT(*) total_transactions
FROM sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM');
```

### 26.3 Gerenciamento de Visões Materializadas

#### Atualização Manual
```sql
-- Usando DBMS_MVIEW
EXEC DBMS_MVIEW.REFRESH('mv_dept_summary', 'C'); -- Complete refresh
EXEC DBMS_MVIEW.REFRESH('mv_sales_manager', 'F'); -- Fast refresh

-- Refresh múltiplas MVs
EXEC DBMS_MVIEW.REFRESH_ALL_MVIEWS(number_of_failures => 0);
```

#### Query Rewrite
A opção ENABLE QUERY REWRITE permite que o otimizador do Oracle utilize a MV de forma transparente, mesmo que a consulta do usuário seja feita sobre as tabelas base.

```sql
CREATE MATERIALIZED VIEW mv_sales_summary
BUILD IMMEDIATE
REFRESH FAST ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT product_id, SUM(quantity) total_qty, SUM(amount) total_amount
FROM sales
GROUP BY product_id;

-- Mesmo fazendo esta consulta nas tabelas base,
-- o Oracle pode usar automaticamente a MV
SELECT product_id, SUM(amount)
FROM sales
GROUP BY product_id;
```

#### Informações sobre MVs
```sql
-- Verificar MVs do usuário
SELECT mview_name, refresh_mode, refresh_method, 
       build_mode, fast_refreshable
FROM user_mviews;

-- Verificar logs de MV
SELECT log_table, master FROM user_mview_logs;

-- Verificar quando foi o último refresh
SELECT mview_name, last_refresh_date, staleness
FROM user_mviews;
```

---

## Resumo de Comandos Importantes

### Comandos DDL (Data Definition Language)
```sql
CREATE TABLE, ALTER TABLE, DROP TABLE, TRUNCATE TABLE
CREATE INDEX, ALTER INDEX, DROP INDEX
CREATE VIEW, DROP VIEW
CREATE SEQUENCE, ALTER SEQUENCE, DROP SEQUENCE
CREATE SYNONYM, DROP SYNONYM
CREATE MATERIALIZED VIEW, DROP MATERIALIZED VIEW
```

### Comandos DML (Data Manipulation Language)
```sql
SELECT, INSERT, UPDATE, DELETE, MERGE
COMMIT, ROLLBACK, SAVEPOINT
```

### Comandos de Consulta Avançada
```sql
-- Junções
INNER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN
CROSS JOIN, NATURAL JOIN

-- Operadores SET
UNION, UNION ALL, INTERSECT, MINUS

-- Subconsultas
WHERE col IN (SELECT...), WHERE EXISTS (SELECT...)
SELECT... FROM (SELECT...) -- Inline view

-- Consultas hierárquicas
START WITH... CONNECT BY PRIOR

-- Análise de dados
GROUP BY, GROUP BY ROLLUP, GROUP BY CUBE, GROUP BY GROUPING SETS
```

### Funções Importantes
```sql
-- Funções de string
UPPER, LOWER, CONCAT, SUBSTR, LENGTH, INSTR, REPLACE, LPAD, RPAD

-- Funções numéricas
ROUND, TRUNC, MOD, ABS, SQRT

-- Funções de data
SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY
CURRENT_DATE, CURRENT_TIMESTAMP, EXTRACT

-- Funções de conversão
TO_CHAR, TO_NUMBER, TO_DATE, TO_TIMESTAMP

-- Funções de agregação
SUM, AVG, MIN, MAX, COUNT

-- Funções para NULL
NVL, NVL2, COALESCE

-- Expressões condicionais
CASE, DECODE

-- Funções analíticas
ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD()
```

### Operadores e Expressões
```sql
-- Operadores de comparação
=, <>, !=, <, >, <=, >=, BETWEEN, IN, LIKE, IS NULL

-- Operadores lógicos
AND, OR, NOT

-- Operadores aritméticos
+, -, *, /

-- Operador de concatenação
||

-- Expressões regulares
REGEXP_LIKE, REGEXP_REPLACE, REGEXP_SUBSTR, REGEXP_INSTR, REGEXP_COUNT
```

---

## Dicas de Boas Práticas

### Performance
1. **Use índices apropriados** nas colunas frequentemente consultadas
2. **Evite SELECT *** em produção; especifique apenas as colunas necessárias
3. **Use BIND variables** para consultas repetitivas
4. **Prefira UNION ALL ao UNION** quando não precisar eliminar duplicatas
5. **Use EXISTS ao invés de IN** com subconsultas quando possível

### Manutenibilidade
1. **Use aliases descritivos** para tabelas e colunas
2. **Indente o código SQL** adequadamente
3. **Comente consultas complexas**
4. **Use a sintaxe ANSI** para JOINs (mais legível)
5. **Evite funções em WHERE** quando possível (prejudica uso de índices)

### Segurança
1. **Sempre use WHERE** em UPDATE e DELETE (a menos que realmente queira afetar todas as linhas)
2. **Teste comandos DML** em ambiente de desenvolvimento primeiro
3. **Use COMMIT e ROLLBACK** apropriadamente
4. **Implemente constraints** adequadas para garantir integridade dos dados

### Portabilidade
1. **Prefira CASE ao DECODE** (CASE é padrão ANSI)
2. **Use funções padrão SQL** quando disponíveis
3. **Evite recursos específicos do Oracle** se a portabilidade for importante
4. **Documente dependências** de recursos específicos do Oracle

---

## Glossário de Termos

- **Constraint**: Regra que garante a integridade dos dados
- **Index**: Estrutura que acelera consultas
- **Join**: Operação que combina dados de múltiplas tabelas
- **Materialized View**: View que armazena fisicamente os dados
- **NULL**: Valor ausente ou desconhecido
- **Primary Key**: Chave que identifica unicamente cada linha
- **Foreign Key**: Chave que referencia a primary key de outra tabela
- **Rollback**: Desfaz alterações não commitadas
- **Schema**: Conjunto de objetos de banco de dados de um usuário
- **Sequence**: Objeto que gera números sequenciais únicos
- **Synonym**: Nome alternativo para um objeto do banco
- **Transaction**: Unidade lógica de trabalho no banco de dados
- **Trigger**: Código que executa automaticamente em resposta a eventos
- **View**: Consulta SELECT armazenada que funciona como uma tabela virtual

---

*Este guia de estudo cobre os principais conceitos e comandos do Oracle SQL. Para aprofundar seus conhecimentos, pratique os exemplos em um ambiente Oracle e consulte a documentação oficial para detalhes específicos sobre sintaxe e opções avançadas.*