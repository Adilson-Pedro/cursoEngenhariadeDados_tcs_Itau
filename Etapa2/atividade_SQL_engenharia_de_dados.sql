--  Atividade 1 Listar os nomes e cidades de todos os clientes em uma só consulta

SELECT nome, cidade FROM Clientes;


-- Atividade 2 Listar os pedidos com valor acima de R$100

SELECT * FROM Pedidos WHERE valor > 100;

-- Atividade 3 Listar os pedidos ordenados pelo valor (decrescente)

SELECT * FROM Pedidos ORDER BY valor DESC;


-- Atividade 4 Listar os 3 primeiros produtos cadastrados

SELECT * FROM Produtos ORDER BY id_produto ASC LIMIT 3;


-- Atividade 5 Listar o total de valor gasto por cada cliente em pedidos.

SELECT Clientes.nome, SUM(Pedidos.valor) AS total_gasto
FROM Pedidos
JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
GROUP BY Clientes.nome
ORDER BY total_gasto DESC;


-- Atividade 6 Encontrar o cliente com o maior valor gasto

SELECT Clientes.nome, SUM(Pedidos.valor) AS total_gasto
FROM Pedidos
JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
GROUP BY Clientes.nome
ORDER BY total_gasto DESC
LIMIT 1;

-- Atividade 7 Utilizar CTE para calcular o total de vendas por produto

WITH TotalVendas AS (
    SELECT Produtos.nome_produto, SUM(ItensPedido.quantidade * Produtos.preco) AS total_vendas
    FROM ItensPedido
    JOIN Produtos ON ItensPedido.id_produto = Produtos.id_produto
    GROUP BY Produtos.nome_produto
)
SELECT * FROM TotalVendas ORDER BY total_vendas DESC;


-- Atividade 8 Listar todos os produtos comprados por cada cliente

SELECT Clientes.nome AS cliente, Produtos.nome_produto AS produto, ItensPedido.quantidade
FROM ItensPedido
JOIN Pedidos ON ItensPedido.id_pedido = Pedidos.id_pedido
JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
JOIN Produtos ON ItensPedido.id_produto = Produtos.id_produto
ORDER BY Clientes.nome, Produtos.nome_produto;

-- Atividade 9 Ranquear clientes pelo valor total gasto começando pelo rank 1 para o maior valor.

WITH RankingClientes AS (
    SELECT Clientes.nome AS cliente, 
           SUM(Pedidos.valor) AS total_gasto,
           RANK() OVER (ORDER BY SUM(Pedidos.valor) DESC) AS ranking
    FROM Pedidos
    JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
    GROUP BY Clientes.nome
)
SELECT * FROM RankingClientes ORDER BY ranking;

-- Atividade 10 Número de pedidos por cliente, considerando apenas aqueles com mais de 1 pedido

SELECT Clientes.nome AS cliente, COUNT(Pedidos.id_pedido) AS numero_pedidos
FROM Pedidos
JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
GROUP BY Clientes.nome
HAVING COUNT(Pedidos.id_pedido) > 1
ORDER BY numero_pedidos DESC;


-- Atividade 11 Calcular para cada cliente a quantidade de dias entre um pedido e o pedido imediatamente anterior

WITH PedidosOrdenados AS (
    SELECT id_cliente, id_pedido, data_pedido,
           LAG(data_pedido) OVER (PARTITION BY id_cliente ORDER BY data_pedido) AS pedido_anterior
    FROM Pedidos
)
SELECT Clientes.nome AS cliente, 
       PedidosOrdenados.data_pedido AS data_atual,
       PedidosOrdenados.pedido_anterior AS data_anterior,
       JULIANDAY(PedidosOrdenados.data_pedido) - JULIANDAY(PedidosOrdenados.pedido_anterior) AS dias_entre_pedidos
FROM PedidosOrdenados
JOIN Clientes ON PedidosOrdenados.id_cliente = Clientes.id_cliente
WHERE PedidosOrdenados.pedido_anterior IS NOT NULL
ORDER BY Clientes.nome, PedidosOrdenados.data_pedido;


/* Atividade 12
Crie uma consulta que retorne um relatórios contedo as seguintes colunas (obs: use o padrão que preferir para nomear as colunas):
ID do cliente
Nome do cliente
Cidade do cliente
ID do pedido
Data do pedido
Valor do pedido
Preço do pedido sem desconto (pode ser recuperado somando a coluna "preço" de cada produto dentro do pedido)
Quantidade de dias entre o pedido e seu pedido imediatamente anterior */

WITH PedidosOrdenados AS (
    SELECT id_cliente, id_pedido, data_pedido,
           LAG(data_pedido) OVER (PARTITION BY id_cliente ORDER BY data_pedido) AS pedido_anterior
    FROM Pedidos
),
Relatorio AS (
    SELECT 
        Clientes.id_cliente,
        Clientes.nome AS nome_cliente,
        Clientes.cidade AS cidade_cliente,
        Pedidos.id_pedido,
        Pedidos.data_pedido,
        Pedidos.valor AS valor_pedido,
        SUM(Produtos.preco * ItensPedido.quantidade) AS preco_sem_desconto,
        JULIANDAY(Pedidos.data_pedido) - JULIANDAY(PedidosOrdenados.pedido_anterior) AS dias_entre_pedidos
    FROM Pedidos
    JOIN Clientes ON Pedidos.id_cliente = Clientes.id_cliente
    JOIN ItensPedido ON Pedidos.id_pedido = ItensPedido.id_pedido
    JOIN Produtos ON ItensPedido.id_produto = Produtos.id_produto
    LEFT JOIN PedidosOrdenados ON Pedidos.id_pedido = PedidosOrdenados.id_pedido
    GROUP BY Clientes.id_cliente, Pedidos.id_pedido
)
SELECT * FROM Relatorio ORDER BY nome_cliente, data_pedido;
