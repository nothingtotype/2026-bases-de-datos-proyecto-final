-- db/init.sql

-- 1. Primero: tablas sin dependencias (no tienen foreign keys)

CREATE TABLE IF NOT EXISTS categorias (
    id     SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS proveedores (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    correo         VARCHAR(100),
    telefono       VARCHAR(20),
    direccion      VARCHAR(200)
);

-- 2. Segundo: tablas que dependen de las anteriores

CREATE TABLE IF NOT EXISTS productos (
    id            SERIAL PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    descripcion   TEXT,
    precio        NUMERIC(10, 2) NOT NULL,
    categoria_id  INT REFERENCES categorias(id) ON DELETE SET NULL,
    proveedor_id  INT REFERENCES proveedores(id) ON DELETE SET NULL
);

-- 3. Tercero: tablas que dependen de productos

CREATE TABLE IF NOT EXISTS movimientos_stock (
    id          SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id) ON DELETE CASCADE,
    cantidad    INT NOT NULL,
    tipo        VARCHAR(10) CHECK (tipo IN ('ENTRADA', 'SALIDA')),
    fecha       TIMESTAMP DEFAULT NOW(),
    notas       TEXT
);