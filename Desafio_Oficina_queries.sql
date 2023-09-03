-- Desafio dia Oficina
-- Aqu é uma tenttiva de realizar o desafio proposto para 
-- o nível básico de sql na plataforma DIO

use oficina;

-- Questões
-- 01. Quando foi o total do faturamento
SELECT CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE')) as 'TotalFaturamentoDaOficina' FROM pagtos_nota; /*
+---------------------------+
| TotalFaturamentoDaOficina |
+---------------------------+
| R$ 1.020.566,00           |
+---------------------------+ */

-- 02. Quando foi o total para cada forma de pagamento 
SELECT pagamentoTipo, 
	   CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE')) as TotalPorFormaPagamento 
FROM pagtos_nota GROUP BY pagamentoTipo
ORDER BY SUM(valorTotalPgtoNota); /*
+----------------+---------------------------+
| pagamentoTipo | TotalPorFormaPagamento |
+----------------+---------------------------+
| Débito         | R$ 136.694,00             |
| Crédito        | R$ 197.192,00             |
| Pix            | R$ 254.945,00             |
| dinheiro       | R$ 431.735,00             |
+----------------+---------------------------+*/

-- 03. Quando foi a média  para cada forma de pagamento 
SELECT pagamentoTipo, 
CONCAT('R$ ', FORMAT(AVG(valorTotalPgtoNota),2,'de_DE')) as Media_Forma_Pagamento 
FROM pagtos_nota GROUP BY pagamentoTipo
ORDER BY AVG(valorTotalPgtoNota); /*
+----------------+-----------------------+
| pagamentoTipo | Media_Forma_Pagamento |
+----------------+-----------------------+
| Crédito        | R$ 4.809,56           |
| Pix            | R$ 4.998,92           |
| Débito         | R$ 5.257,46           |
| dinheiro       | R$ 5.265,06           |
+----------------+-----------------------+ */

-- 04. A quantidade de ocorrências de cada forma de pagamento 
SELECT pagamentoTipo, COUNT(valorTotalPgtoNota) as 'Qtd_Pagamentos'
FROM pagtos_nota
GROUP BY pagamentoTipo 
ORDER BY COUNT(valorTotalPgtoNota); /*
+----------------+----------------+
| pagamentoTipo | Qtd_Pagamentos |
+----------------+----------------+
| Débito         |             26 |
| Crédito        |             41 |
| Pix            |             51 |
| dinheiro       |             82 |
+----------------+----------------+*/

-- 05. Quantidade de Pagamentos acima do Ticket Medio
SELECT pagamentoTipo, COUNT(valorTotalPgtoNota) as 'Qtd_acima_media'
FROM pagtos_nota
WHERE valorTotalPgtoNota > (SELECT AVG(valorTotalPgtoNota) FROM pagtos_nota)
GROUP BY pagamentoTipo
ORDER BY  COUNT(valorTotalPgtoNota); /*
+----------------+-----------------+
| pagamento_tipo | Qtd_acima_media |
+----------------+-----------------+
| Débito         |              15 |
| Crédito        |              22 |
| Pix            |              28 |
| dinheiro       |              46 |
+----------------+-----------------+ */

-- 06. Quando foi o faturamento por mês
SELECT MONTH(dataNota) as mes, YEAR(dataNota) as ano, 
CONCAT('R$ ', FORMAT(AVG(valorTotalPgtoNota),2,'de_DE')) 
FROM pagtos_nota
GROUP BY mes
ORDER BY mes; /*
+-----+------+-------------------------------------------------------------+
| mes | ano  | CONCAT('R$ ', FORMAT(AVG(valorTotalPgtoNota),2,'de_DE')) |
+-----+------+-------------------------------------------------------------+
|   1 | 2023 | R$ 4.643,71                                                 |
|   2 | 2022 | R$ 3.817,13                                                 |
|   3 | 2022 | R$ 6.140,81                                                 |
|   4 | 2022 | R$ 3.563,44                                                 |
|   5 | 2022 | R$ 3.778,43                                                 |
|   6 | 2023 | R$ 4.842,15                                                 |
|   7 | 2022 | R$ 5.045,13                                                 |
|   8 | 2022 | R$ 5.992,07                                                 |
|   9 | 2022 | R$ 3.798,38                                                 |
|  10 | 2022 | R$ 4.717,63                                                 |
|  11 | 2022 | R$ 4.310,56                                                 |
|  12 | 2022 | R$ 638,00                                                   |
+-----+------+-------------------------------------------------------------+*/

