-- Crear la base de datos
CREATE DATABASE tienda_online;

-- Usar la base de datos
USE tienda_online;

-- Crear la tabla Clientes
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    fecha_registro DATE NOT NULL
);

-- Crear la tabla Productos
CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    descripcion TEXT
);

-- Crear la tabla Pedidos
CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- Crear la tabla Detalles_Pedido
CREATE TABLE Detalles_Pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);


-- Insertar registros en la tabla Clientes
INSERT INTO Clientes (nombre, apellido, email, telefono, fecha_registro)
VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '1234567890', '2020-01-15'),
('María', 'Gómez', 'maria.gomez@email.com', '0987654321', '2021-03-25'),
('Carlos', 'López', 'carlos.lopez@email.com', '1122334455', '2022-07-10');

-- Insertar registros en la tabla Productos
INSERT INTO Productos (nombre, precio, stock, descripcion)
VALUES
('Producto A', 20.00, 100, 'Descripción del producto A'),
('Producto B', 50.00, 200, 'Descripción del producto B'),
('Producto C', 30.00, 50, 'Descripción del producto C');

-- Insertar registros en la tabla Pedidos
INSERT INTO Pedidos (id_cliente, fecha_pedido, total)
VALUES
(1, '2023-12-01', 200.00),
(2, '2023-12-10', 150.00),
(3, '2023-12-15', 300.00);

-- Insertar registros en la tabla Detalles_Pedido
INSERT INTO Detalles_Pedido (id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(1, 1, 5, 20.00),
(1, 2, 3, 50.00),
(2, 2, 2, 50.00),
(3, 3, 4, 30.00);


DELIMITER //

CREATE FUNCTION nombreCompletos(p_cliente_id INT)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    RETURN 
        (SELECT CONCAT(nombre, ' ', apellido) 
         FROM Clientes 
         WHERE id_cliente = p_cliente_id 
         LIMIT 1);
END  //

DELIMITER ;

SELECT nombreCompletos(1) AS NombreCompleto;




DELIMITER //

CREATE FUNCTION calculardescuento(precio DECIMAL(10,2), descuento DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio - (precio * (descuento / 100));
END //

DELIMITER ;

SELECT calculardescuento(50.00, 10) AS Descuento; 


DELIMITER //

CREATE FUNCTION calculartotal(id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad * precio_unitario) INTO total
    FROM Detalles_Pedido
    WHERE id_pedido = id_pedido;
    RETURN total;
END //

DELIMITER ;

SELECT calculartotal(1); 


DELIMITER //

CREATE FUNCTION verificarstocks(id_producto INT, cantidad INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;
    SELECT stock INTO stock_actual
    FROM Productos
    WHERE id_producto = id_producto
    LIMIT 1;

    IF stock_actual >= cantidad THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;

SELECT verificarstocks(1, 10) AS VerificarStock_1TRUE_0FALSE;



DELIMITER //

CREATE FUNCTION calcularantiguedads(id_clientes INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(
        YEAR, 
        (SELECT fecha_registro FROM Clientes WHERE id_cliente = id_clientes LIMIT 1), 
        CURDATE()
    );
END //

DELIMITER ;

SELECT calcularantiguedads(1);


