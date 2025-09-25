-- Mostrar as tabelas no banco de dados
SHOW TABLES;


-- 1) Valor total da receita e unidades vendidas
SELECT  
    SUM(po.poQuantity) AS total_unidades_vendidas,
    SUM(po.poQuantity * o.value) AS receita_total,
    ROUND((SUM(po.poQuantity * o.value) / COUNT(DISTINCT o.idOrder)),2) AS ticket_medio
FROM productOrder po
JOIN orders o
    ON po.idOrder = o.idOrder
WHERE o.OrdersStatus <> 'CANCELADO';


-- 2) Receita total e unidades vendidas por categoria
SELECT  
    p.category AS categoria,
    SUM(po.poQuantity) AS total_unidades_vendidas,
    SUM(po.poQuantity * o.value) AS receita_total,
    ROUND(
        SUM(po.poQuantity * o.value) / 
        (SELECT SUM(po2.poQuantity * o2.value)
         FROM productOrder po2
         JOIN orders o2 ON po2.idOrder = o2.idOrder
         WHERE o2.OrdersStatus <> 'CANCELADO') * 100, 2
    ) AS representatividade
FROM product p
JOIN productOrder po
    ON po.idProduct = p.idProduct
JOIN orders o
    ON po.idOrder = o.idOrder
WHERE o.OrdersStatus <> 'CANCELADO'    
GROUP BY p.category
ORDER BY receita_total DESC;


-- 3) Qual cliente fez mais pedidos?
SELECT  c.idClient AS cod_cliente, 
        concat(c.Fname, ' ', c.Lname) AS cliente, 
        COUNT(o.idOrder) AS total_pedidos,
        SUM(o.value) AS valor_total
FROM client c
JOIN orders o 
    ON c.idClient = o.idClient
GROUP BY c.idClient, c.Fname, c.Lname
ORDER BY total_pedidos DESC
LIMIT 1;


-- 4) Qual foi o valor total gasto por cada cliente (somando pedidos)?
SELECT  c.idClient AS cod_cliente, 
        concat(c.Fname, ' ', c.Lname) AS cliente,
        SUM(o.value) AS total_gasto
FROM client c
JOIN orders o 
    ON c.idClient = o.idClient
WHERE o.OrdersStatus <> 'CANCELADO'
GROUP BY c.idClient, c.Fname, c.Lname
ORDER BY total_gasto DESC;


-- 5) Qual é a média de valor dos pedidos já entregues?
SELECT ROUND(AVG(o.value),2) AS media_valor_ped_entregues
FROM orders o
JOIN delivery d 
    ON o.idOrder = d.idOrder
WHERE d.Status = 'ENTREGUE';


-- 6) Quantos pedidos foram pagos via cada método de pagamento?
SELECT  p.methodPayment AS tipo_pagamento, 
        COUNT(DISTINCT po.idOrder) AS total_pedidos
FROM payments p
JOIN PaymentOrder po 
    ON p.idPayment = po.idPayment
WHERE p.PaymentsStatus = 'APROVADO'
GROUP BY p.methodPayment
ORDER BY total_pedidos DESC;


-- 7) Qual é o percentual de pedidos cancelados em relação ao total?
SELECT 
    ROUND(
      (SUM(
      CASE WHEN OrdersStatus = 'CANCELADO' THEN 1 
      ELSE 0 
      END) * 100.0) / COUNT(*), 2) AS percentual_pedidos_cancelados
FROM orders;


-- 8) TOP 10 Produtos mais vendidos por quantidade.
SELECT  p.Pname AS produto, 
        SUM(po.poQuantity) AS total_vendido,
        ROUND((SUM(p.price * po.poQuantity) / SUM(po.poQuantity)),2) AS preco_medio_prod
FROM productOrder po
JOIN product p 
    ON po.idProduct = p.idProduct
GROUP BY p.Pname
ORDER BY total_vendido DESC
LIMIT 10;


-- 9) Receita total obtida por cada método de pagamento.
SELECT  p.methodPayment AS tipo_pagamento, 
        SUM(po.ValuePayments) AS receita_total
FROM payments p
JOIN PaymentOrder po 
    ON p.idPayment = po.idPayment
WHERE p.PaymentsStatus = 'APROVADO'
GROUP BY p.methodPayment
ORDER BY receita_total DESC;

