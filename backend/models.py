from sqlalchemy import Column, Integer, String, Numeric, Text, TIMESTAMP, ForeignKey, func
from sqlalchemy.orm import relationship
from database import Base

class Categoria(Base):
    __tablename__ = "categorias"

    id     = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False, unique=True)

    productos = relationship("Producto", back_populates="categoria")


class Proveedor(Base):
    __tablename__ = "proveedores"

    id        = Column(Integer, primary_key=True, index=True)
    nombre    = Column(String(100), nullable=False)
    correo    = Column(String(100))
    telefono  = Column(String(20))
    direccion = Column(String(200))

    productos = relationship("Producto", back_populates="proveedor")


class Producto(Base):
    __tablename__ = "productos"

    id           = Column(Integer, primary_key=True, index=True)
    nombre       = Column(String(100), nullable=False)
    descripcion  = Column(Text)
    precio       = Column(Numeric(10, 2), nullable=False)
    categoria_id = Column(Integer, ForeignKey("categorias.id"), nullable=True)
    proveedor_id = Column(Integer, ForeignKey("proveedores.id"), nullable=True)

    categoria = relationship("Categoria", back_populates="productos")
    proveedor = relationship("Proveedor", back_populates="productos")


class MovimientoStock(Base):
    __tablename__ = "movimientos_stock"

    id          = Column(Integer, primary_key=True, index=True)
    producto_id = Column(Integer, ForeignKey("productos.id"), nullable=False)
    cantidad    = Column(Integer, nullable=False)
    tipo        = Column(String(10), nullable=False)
    fecha       = Column(TIMESTAMP, server_default=func.now())
    notas       = Column(Text)

    producto = relationship("Producto")