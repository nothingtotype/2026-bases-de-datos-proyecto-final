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

-- ───────────────────────────────
-- HISTORIAL DE CAMBIOS
-- ───────────────────────────────

CREATE TABLE IF NOT EXISTS historial (
    id          SERIAL PRIMARY KEY,
    tabla       VARCHAR(50)  NOT NULL,
    operacion   VARCHAR(10)  NOT NULL CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE')),
    registro_id INT,
    descripcion TEXT,
    fecha       TIMESTAMP DEFAULT NOW()
);

-- ───────────────────────────────
-- FUNCION DEL TRIGGER
-- ───────────────────────────────
-- This function runs automatically after any INSERT, UPDATE, or DELETE
-- on any table that has the trigger attached to it.
-- TG_TABLE_NAME = name of the table that fired the trigger
-- TG_OP         = operation: INSERT, UPDATE, DELETE
-- NEW           = the new row (available on INSERT and UPDATE)
-- OLD           = the old row (available on UPDATE and DELETE)

CREATE OR REPLACE FUNCTION registrar_historial()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO historial (tabla, operacion, registro_id, descripcion)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.id, 'Registro creado con ID ' || NEW.id);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO historial (tabla, operacion, registro_id, descripcion)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.id, 'Registro actualizado con ID ' || NEW.id);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO historial (tabla, operacion, registro_id, descripcion)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.id, 'Registro eliminado con ID ' || OLD.id);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────
-- TRIGGERS — one per table
-- ───────────────────────────────
-- AFTER means the trigger fires after the operation succeeds
-- FOR EACH ROW means it fires once per affected row

CREATE TRIGGER trigger_historial_categorias
AFTER INSERT OR UPDATE OR DELETE ON categorias
FOR EACH ROW EXECUTE FUNCTION registrar_historial();

CREATE TRIGGER trigger_historial_proveedores
AFTER INSERT OR UPDATE OR DELETE ON proveedores
FOR EACH ROW EXECUTE FUNCTION registrar_historial();

CREATE TRIGGER trigger_historial_productos
AFTER INSERT OR UPDATE OR DELETE ON productos
FOR EACH ROW EXECUTE FUNCTION registrar_historial();

CREATE TRIGGER trigger_historial_movimientos
AFTER INSERT OR UPDATE OR DELETE ON movimientos_stock
FOR EACH ROW EXECUTE FUNCTION registrar_historial();