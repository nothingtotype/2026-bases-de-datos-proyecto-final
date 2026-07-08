
-- 4. Datos de prueba (seed data)

INSERT INTO categorias (nombre) VALUES
    ('Electrónica'),
    ('Muebles'),
    ('Ropa'),
    ('Alimentos');

INSERT INTO proveedores (nombre, correo, telefono, direccion) VALUES
    ('Proveedor Alpha', 'alpha@correo.com', '555-1001', 'Calle 1, Ciudad A'),
    ('Proveedor Beta',  'beta@correo.com',  '555-1002', 'Calle 2, Ciudad B'),
    ('Proveedor Gamma', 'gamma@correo.com', '555-1003', 'Calle 3, Ciudad C');

INSERT INTO productos (nombre, descripcion, precio, categoria_id, proveedor_id) VALUES
    ('Laptop',       'Laptop 15 pulgadas',  15000.00, 1, 1),
    ('Silla',        'Silla de oficina',     2500.00, 2, 2),
    ('Camiseta',     'Camiseta de algodón',   350.00, 3, 3),
    ('Arroz 1kg',    'Arroz blanco 1kg',       45.00, 4, 2),
    ('Monitor',      'Monitor 24 pulgadas',  5000.00, 1, 1);

INSERT INTO movimientos_stock (producto_id, cantidad, tipo, notas) VALUES
    (1, 10, 'ENTRADA', 'Compra inicial'),
    (2, 25, 'ENTRADA', 'Compra inicial'),
    (3, 50, 'ENTRADA', 'Compra inicial'),
    (4, 100,'ENTRADA', 'Compra inicial'),
    (5, 15, 'ENTRADA', 'Compra inicial'),
    (1, 2,  'SALIDA',  'Venta al cliente'),
    (3, 5,  'SALIDA',  'Venta al cliente');