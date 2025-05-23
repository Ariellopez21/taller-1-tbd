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

    # Relación uno-a-muchos con Dispositivo:
    dispositivos: Mapped[list["Dispositivo"]] = relationship(back_populates="tipo_dispositivo")
class GrupoDispositivos(Base):
    __tablename__ = "grupos_dispositivos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    nombre: Mapped[str] = mapped_column(String(50), unique=True)
    descripcion: Mapped[Optional[str]] = mapped_column(String(200))

    # Relación muchos-a-muchos con Dispositivo:
    dispositivos: Mapped[list["Dispositivo"]] = relationship(
        secondary="dispositivos_agrupados", back_populates="grupos_dispositivos")

class Dispositivo(Base):
    __tablename__ = "dispositivos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    numero_serie: Mapped[str] = mapped_column(String(50), unique=True)
    mac_address: Mapped[Optional[str]] = mapped_column(String(50), unique=True)
    version_firmware: Mapped[str] = mapped_column(String(50))
    ubicacion: Mapped[str] = mapped_column(String(200))
    fecha_registro: Mapped[datetime.datetime] = mapped_column(default=datetime.datetime.now)

    # Relación muchos-a-uno con TipoDispositivo:
    tipo_dispositivo_id: Mapped[int] = mapped_column(ForeignKey("tipos_dispositivos.id"))
    tipo_dispositivo: Mapped["TipoDispositivo"] = relationship(back_populates="dispositivos")
    
    # Relación uno-a-muchos con Sensor:
    sensores: Mapped[list["Sensor"]] = relationship(back_populates="dispositivo")
    
    # Relación uno-a-muchos con LogEstadoDispositivo:
    logs_estado_dispositivo: Mapped[list["LogEstadoDispositivo"]] = relationship(back_populates="dispositivo")
    
    # Relación muchos-a-muchos con GrupoDispositivos:
    grupos_dispositivos: Mapped[list["GrupoDispositivos"]] = relationship(
        secondary="dispositivos_agrupados", back_populates="dispositivos")

class Sensor(Base):
    __tablename__ = "sensores"

    id: Mapped[int] = mapped_column(primary_key=True) 
    tipo_sensor: Mapped[str] = mapped_column(String(50))
    unidad_medida: Mapped[str] = mapped_column(String(20))

    # Relación muchos-a-uno con Dispositivo:
    dispositivo_id: Mapped[int] = mapped_column(ForeignKey("dispositivos.id"))
    dispositivo: Mapped["Dispositivo"] = relationship(back_populates="sensores")    

    # Relación uno-a-muchos con LecturaDato:
    lecturas_datos: Mapped[list["LecturaDato"]] = relationship(back_populates="sensor")

class LecturaDato(Base):
    __tablename__ = "lecturas_datos"

    id: Mapped[int] = mapped_column(primary_key=True) 
    timestamp: Mapped[datetime.datetime] = mapped_column(default=lambda: datetime.datetime.now(datetime.timezone.utc))
    valor_leido: Mapped[str] = mapped_column(String(50))
    
    # Relación muchos-a-uno con Sensor:
    sensor_id: Mapped[int] = mapped_column(ForeignKey("sensores.id"))
    sensor: Mapped["Sensor"] = relationship(back_populates="lecturas_datos")

class LogEstadoDispositivo(Base):
    __tablename__ = "logs_estado_dispositivo"

    id: Mapped[int] = mapped_column(primary_key=True) 
    timestamp: Mapped[datetime.datetime] = mapped_column(default=datetime.datetime.now)
    estado: Mapped[str] = mapped_column(String(20))
    mensaje_opcional: Mapped[Optional[str]] = mapped_column(String(200))
    
    # Relación muchos-a-uno con Dispositivo:
    dispositivo_id: Mapped[int] = mapped_column(ForeignKey("dispositivos.id"))
    dispositivo: Mapped["Dispositivo"] = relationship(back_populates="logs_estado_dispositivo")

# Relacion Muchos a Muchos entre Dispositivo y GrupoDispositivos
class DispositivosAgrupados(Base):
    __tablename__ = "dispositivos_agrupados"

    dispositivo_id: Mapped[int] = mapped_column(ForeignKey("dispositivos.id"), primary_key=True)
    grupo_dispositivo_id: Mapped[int] = mapped_column(ForeignKey("grupos_dispositivos.id"), primary_key=True)
    
    # Relación muchos-a-uno con Dispositivo:
    #dispositivo: Mapped["Dispositivo"] = relationship(back_populates="grupos_dispositivos")
    # Relación muchos-a-uno con GrupoDispositivos:
    #grupo_dispositivo: Mapped["GrupoDispositivos"] = relationship(back_populates="dispositivos")
    