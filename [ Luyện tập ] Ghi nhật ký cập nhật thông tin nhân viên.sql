CREATE  TABLE employees (
    emp_id SERIAL PRIMARY KEY ,
    name VARCHAR(100),
    position VARCHAR(50)
);

CREATE TABLE employees_log (
    log_id SERIAL PRIMARY KEY ,
    emp_name VARCHAR(50),
    action_name TIMESTAMP
);

INSERT INTO employees (name, position) VALUES
    ('Nguyen Van A', 'Nhan vien'),
    ('Tran Thi B', 'Ke toan'),
    ('Le Van C', 'Quan ly');

CREATE OR REPLACE FUNCTION insert_employee_update_log()
RETURNS TRIGGER
AS $$
BEGIN
    INSERT INTO employees_log (emp_name, action_name)
    VALUES (NEW.name, CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_employee_update_log
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION insert_employee_update_log();

UPDATE employees
SET position = 'Truong phong'
WHERE emp_id = 1;

SELECT * FROM employees;
SELECT * FROM employees_log;