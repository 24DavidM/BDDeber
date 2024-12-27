-- Crear la base de datos
CREATE DATABASE tiendaonline;

-- Usar la base de datos
USE tiendaOnline;


-- Crear tabla Productos
CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    Existencia INT NOT NULL
);

-- Crear tabla Ordenes
CREATE TABLE Ordenes (
    OrdenID INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES Productos(ProductoID)
);

-- Crear tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

-- Crear tabla Cuentas
CREATE TABLE Cuentas (
    CuentaID INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(255) NOT NULL
);

-- Crear tabla Transacciones
CREATE TABLE Transacciones (
    TransaccionID INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_id INT NOT NULL,
    tipo_transaccion ENUM('deposito', 'retiro') NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cuenta_id) REFERENCES Cuentas(CuentaID)
);


-- Insertar datos en Productos
INSERT INTO Productos (nombre, precio, Existencia)
VALUES 
('Producto A', 100.00, 10),
('Producto B', 150.00, 5),
('Producto C', 200.00, 20);

-- Insertar datos en Ordenes
INSERT INTO Ordenes (producto_id, cantidad)
VALUES 
(1, 2), 
(2, 1), 
(3, 3);

-- Insertar datos en Usuarios
INSERT INTO Usuarios (nombre, fecha_nacimiento)
VALUES 
('Juan Perez', '1990-05-15'),
('Ana Lopez', '1985-11-20'),
('Carlos Garcia', '2000-01-01');

-- Insertar datos en Cuentas
INSERT INTO Cuentas (titular)
VALUES 
('Juan Perez'),
('Ana Lopez'),
('Carlos Garcia');

-- Insertar datos en Transacciones
INSERT INTO Transacciones (cuenta_id, tipo_transaccion, monto)
VALUES 
(1, 'deposito', 1000.00),
(1, 'retiro', 200.00),
(2, 'deposito', 500.00),
(2, 'retiro', 100.00),
(3, 'deposito', 2000.00);


DELIMITER //
-- Crear función CalcularTotalOrden
CREATE FUNCTION CalcularTotalOrden(id_orden INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    DECLARE iva DECIMAL(10, 2);

    SET iva = 0.15;

    SELECT SUM(P.precio * O.cantidad) INTO total
    FROM Ordenes O
    JOIN Productos P ON O.producto_id = P.ProductoID
    WHERE O.OrdenID = id_orden;

    SET total = total + (total * iva);

    RETURN total;
END //

DELIMITER ;

SELECT CalcularTotalOrden(1);


DELIMITER //

-- Crear función CalcularEdad
CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE edad INT;
    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END //

DELIMITER ;

SELECT CalcularEdad("1999,12,21") AS EDDAD;


DELIMITER //

-- Crear función VerificarStock
CREATE FUNCTION VerificarStock(producto_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock INT;

    SELECT Existencia INTO stock
    FROM Productos
    WHERE ProductoID = producto_id;

    IF stock > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;

SELECT VerificarStock(1);

DELIMITER //

-- Crear función CalcularSaldo
CREATE FUNCTION CalcularSaldo(id_cuenta INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE saldo DECIMAL(10, 2);

    SELECT SUM(CASE
        WHEN tipo_transaccion = 'deposito' THEN monto
        WHEN tipo_transaccion = 'retiro' THEN -monto
        ELSE 0
    END) INTO saldo
    FROM Transacciones
    WHERE cuenta_id = id_cuenta;

    RETURN saldo;
END //

DELIMITER ;

SELECT CalcularSaldo(2)