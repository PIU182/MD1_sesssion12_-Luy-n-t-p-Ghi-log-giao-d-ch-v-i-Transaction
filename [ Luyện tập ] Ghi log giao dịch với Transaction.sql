CREATE TABLE products (
    product_id SERIAL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL ,
    price NUMERIC(10 ,2) NOT NULL ,
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    product_id   INT REFERENCES products (product_id),
    quantity     INT NOT NULL,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE orders_log (
    log_id SERIAL PRIMARY KEY ,
    order_id INT,
    action_time TIMESTAMP
);

INSERT INTO products (name, price, stock) VALUES
    ('Áo sơ mi', 300000, 10),
    ('Quần jeans', 500000, 5),
    ('Giày thể thao', 800000, 3);

BEGIN;

DO $$
DECLARE
    v_product_id INT := 1;
    v_quantity INT := 2;
    v_price NUMERIC(10, 2);
    v_stock INT;
    v_order_id INT;
    v_total_amount NUMERIC(10, 2);
BEGIN
    SELECT price, stock INTO v_price, v_stock
    FROM products
    WHERE product_id = v_product_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'San pham khong ton tai';
    end if;

    IF v_stock < v_quantity THEN
        RAISE EXCEPTION 'Khong du ton kho';
    end if;

    v_total_amount := v_price * v_quantity;

    INSERT INTO orders (product_id, quantity, total_amount)
    VALUES (v_product_id, v_quantity, v_total_amount)
    RETURNING order_id INTO v_order_id;

    --  Giảm tồn kho va ghi log đơn hàng
    UPDATE products
    SET stock = stock - v_quantity
    WHERE product_id = v_product_id;

    --Thực hành thử: nhập đơn hàng với số lượng vượt quá tồn kho
    UPDATE products
    SET stock = stock - 100
    WHERE product_id = v_product_id;

    INSERT INTO orders_log (order_id, action_time)
    VALUES (v_order_id, CURRENT_TIMESTAMP);
end;
$$;

COMMIT;
ROLLBACK ;

--Kiem tra bang
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orders_log;



