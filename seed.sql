-- ───────────────────────────────
-- SEED DATA — ejecutar en pgAdmin
-- ───────────────────────────────
-- Orden importante: categorias y proveedores primero,
-- luego productos, luego movimientos_stock

-- Limpiar datos existentes (opcional, comentar si no se desea)
TRUNCATE TABLE movimientos_stock, historial, productos, categorias, proveedores RESTART IDENTITY CASCADE;


-- ───────────────────────────────
-- CATEGORIAS (10)
-- ───────────────────────────────

INSERT INTO categorias (nombre) VALUES
    ('Electrónica'),
    ('Muebles'),
    ('Ropa'),
    ('Alimentos'),
    ('Herramientas'),
    ('Juguetes'),
    ('Deportes'),
    ('Salud y Belleza'),
    ('Papelería'),
    ('Electrodomésticos');


-- ───────────────────────────────
-- PROVEEDORES (10)
-- ───────────────────────────────

INSERT INTO proveedores (nombre, correo, telefono, direccion) VALUES
    ('Distribuidora del Norte',  'contacto@delnorte.com',    '33-1001-2001', 'Av. Industrial 101, Guadalajara, Jalisco'),
    ('Importaciones Rápidas',    'ventas@imprapidas.com',    '55-2002-3002', 'Calle Comercio 45, Ciudad de México, CDMX'),
    ('Proveedora Central',       'info@provcentral.com',     '81-3003-4003', 'Blvd. Principal 300, Monterrey, Nuevo León'),
    ('Suministros del Bajío',    'pedidos@bajio.com',        '47-4004-5004', 'Carr. León-Silao Km 5, León, Guanajuato'),
    ('Mayoreo Express',          'mayoreo@express.com',      '33-5005-6005', 'Zona Industrial 88, Zapopan, Jalisco'),
    ('Tech Suppliers MX',        'soporte@techsuppliers.mx', '55-6006-7006', 'Polanco 220, Ciudad de México, CDMX'),
    ('Grupo Logístico Alva',     'operaciones@alva.com',     '33-7007-8007', 'Periférico Norte 500, Guadalajara, Jalisco'),
    ('Comercial Reyes',          'ventas@comercialreyes.com','81-8008-9008', 'Av. Constitución 77, Monterrey, Nuevo León'),
    ('Distribuciones Omega',     'omega@distomega.com',      '55-9009-1009', 'Sur 122 No. 34, Ciudad de México, CDMX'),
    ('Soluciones Industriales',  'contacto@solindustrial.mx','33-1010-2010', 'Av. Patria 640, Guadalajara, Jalisco');


-- ───────────────────────────────
-- PRODUCTOS (20)
-- ───────────────────────────────

INSERT INTO productos (nombre, descripcion, precio, categoria_id, proveedor_id) VALUES
    ('Laptop 15"',          'Laptop Intel Core i5, 8GB RAM, 512GB SSD',       15999.00,  1,  6),
    ('Monitor 24"',         'Monitor Full HD 1080p, panel IPS',                5499.00,  1,  6),
    ('Teclado Mecánico',    'Teclado mecánico RGB, switches azules',            1299.00,  1,  6),
    ('Mouse Inalámbrico',   'Mouse inalámbrico 2.4GHz, 1600 DPI',               449.00,  1,  6),
    ('Silla de Oficina',    'Silla ergonómica con soporte lumbar',              3200.00,  2,  1),
    ('Escritorio',          'Escritorio de madera 120x60cm',                   2800.00,  2,  1),
    ('Librero 5 Niveles',   'Librero de melamina blanca, 180cm de alto',       1500.00,  2,  4),
    ('Camiseta Polo',       'Camiseta polo 100% algodón, tallas S-XL',          350.00,  3,  8),
    ('Pantalón de Mezclilla','Pantalón slim fit, denim azul',                    890.00,  3,  8),
    ('Arroz 1kg',           'Arroz blanco grano largo, bolsa 1kg',               45.00,  4,  5),
    ('Aceite Vegetal 1L',   'Aceite vegetal para cocinar, botella 1L',           68.00,  4,  5),
    ('Frijoles 900g',       'Frijoles negros enteros, bolsa 900g',               55.00,  4,  5),
    ('Taladro Eléctrico',   'Taladro 550W con accesorios incluidos',            1100.00,  5,  7),
    ('Juego de Desarmadores','Set 12 piezas, punta plana y Phillips',            380.00,  5,  7),
    ('Pelota de Fútbol',    'Pelota oficial tamaño 5, cuero sintético',          450.00,  7, 10),
    ('Pesas 10kg',          'Par de mancuernas de hierro fundido 10kg',         1200.00,  7, 10),
    ('Shampoo 400ml',       'Shampoo para cabello seco, sin sal',                120.00,  8,  9),
    ('Cuaderno Profesional','Cuaderno 200 hojas cuadro chico, pasta dura',        95.00,  9,  2),
    ('Licuadora 1.5L',      'Licuadora 600W, 3 velocidades, vaso de vidrio',   1350.00, 10,  3),
    ('Microondas 20L',      'Microondas digital 700W, 20 litros',               2999.00, 10,  3);


-- ───────────────────────────────
-- MOVIMIENTOS DE STOCK (20)
-- ───────────────────────────────

INSERT INTO movimientos_stock (producto_id, cantidad, tipo, notas) VALUES
    ( 1,  15, 'ENTRADA', 'Compra inicial — lote laptops'),
    ( 2,  20, 'ENTRADA', 'Compra inicial — lote monitores'),
    ( 3,  30, 'ENTRADA', 'Compra inicial — teclados'),
    ( 4,  30, 'ENTRADA', 'Compra inicial — mouse'),
    ( 5,  10, 'ENTRADA', 'Compra inicial — sillas'),
    ( 6,   8, 'ENTRADA', 'Compra inicial — escritorios'),
    ( 7,  12, 'ENTRADA', 'Compra inicial — libreros'),
    ( 8,  50, 'ENTRADA', 'Compra inicial — camisetas polo'),
    ( 9,  40, 'ENTRADA', 'Compra inicial — pantalones'),
    (10, 100, 'ENTRADA', 'Compra inicial — arroz'),
    (11,  80, 'ENTRADA', 'Compra inicial — aceite vegetal'),
    (12,  90, 'ENTRADA', 'Compra inicial — frijoles'),
    (13,  15, 'ENTRADA', 'Compra inicial — taladros'),
    (14,  25, 'ENTRADA', 'Compra inicial — desarmadores'),
    (15,  20, 'ENTRADA', 'Compra inicial — pelotas fútbol'),
    ( 1,   3, 'SALIDA',  'Venta a cliente — factura #0001'),
    ( 2,   5, 'SALIDA',  'Venta a cliente — factura #0002'),
    ( 8,  10, 'SALIDA',  'Venta a cliente — factura #0003'),
    (10,  25, 'SALIDA',  'Venta a cliente — factura #0004'),
    (15,   4, 'SALIDA',  'Venta a cliente — factura #0005');