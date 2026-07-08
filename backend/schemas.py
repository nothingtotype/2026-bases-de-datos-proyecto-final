from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# --- Categorias ---

class CategoriaCreate(BaseModel):
    nombre: str

class CategoriaOut(BaseModel):
    id: int
    nombre: str

    class Config:
        from_attributes = True


# --- Proveedores ---

class ProveedorCreate(BaseModel):
    nombre: str
    correo:   Optional[str] = None
    telefono: Optional[str] = None
    direccion: Optional[str] = None

class ProveedorOut(BaseModel):
    id:       int
    nombre:   str
    correo:   Optional[str]
    telefono: Optional[str]
    direccion: Optional[str]

    class Config:
        from_attributes = True


# --- Productos ---

class ProductoCreate(BaseModel):
    nombre:       str
    descripcion:  Optional[str] = None
    precio:       float
    categoria_id: Optional[int] = None
    proveedor_id: Optional[int] = None

class ProductoOut(BaseModel):
    id:              int
    nombre:          str
    descripcion:     Optional[str]
    precio:          float
    categoria_id:    Optional[int]
    proveedor_id:    Optional[int]
    categoria_nombre: Optional[str] = None   # ← new
    proveedor_nombre: Optional[str] = None   # ← new

    class Config:
        from_attributes = True

# --- Movimientos Stock ---

class MovimientoCreate(BaseModel):
    producto_id: int
    cantidad:    int
    tipo:        str   # 'ENTRADA' or 'SALIDA'
    notas:       Optional[str] = None

class MovimientoOut(BaseModel):
    id:          int
    producto_id: int
    cantidad:    int
    tipo:        str
    fecha:       datetime
    notas:       Optional[str]

    class Config:
        from_attributes = True

# --- Historial ---

class HistorialOut(BaseModel):
    id:          int
    tabla:       str
    operacion:   str
    registro_id: Optional[int]
    descripcion: Optional[str]
    fecha:       datetime

    class Config:
        from_attributes = True