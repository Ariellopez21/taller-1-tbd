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