-- 07. O Faturamento mensal para cada Forma de Pagamento
SELECT  
    MONTH(dataNota) as mes, 
    YEAR(dataNota) as ano,
    (SELECT  CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE')) FROM pagtos_nota WHERE pagamentoTipo = 'pix' and MONTH(dataNota) = mes) as Total_pix ,
    (SELECT CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE'))  FROM pagtos_nota WHERE pagamentoTipo = 'dinheiro' and MONTH(dataNota) = mes) as Total_dinheiro,
	(SELECT CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE'))  FROM pagtos_nota WHERE pagamentoTipo = 'Crédito' and MONTH(dataNota) = mes) as Total_Crédito,
    (SELECT CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE'))  FROM pagtos_nota WHERE pagamentoTipo = 'Débito' and MONTH(dataNota) = mes) as Total_Debito,
    CONCAT('R$ ', FORMAT(SUM(valorTotalPgtoNota),2,'de_DE'))  as Total
FROM pagtos_nota
GROUP BY mes
ORDER BY mes;  /*
+-----+------+---------------+----------------+---------------+--------------+---------------+
| mes | ano  | Total_pix     | Total_dinheiro | Total_Crédito | Total_Debito | Total         |
+-----+------+---------------+----------------+---------------+--------------+---------------+
|   1 | 2023 | R$ 8.010,00   | R$ 17.419,00   | R$ 7.077,00   | null         | R$ 32.506,00  |
|   2 | 2022 | R$ 8.020,00   | R$ 5.908,00    | R$ 16.609,00  | null         | R$ 30.537,00  |
|   3 | 2022 | R$ 107.098,00 | R$ 174.303,00  | R$ 85.337,00  | R$ 56.978,00 | R$ 423.716,00 |
|   4 | 2022 | R$ 6.321,00   | R$ 10.605,00   | R$ 7.047,00   | R$ 8.098,00  | R$ 32.071,00  |
|   5 | 2022 | R$ 7.591,00   | R$ 16.447,00   | null          | R$ 2.411,00  | R$ 26.449,00  |
|   6 | 2023 | R$ 11.131,00  | R$ 28.844,00   | R$ 16.067,00  | R$ 6.906,00  | R$ 62.948,00  |
|   7 | 2022 | R$ 30.196,00  | R$ 21.313,00   | R$ 3.122,00   | R$ 26.091,00 | R$ 80.722,00  |
|   8 | 2022 | R$ 25.162,00  | R$ 37.009,00   | R$ 14.244,00  | R$ 13.466,00 | R$ 89.881,00  |
|   9 | 2022 | R$ 5.168,00   | R$ 32.560,00   | R$ 10.517,00  | R$ 12.529,00 | R$ 60.774,00  |
|  10 | 2022 | R$ 36.366,00  | R$ 68.918,00   | R$ 31.185,00  | R$ 5.060,00  | R$ 141.529,00 |
|  11 | 2022 | R$ 9.882,00   | R$ 18.409,00   | R$ 5.349,00   | R$ 5.155,00  | R$ 38.795,00  |
|  12 | 2022 | null          | null           | R$ 638,00     | null         | R$ 638,00     |
+-----+------+---------------+----------------+---------------+--------------+---------------+ */


-- 08. Lista de Carros que estão na oficina
SELECT marca, modelo, carroceria, cor
FROM veiculos INNER JOIN carros on idVeiculo = idVeiculoCarro; /*
+-------------+------------+------------+--------+
| marca       | modelo     | carroceria | cor    |
+-------------+------------+------------+--------+
| Peugeot     | 208        | Hatch      | prata  |
| Volkswagen  | Voyage     | Hatch      | verde  |
| Fiat        |  Cronos    | Hatch      | preto  |
| Renault     | Kwid       | Hatch      | preto  |
| Fiat        | Argo       | Hatch      | branco |
| Volkswagen  | Gol        | Hatch      | preto  |
| Fiat        | Mobi       | Hatch      | branco |
| Chevrolet   | Onix Plus  | Hatch      | branco |
| Chevrolet   | Onix       | Hatch      | prata  |
| Hyundai     | HB20       | Hatch      | branco |
| Volkswagen  | Polo       | Hatch      | branco |
| Volkswagen  | Savero     | Hatch      | cinza  |
| Ford        | Fiesta     | Hatch      | preto  |
| Ford        | Ka         | Hatch      | cinza  |
| Ford        | Focus      | Hatch      | branco |
| Volkswagen  | Fusca      | Hatch      | cinza  |
| Fial        | Uno        | Hatch      | marron |
| Fial        | Gol        | Hatch      | preto  |
| Renault     | Kwid       | Hatch      | preto  |
| Fiat        | Argo       | Hatch      | preto  |
| Fial        | Gol        | Sedan      | prata  |
| Honda       | Civic      | Sedan      | prata  |
+-------------+------------+------------+--------+ */

-- 09. Lista de Motos que estão na oficina
SELECT marca, modelo, tipo_moto
FROM veiculos INNER JOIN motos on idVeiculo = idVeiculoMoto; /*
+----------+--------------+-----------+
| marca    | modelo       | tipo_moto |
+----------+--------------+-----------+
| Honda    | Biz 110//123 | esportiva |
| Suzuki   | SV650        | esportiva |
| Yamaha   | Fazer FZ25   | esportiva |
| Honda    | NXR 160 Bros | esportiva |
| Honda    | POP 110      | esportiva |
| Kawasaki | Ninja 300    | esportiva |
| Yamaha   | YZF-R3       | esportiva |
+----------+--------------+-----------+ */

-- 10. Quantidade de Veiculos na Oficina
SELECT COUNT(*) as 'Veiculos_na_oficina' from veiculos; /*
+---------------------+
| Veiculos_na_oficina |
+---------------------+
|                  30 |
+---------------------+ */

-- 11. Quanridades de clientes no Cadastro
SELECT COUNT(*) as 'Clientes_da_oficina' from clientes; /*
+---------------------+
| Clientes_da_oficina |
+---------------------+
|                  30 |
+---------------------+ */

-- 12. Quantos Clientes estão sendo atendidos no momento.
SELECT count(*)
FROM clientes NATURAL JOIN veiculos; /*
+----------+
| count(*) |
+----------+
|       30 |
+----------+ */

-- 13. Clientes que tem mais de um veículo na Oficina
SELECT nomeCliente, COUNT(idVeiculo) as 'quantidade_veiculo_cliente'
FROM clientes NATURAL JOIN veiculos
GROUP BY idCliente
HAVING COUNT(idVeiculo) > 1; /*
+----------------------------+------------------------+
| nome_cliente               | quantidade_veiculo_cliente |
+----------------------------+------------------------+
| Maria  da Silva            |                      2 |
| Júlia Rodrigues            |                      2 |
| Beatriz Alves              |                      3 |
| Maria da Costa             |                      2 |
| Alice Carvalho             |                      2 |
| Júnior Barbosa             |                      2 |
| Ana Clara Rodrigues Costa  |                      2 |
| Lucas Gabriel Pereira Lima |                      2 |
+----------------------------+------------------------+ */

-- 14. Quantidade de Cada tipo de veiculo na Oficina
SELECT tipoVeiculo, COUNT(*) as 'Quantidade_por_Tipo_Veiculo'
FROM clientes NATURAL JOIN veiculos
GROUP BY tipoVeiculo; /*
+--------------+----------------------+
| tipoVeiculo | Quantidade_por_Tipo_Veiculo |
+--------------+----------------------+
| Carro        |                   23 |
| Moto         |                    7 |
+--------------+----------------------+ */

-- 15. Quail o custo com as peças mais usadas?
select nomePeca, count(idPecaServico) as 'Quantidade_Total_de_Pecas_Usadas', precoPeca, 
CONCAT('R$ ', FORMAT((count(idPecaServico)*precoPeca),2,'de_DE')) as 'Custo Total com as Peças'
from servicos INNER join pecas on idPecaServico = idPeca
GROUP BY idPecaServico
HAVING count(idPecaServico) > 4
ORDER BY count(idPecaServico); /*
+----------------------------------------------+----------------------------+------------+--------------------------+
| nomePeca                                | Quantidade_Total_de_Pecas_Usadas| precoPeca  | Custo Total com as Peças |
+----------------------------------------------+----------------------------+------------+--------------------------+
| Bomba de combustível                         |                          7 |    1377.00 | R$ 9.639,00              |
| Suspensão dianteira                          |                          7 |    1311.00 | R$ 9.177,00              |
| Virabrequim                                  |                          7 |    1627.00 | R$ 11.389,00             |
| Câmbio manual/automático                     |                          6 |    1746.00 | R$ 10.476,00             |
| Mangueiras e tubulações do ar-condicionado   |                          6 |    1513.00 | R$ 9.078,00              |
| Radiador de arrefecimento do ar-condicionado |                          6 |    1370.00 | R$ 8.220,00              |
| Servo freio                                  |                          6 |    1583.00 | R$ 9.498,00              |
| Transmissão                                  |                          6 |    1692.00 | R$ 10.152,00             |
| Barra de direção                             |                          5 |    1606.00 | R$ 8.030,00              |
| Diferencial                                  |                          5 |    1323.00 | R$ 6.615,00              |
| Embreagem                                    |                          5 |    1744.00 | R$ 8.720,00              |
| Tanque de combustível                        |                          5 |    1384.00 | R$ 6.920,00              |
+----------------------------------------------+----------------------------+------------+--------------------------+ */