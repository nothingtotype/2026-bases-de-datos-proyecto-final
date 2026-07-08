from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import get_db
from models import Categoria, Proveedor, Producto, MovimientoStock
from schemas import (
    CategoriaCreate, CategoriaOut,
    ProveedorCreate, ProveedorOut,
    ProductoCreate, ProductoOut,
    MovimientoCreate, MovimientoOut
)

app = FastAPI()

# Allows your HTML frontend to call the API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ───────────────────────────────
# CATEGORIAS
# ───────────────────────────────

@app.get("/categorias", response_model=list[CategoriaOut])
def get_categorias(db: Session = Depends(get_db)):
    return db.query(Categoria).all()

@app.post("/categorias", response_model=CategoriaOut)
def create_categoria(data: CategoriaCreate, db: Session = Depends(get_db)):
    nueva = Categoria(nombre=data.nombre)
    db.add(nueva)
    db.commit()
    db.refresh(nueva)
    return nueva

@app.put("/categorias/{id}", response_model=CategoriaOut)
def update_categoria(id: int, data: CategoriaCreate, db: Session = Depends(get_db)):
    categoria = db.query(Categoria).filter(Categoria.id == id).first()
    if not categoria:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    categoria.nombre = data.nombre
    db.commit()
    db.refresh(categoria)
    return categoria

@app.delete("/categorias/{id}")
def delete_categoria(id: int, db: Session = Depends(get_db)):
    categoria = db.query(Categoria).filter(Categoria.id == id).first()
    if not categoria:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    db.delete(categoria)
    db.commit()
    return { "mensaje": "Categoría eliminada" }


# ───────────────────────────────
# PROVEEDORES
# ───────────────────────────────

@app.get("/proveedores", response_model=list[ProveedorOut])
def get_proveedores(db: Session = Depends(get_db)):
    return db.query(Proveedor).all()

@app.post("/proveedores", response_model=ProveedorOut)
def create_proveedor(data: ProveedorCreate, db: Session = Depends(get_db)):
    nuevo = Proveedor(**data.model_dump())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@app.put("/proveedores/{id}", response_model=ProveedorOut)
def update_proveedor(id: int, data: ProveedorCreate, db: Session = Depends(get_db)):
    proveedor = db.query(Proveedor).filter(Proveedor.id == id).first()
    if not proveedor:
        raise HTTPException(status_code=404, detail="Proveedor no encontrado")
    for key, value in data.model_dump().items():
        setattr(proveedor, key, value)
    db.commit()
    db.refresh(proveedor)
    return proveedor

@app.delete("/proveedores/{id}")
def delete_proveedor(id: int, db: Session = Depends(get_db)):
    proveedor = db.query(Proveedor).filter(Proveedor.id == id).first()
    if not proveedor:
        raise HTTPException(status_code=404, detail="Proveedor no encontrado")
    db.delete(proveedor)
    db.commit()
    return { "mensaje": "Proveedor eliminado" }


# ───────────────────────────────
# PRODUCTOS
# ───────────────────────────────

@app.get("/productos", response_model=list[ProductoOut])
def get_productos(db: Session = Depends(get_db)):
    return db.query(Producto).all()

@app.get("/productos/{id}", response_model=ProductoOut)
def get_producto(id: int, db: Session = Depends(get_db)):
    producto = db.query(Producto).filter(Producto.id == id).first()
    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    return producto

@app.post("/productos", response_model=ProductoOut)
def create_producto(data: ProductoCreate, db: Session = Depends(get_db)):
    nuevo = Producto(**data.model_dump())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@app.put("/productos/{id}", response_model=ProductoOut)
def update_producto(id: int, data: ProductoCreate, db: Session = Depends(get_db)):
    producto = db.query(Producto).filter(Producto.id == id).first()
    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    for key, value in data.model_dump().items():
        setattr(producto, key, value)
    db.commit()
    db.refresh(producto)
    return producto

@app.delete("/productos/{id}")
def delete_producto(id: int, db: Session = Depends(get_db)):
    producto = db.query(Producto).filter(Producto.id == id).first()
    if not producto:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    db.delete(producto)
    db.commit()
    return { "mensaje": "Producto eliminado" }


# ───────────────────────────────
# MOVIMIENTOS STOCK
# ───────────────────────────────

@app.get("/movimientos", response_model=list[MovimientoOut])
def get_movimientos(db: Session = Depends(get_db)):
    return db.query(MovimientoStock).all()

@app.post("/movimientos", response_model=MovimientoOut)
def create_movimiento(data: MovimientoCreate, db: Session = Depends(get_db)):
    if data.tipo not in ("ENTRADA", "SALIDA"):
        raise HTTPException(status_code=400, detail="Tipo debe ser ENTRADA o SALIDA")
    nuevo = MovimientoStock(**data.model_dump())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@app.delete("/movimientos/{id}")
def delete_movimiento(id: int, db: Session = Depends(get_db)):
    movimiento = db.query(MovimientoStock).filter(MovimientoStock.id == id).first()
    if not movimiento:
        raise HTTPException(status_code=404, detail="Movimiento no encontrado")
    db.delete(movimiento)
    db.commit()
    return { "mensaje": "Movimiento eliminado" }