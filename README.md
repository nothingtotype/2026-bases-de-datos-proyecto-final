## `README.md`

# 📦 Sistema de Inventario

Aplicación web full-stack desarrollada como proyecto final para la materia de **Bases de Datos**.  
El objetivo principal es demostrar el entendimiento de bases de datos PostgreSQL, normalización de datos y operaciones CRUD completas.

---

## 📋 Tabla de Contenidos

- [Arquitectura](#arquitectura)
- [Stack Tecnológico](#stack-tecnológico)
- [Por Qué Este Stack](#por-qué-este-stack)
- [Requisitos](#requisitos)
- [Cómo Ejecutar la Aplicación](#cómo-ejecutar-la-aplicación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Esquema de la Base de Datos](#esquema-de-la-base-de-datos)
- [Endpoints de la API](#endpoints-de-la-api)
- [Cómo Probar la API](#cómo-probar-la-api)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Autores](#autores)

---

## Arquitectura

La aplicación sigue una arquitectura de **tres capas** completamente contenida en Docker:

```
                        ┌─────────────────────────────────────────┐
                        │           Docker Compose Network         │
                        │                                         │
  Navegador  ──HTTP──>  │  ┌─────────┐   ┌─────────┐  ┌───────┐ │
  puerto 80             │  │  nginx  │──>│ FastAPI │─>│  DB   │ │
                        │  │ :80     │   │ :8000   │  │ :5432 │ │
                        │  │Frontend │   │ Backend │  │Postgres│ │
                        │  └─────────┘   └─────────┘  └───────┘ │
                        └─────────────────────────────────────────┘
```

- **Frontend (nginx):** Sirve los archivos HTML, CSS y JavaScript estáticos en el puerto 80.
- **Backend (FastAPI):** Recibe peticiones HTTP del navegador, ejecuta la lógica de negocio y consulta la base de datos. Expuesto en el puerto 8000.
- **Base de Datos (PostgreSQL):** Almacena toda la información. Incluye triggers que registran automáticamente cada cambio en el historial.

### Flujo de una petición

```
1. El usuario hace clic en "Agregar Producto" en el navegador
2. app.js ejecuta fetch("POST /productos", { body: JSON })
3. FastAPI valida los datos con Pydantic (schemas.py)
4. SQLAlchemy construye y ejecuta el INSERT en PostgreSQL
5. El trigger de PostgreSQL registra el evento en la tabla historial
6. FastAPI devuelve el nuevo registro como JSON
7. app.js actualiza la tabla en pantalla sin recargar la página
```

---

## Stack Tecnológico

| Capa | Tecnología | Versión |
|---|---|---|
| Base de Datos | PostgreSQL | 16 |
| ORM | SQLAlchemy | Latest |
| Backend | FastAPI + Uvicorn | Latest |
| Validación | Pydantic | V2 |
| Frontend | HTML + CSS + JavaScript | Vanilla |
| Servidor Web | Nginx | Alpine |
| Contenedores | Docker + Docker Compose | Latest |

---

## Por Qué Este Stack

### PostgreSQL
PostgreSQL es uno de los motores de bases de datos relacionales más robustos y completos disponibles. Se eligió porque:
- Soporte nativo para **triggers y funciones almacenadas** (PL/pgSQL), utilizados para el historial automático de cambios.
- Manejo estricto de **restricciones de integridad referencial** (FOREIGN KEY, CHECK, NOT NULL).
- Permite demostrar claramente la **normalización hasta Tercera Forma Normal (3NF)**.
- Es el estándar de la industria para aplicaciones de producción.

### FastAPI
- Permite definir endpoints de forma **clara y declarativa** con muy poco código.
- Genera automáticamente una **página de documentación interactiva** en `/docs` (Swagger UI) sin configuración adicional.
- Integración nativa con **Pydantic** para validación automática de datos entrantes y salientes.
- Basado en Python, lenguaje familiar para el equipo.

### SQLAlchemy
- Permite definir las tablas como **clases de Python**, haciendo el código más legible y mantenible.
- Maneja automáticamente la conexión y sesiones con PostgreSQL.
- Evita errores comunes de SQL escritos como strings (typos, inyección SQL).

### HTML + CSS + JavaScript Vanilla
- No requiere conocimiento de frameworks como React o Vue.
- **Sin proceso de compilación** — los archivos se sirven directamente.
- Fácil de depurar directamente en el navegador.
- Demuestra comprensión de los fundamentos web sin dependencias innecesarias.

### Docker + Docker Compose
- **Un solo comando** levanta toda la aplicación (`docker compose up --build`).
- Garantiza que la aplicación corre igual en cualquier máquina.
- Elimina problemas de versiones o configuraciones locales.
- Refleja prácticas reales de la industria.

---

## Requisitos

Solo necesitas tener instalado:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

Eso es todo. No necesitas instalar Python, PostgreSQL, ni ninguna otra dependencia de forma local.

---

## Cómo Ejecutar la Aplicación

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/sistema-inventario.git
cd sistema-inventario
```

### 2. Levantar todos los contenedores

```bash
docker compose up --build
```

Esto realiza automáticamente los siguientes pasos en orden:
1. Descarga las imágenes de PostgreSQL y Nginx
2. Construye la imagen de FastAPI
3. Inicia PostgreSQL y espera a que esté listo (healthcheck)
4. Ejecuta `init.sql` — crea las tablas, triggers y datos iniciales
5. Inicia FastAPI conectado a PostgreSQL
6. Inicia Nginx sirviendo el frontend

### 3. Abrir la aplicación

| Servicio | URL |
|---|---|
| Aplicación web | http://localhost |
| Documentación API (Swagger) | http://localhost:8000/docs |
| Documentación API (ReDoc) | http://localhost:8000/redoc |

### 4. Cargar datos de prueba (opcional)

Si deseas cargar los 20 productos, 10 categorías, 10 proveedores y 20 movimientos de prueba:

1. Abre **pgAdmin** y conéctate con estas credenciales:

```
Host:     localhost
Puerto:   5432
Usuario:  admin
Password: password123
Base de datos: inventario_db
```

2. Abre el **Query Tool** sobre `inventario_db`
3. Abre el archivo `db/seed_data.sql` y ejecuta con **F5**

### 5. Detener la aplicación

```bash
# Detener sin borrar datos
docker compose down

# Detener y borrar todos los datos (reinicio completo)
docker compose down -v
```

---

## Estructura del Proyecto

```
sistema-inventario/
│
├── docker-compose.yml          # Orquestación de los tres contenedores
│
├── db/
│   ├── init.sql                # Creación de tablas, triggers y datos iniciales
│   └── seed_data.sql           # Script de datos de prueba (ejecutar en pgAdmin)
│
├── backend/
│   ├── Dockerfile              # Imagen de FastAPI
│   ├── requirements.txt        # Dependencias de Python
│   ├── database.py             # Conexión a PostgreSQL con SQLAlchemy
│   ├── models.py               # Definición de tablas como clases Python
│   ├── schemas.py              # Validación de datos con Pydantic
│   └── main.py                 # Endpoints de la API (rutas CRUD)
│
└── frontend/
    ├── index.html              # Página principal con navegación
    ├── categorias.html         # CRUD de categorías
    ├── proveedores.html        # CRUD de proveedores
    ├── productos.html          # CRUD de productos
    ├── movimientos.html        # Registro de movimientos de stock
    ├── historial.html          # Historial de cambios (audit log)
    └── app.js                  # Toda la lógica fetch del frontend
```

---

## Esquema de la Base de Datos

### Diagrama de relaciones

```
categorias          proveedores
    │id (PK)            │id (PK)
    │nombre             │nombre
                        │correo
         └──────┬───────┘
                │
            productos
                │id (PK)
                │nombre
                │descripcion
                │precio
                │categoria_id (FK → categorias)
                │proveedor_id (FK → proveedores)
                │
                ▼
        movimientos_stock
                id (PK)
                producto_id (FK → productos)
                cantidad
                tipo (ENTRADA | SALIDA)
                fecha
                notas

-- Tabla generada automáticamente por triggers --
        historial
                id (PK)
                tabla
                operacion (INSERT | UPDATE | DELETE)
                registro_id
                descripcion
                fecha
```

### Normalización

La base de datos cumple con la **Tercera Forma Normal (3NF)**:

- **1NF:** Todos los campos contienen valores atómicos, sin grupos repetitivos.
- **2NF:** Todos los atributos dependen completamente de la llave primaria de su tabla.
- **3NF:** No existen dependencias transitivas — los datos de categorías y proveedores viven en sus propias tablas y se referencian mediante llaves foráneas.

### Triggers

Se definió una función `registrar_historial()` en PL/pgSQL que se ejecuta automáticamente después de cualquier `INSERT`, `UPDATE` o `DELETE` en las tablas principales. Un trigger separado enlaza esta función a cada tabla:

```
trigger_historial_categorias   → tabla categorias
trigger_historial_proveedores  → tabla proveedores
trigger_historial_productos    → tabla productos
trigger_historial_movimientos  → tabla movimientos_stock
```

---

## Endpoints de la API

### Categorías
| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/categorias` | Obtener todas las categorías |
| POST | `/categorias` | Crear una categoría |
| PUT | `/categorias/{id}` | Editar una categoría |
| DELETE | `/categorias/{id}` | Eliminar una categoría |

### Proveedores
| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/proveedores` | Obtener todos los proveedores |
| POST | `/proveedores` | Crear un proveedor |
| PUT | `/proveedores/{id}` | Editar un proveedor |
| DELETE | `/proveedores/{id}` | Eliminar un proveedor |

### Productos
| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/productos` | Obtener todos los productos |
| GET | `/productos/{id}` | Obtener un producto por ID |
| POST | `/productos` | Crear un producto |
| PUT | `/productos/{id}` | Editar un producto |
| DELETE | `/productos/{id}` | Eliminar un producto |

### Movimientos de Stock
| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/movimientos` | Obtener todos los movimientos |
| POST | `/movimientos` | Registrar un movimiento |
| DELETE | `/movimientos/{id}` | Eliminar un movimiento |

### Historial
| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/historial` | Obtener todo el historial de cambios |

---

## Cómo Probar la API

### Opción 1 — Swagger UI (recomendado)

FastAPI genera automáticamente una interfaz interactiva en:

```
http://localhost:8000/docs
```

Desde ahí puedes:
1. Ver todos los endpoints disponibles
2. Expandir cualquier endpoint
3. Hacer clic en **"Try it out"**
4. Llenar los campos y hacer clic en **"Execute"**
5. Ver la respuesta en tiempo real

### Opción 2 — curl desde la terminal

```bash
# Obtener todas las categorías
curl http://localhost:8000/categorias

# Crear una categoría
curl -X POST http://localhost:8000/categorias \
  -H "Content-Type: application/json" \
  -d '{"nombre": "Nueva Categoría"}'

# Editar una categoría
curl -X PUT http://localhost:8000/categorias/1 \
  -H "Content-Type: application/json" \
  -d '{"nombre": "Categoría Editada"}'

# Eliminar una categoría
curl -X DELETE http://localhost:8000/categorias/1

# Crear un producto
curl -X POST http://localhost:8000/productos \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Producto Prueba",
    "descripcion": "Descripción de prueba",
    "precio": 999.99,
    "categoria_id": 1,
    "proveedor_id": 1
  }'

# Ver historial de cambios
curl http://localhost:8000/historial
```

### Opción 3 — pgAdmin

Conectarse directamente a la base de datos para verificar los datos:

```
Host:     localhost
Puerto:   5432
Usuario:  admin
Password: password123
Base de datos: inventario_db
```

Consultas útiles para verificar:

```sql
-- Ver todos los productos con su categoría y proveedor
SELECT p.nombre, p.precio, c.nombre AS categoria, pr.nombre AS proveedor
FROM productos p
LEFT JOIN categorias c  ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id;

-- Ver el historial de cambios más recientes
SELECT * FROM historial ORDER BY fecha DESC LIMIT 20;

-- Contar movimientos por tipo
SELECT tipo, COUNT(*) AS total FROM movimientos_stock GROUP BY tipo;
```

---

## Capturas de Pantalla

### Página Principal
<!-- Pegar captura de index.html -->

### Módulo de Categorías
<!-- Pegar captura de categorias.html -->

### Módulo de Proveedores
<!-- Pegar captura de proveedores.html -->

### Módulo de Productos
<!-- Pegar captura de productos.html -->

### Módulo de Movimientos de Stock
<!-- Pegar captura de movimientos.html -->

### Historial de Cambios
<!-- Pegar captura de historial.html -->

### Documentación Swagger
<!-- Pegar captura de localhost:8000/docs -->

### pgAdmin — Diagrama de Tablas
<!-- Pegar captura del ERD en pgAdmin -->

---

## Autores

| Nombre | Rol |
|---|---|
| [Tu Nombre] | Desarrollo Full-Stack |
| [Nombre Compañero] | Desarrollo Full-Stack |

Proyecto desarrollado para la materia de **Bases de Datos**  
[Nombre de la Universidad] — [Semestre] [Año]
