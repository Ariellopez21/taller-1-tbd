import datetime
from typing import Optional
from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship

class Base(DeclarativeBase):
    pass

# Representa un tipo o modelo de dispositivo (ej. 'Raspberry Pi 4', 'ESP32 Temp Sensor v2').
class TipoDispositivo(Base):
    __tablename__ = "tipos_dispositivos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    fabricante: Mapped[str] = mapped_column(String(50))
    modelo: Mapped[str] = mapped_column(String(50), unique=True)
    descripcion: Mapped[Optional[str]] = mapped_column(String(200))
    
    #user_id: Mapped[Optional[int]] = mapped_column(ForeignKey("users.id"))
    
    #user: Mapped[Optional["User"]] = relationship(back_populates="items")

class GrupoDispositivos(Base):
    __tablename__ = "grupos_dispositivos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    nombre: Mapped[str] = mapped_column(String(50), unique=True)
    descripcion: Mapped[Optional[str]] = mapped_column(String(200))
    
class Dispositivo(Base):
    __tablename__ = "dispositivos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    numero_serie: Mapped[str] = mapped_column(String(50), unique=True)
    mac_address: Mapped[Optional[str]] = mapped_column(String(50), unique=True)
    version_firmware: Mapped[str] = mapped_column(String(50))
    ubicacion: Mapped[str] = mapped_column(String(200))
    fecha_registro: Mapped[datetime.datetime] = mapped_column(default=datetime.datetime.now)
    
class Sensor(Base):
    __tablename__ = "sensores"

    id: Mapped[int] = mapped_column(primary_key=True) 
    tipo_sensor: Mapped[str] = mapped_column(String(50))
    unidad_medida: Mapped[str] = mapped_column(String(20))

class LecturaDato(Base):
    __tablename__ = "lecturas_datos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    timestamp: Mapped[datetime.datetime] = mapped_column(default=lambda: datetime.datetime.now(datetime.timezone.utc))
    valor_leido: Mapped[str] = mapped_column(String(50))
    
class LogEstadoDispositivo(Base):
    __tablename__ = "logs_estado_dispositivo"

    id: Mapped[int] = mapped_column(primary_key=True) 
    timestamp: Mapped[datetime.datetime] = mapped_column(default=datetime.datetime.now)
    estado: Mapped[str] = mapped_column(String(20))
    mensaje_opcional: Mapped[Optional[str]] = mapped_column(String(200))
    