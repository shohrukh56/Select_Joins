INSERT INTO managers (id, name, login, salary, plan, unit, boss_id)
VALUES (1, 'Vasya', 'vasya', 100000, 0, NULL, NULL), -- Ctrl + D
       (2, 'Petya', 'petya', 90000, 90000, 'boy', 1),
       (3, 'Vanya', 'vanya', 80000, 80000, 'boy', 2),
       (4, 'Masha', 'masha', 80000, 80000, 'girl', 1),
       (5, 'Dasha', 'dasha', 60000, 60000, 'girl', 4),
       (6, 'Sasha', 'sasha', 40000, 40000, 'girl', 5);

INSERT INTO products(name, price, qty)
VALUES ('Big Mac', 200, 10),       -- 1
       ('Chicken Mac', 150, 15),   -- 2
       ('Cheese Burger', 100, 20), -- 3
       ('Tea', 50, 10),            -- 4
       ('Coffee', 80, 10),         -- 5
       ('Cola', 100, 20); -- 6

INSERT INTO sales(manager_id, product_id, price, qty)
VALUES (1, 1, 150, 10), -- Vasya big mac со скидкой
       (2, 2, 150, 5),  -- Petya Chicken Mac без скидки
       (3, 3, 100, 5),  -- Vanya Cheese Burger без скидки
       (4, 1, 250, 5),  -- Masha Big Mac с наценкой
       (4, 4, 100, 5),  -- Masha Tea тоже с наценкой
       (5, 5, 100, 5),  -- Dasha Coffee c наценкой
       (5, 6, 120, 10);
------------1
SELECT s.id, sum(s.qty * s.price) total, p.name, m.name
FROM sales s
         JOIN managers m on s.manager_id = m.id
         JOIN products p ON s.product_id = p.id
GROUP BY manager_id;
------------2
select m.name manager, ifnull(s.countManagers, 0) total
from managers m
         LEFT JOIN (select manager_id, count(manager_id) countManagers from sales group by manager_id) s
                   on m.id = s.manager_id;
-----------3
select m.name, ifnull(t.sum, 0) total
from managers m
         LEFT JOIN (SELECT s.manager_id, SUM(s.qty * s.price) sum FROM sales s Group By s.manager_id) t
                   on t.manager_id = m.id;
---------4
select p.name, ifnull(t.sum, 0) total
from products p
         LEFT JOIN (SELECT s.product_id, SUM(s.qty * s.price) sum FROM sales s Group By s.product_id) t
                   on t.product_id = p.id;
---------5
select m.name, ifnull(t.sum, 0) total
from managers m
         LEFT JOIN (SELECT s.manager_id, SUM(s.qty * s.price) sum FROM sales s Group By s.manager_id) t
                   on t.manager_id = m.id
ORDER BY sum desc
limit 3;
--------6
select p.name, ifnull(t.total, 0) total
from products p
         LEFT JOIN (SELECT s.product_id, SUM(s.qty) total FROM sales s Group By s.product_id) t on t.product_id = p.id
ORDER BY total desc
limit 3;
--------7
select p.name, ifnull(t.sum, 0) total
from products p
         LEFT JOIN (SELECT s.product_id, SUM(s.qty * s.price) sum FROM sales s Group By s.product_id) t
                   on t.product_id = p.id
ORDER BY sum desc
limit 3;
-------8
select m.name, m.plan, ifnull(t.sum, 0) sum, ifnull((t.sum * 100.0) / m.plan, 0) percent
from managers m
         LEFT JOIN (SELECT s.manager_id, SUM(s.qty * s.price) sum FROM sales s Group By s.manager_id) t
                   on t.manager_id = m.id;
-------9
select ifnull(m.unit, 'boss') unit, ifnull(sum(t.sum) * 100.0 / sum(m.plan), 0) percent
from managers m
         LEFT JOIN (SELECT s.manager_id, SUM(s.qty * s.price) sum FROM sales s Group By s.manager_id) t
                   on t.manager_id = m.id
GROUP BY m.unit;

