-- Creating tables --
CREATE TABLE Mechanic(
	mech_staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(25),
	last_name VARCHAR(25)
);

CREATE TABLE Vehicle(
	serial_num SERIAL PRIMARY KEY,
	make VARCHAR(25),
	model VARCHAR(25),
	price VARCHAR(25),
	_year VARCHAR(25),
	used BOOLEAN,
	sold BOOLEAN
);

CREATE TABLE Parts(
	part_id SERIAL PRIMARY KEY,
	_name VARCHAR(25),
	price NUMERIC(4,2)
);

CREATE TABLE Sales_Person(
	sales_person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(25),
	last_name VARCHAR(25)
);

CREATE TABLE Customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	phone VARCHAR(15)
);

CREATE TABLE Sale(
	sale_id SERIAL PRIMARY KEY,
	amount NUMERIC(8,2),
	loan_sale NUMERIC(20,2),
	serial_num INTEGER NOT NULL,
	FOREIGN KEY(serial_num) REFERENCES Vehicle(serial_num)
);

CREATE TABLE Services(
	service_id SERIAL PRIMARY KEY,
	amount NUMERIC(4,2),
	task VARCHAR(25),
	part_id INTEGER NOT NULL,
	FOREIGN KEY(part_id) REFERENCES Parts(part_id)
);

CREATE TABLE Mechanic_Services(
	mech_services_id SERIAL PRIMARY KEY,
	mech_staff_id INTEGER,
	service_id INTEGER NOT NULL,
	FOREIGN KEY(service_id) REFERENCES Services(service_id)
);

CREATE TABLE Invoice(
	invoice_id SERIAL PRIMARY KEY,
	date TIMESTAMP,
	sales_person_id INTEGER NOT NULL,
	FOREIGN KEY(sales_person_id) REFERENCES Sales_Person(sales_person_id),
	sale_id INTEGER NOT NULL,
	FOREIGN KEY(sale_id) REFERENCES Sale(sale_id),
	customer_id INTEGER NOT NULL,
	FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
	service_id INTEGER NOT NULL,
	FOREIGN KEY(service_id) REFERENCES Services(service_id)
);
-- Removing "NOT NULL" on service_id & sale_id from Invoice table --
ALTER TABLE Invoice
DROP COLUMN service_id;

SELECT *
FROM Invoice;

ALTER TABLE Invoice
ADD COLUMN Service_id INTEGER;

ALTER TABLE Invoice
ADD FOREIGN KEY(service_id) REFERENCES Services(service_id);

ALTER TABLE Invoice
DROP COLUMN sale_id;

ALTER TABLE Invoice
ADD COLUMN sale_id INTEGER;

ALTER TABLE Invoice
ADD FOREIGN KEY(sale_id) REFERENCES Sale(sale_id);

-- Inserting data into tables --
INSERT INTO Mechanic(
	first_name,
	last_name
)
VALUES(
	'Luffy',
	'Monkey'
),
(   'Zoro',
    'Roronoa'
),
(   'Nami',
    'Dorobo neko'
),
(   'Usopp',
    'Sogeking'
);

SELECT *
FROM mechanic;

INSERT INTO Vehicle(
	make,
	model,
	price,
	_year,
	used,
	sold
)
VALUES(
	'Toyota',
	'Tacoma',
	60000.00,
	2021,
	FALSE,
	FALSE
),
(   'Nissan',
    'Murano',
    50000.00,
    2020,
    FALSE,
    FALSE
),
(   'Ford',
    'Bronco',
    32000.00,
    2016,
    TRUE,
    TRUE
),
(   'Mini',
    'John Cooper Works',
    25000.00,
    2015,
    TRUE,
    TRUE
);

SELECT *
FROM Vehicle;

INSERT INTO Parts(
	_name,
	price	
)
VALUES(
	'break_pedal',
	50
),
(   'air_filter',
    20
),
(   'battery',
    95
);

SELECT *
FROM Parts;

INSERT INTO Sales_Person(
	first_name,
	last_name
)
VALUES(
	'Sanji',
	'Vinsmoke'
),
(   'Chopper',
    'Tony tony'
),
(   'Nico',
    'Robin'
);

SELECT *
FROM Sales_person;

UPDATE Sales_person
SET first_name = 'Robin'
WHERE sales_person_id = 3;

UPDATE Sales_person
SET last_name = 'Nico'
WHERE sales_person_id = 3;

INSERT INTO Customer(
	first_name,
	last_name,
	phone
)
VALUES(
	'Edward',
	'Newgate',
	'1234567899'
),
(   'Ace',
    'Portgas',
    '1112223333'
),
(   'Gol',
    'Roger',
    '2223334444'
),
(   'Law',
    'Trafalgar',
    '3334445555'
);

SELECT *
FROM Customer;

INSERT INTO Sale(
	amount,
	loan_sale,
	serial_num
)
VALUES(
	35000,
	20000,
	3
),
(   
	28000,
	0,
	4
);

SELECT *
FROM Sale;

INSERT INTO Services(
	amount,
	task,
	part_id
)	
VALUES(
	80,
	'change break pedal',
	1	
),
(   70,
    'change air filter',
    2
);

SELECT *
FROM Services;

INSERT INTO Mechanic_Services(
	mech_staff_id,
	service_id
)
VALUES(
	3,
	2
),
(   4,
    1
);

SELECT *
FROM Mechanic_Services;

INSERT INTO Invoice(
	sales_person_id,
	sale_id,
	customer_id,
	service_id
)
VALUES(
	1,
	1,
	2,
	NULL	
),
(   
	2,
	2,
	1,
	NULL
),
(   
	3,
	NULL,
    4,
    1
),
(   
	3,
	NULL,
    3,
    2
);

-- Procedure & Function --

ALTER TABLE services
ALTER COLUMN amount TYPE NUMERIC(5,2);

SELECT *
FROM services;

CREATE OR REPLACE PROCEDURE add_labor_cost(
    service INTEGER,
    labor_cost DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Services
	SET amount = amount + labor_cost
	WHERE service_id = service;
	
	COMMIT;
END;
$$

CALL add_labor_cost(1, 100.00);
CALL add_labor_cost(2, 75.00);

SELECT *
FROM services;

CREATE OR REPLACE FUNCTION add_customer(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _phone VARCHAR)
RETURNS void
AS $$
BEGIN 
    INSERT INTO customer(customer_id, first_name, last_name, phone)
	VALUES (_customer_id, _first_name, _last_name, _phone);
END;
$$
LANGUAGE plpgsql;

SELECT add_customer(10, 'Rayleigh', 'Silvers', '9999999999');

SELECT *
FROM customer;