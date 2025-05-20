from faker import Faker
from sqlalchemy import create_engine
from sqlalchemy.orm import Session
import random
import datetime

from app.models import Base, TipoDispositivo, Dispositivo, Sensor, LogEstadoDispositivo

# Crear Faker y Engine
fake = Faker()
engine = create_engine("postgresql+psycopg2:///iot_devices")

# Crear tablas si no existen
Base.metadata.create_all(bind=engine)

# Ejecutar simulación
with Session(engine) as session:
    # 1. TipoDispositivo
    tipo = TipoDispositivo(
        fabricante=fake.company(),
        modelo=fake.bothify("Modelo-###"),
        descripcion=fake.sentence()
    )
    session.add(tipo)
    session.commit()
    print(f"✓ TipoDispositivo creado: {tipo.modelo} (ID: {tipo.id})")

    # 2. Dispositivo
    dispositivo = Dispositivo(
        numero_serie=fake.uuid4(),
        mac_address=fake.mac_address(),
        version_firmware="1.0.0",
        ubicacion=fake.address(),
        tipo_dispositivo_id=tipo.id
    )
    session.add(dispositivo)
    session.commit()
    print(f"✓ Dispositivo creado: {dispositivo.numero_serie} (ID: {dispositivo.id})")

    # 3. Sensores
    for _ in range(3):
        sensor = Sensor(
            tipo_sensor=random.choice(["temperatura", "humedad", "presión"]),
            unidad_medida=random.choice(["°C", "%", "hPa"]),
            dispositivo_id=dispositivo.id
        )
        session.add(sensor)
    session.commit()
    print("✓ Sensores creados")

    # 4. Logs de estado sin repetición consecutiva
    estados = ["apagado", "encendiendo", "buscando_actualizaciones", "funcionando", "error_detectado", "funcionando"]
    estado_anterior = None
    for estado in estados:
        if estado != estado_anterior:
            log = LogEstadoDispositivo(
                estado=estado,
                mensaje_opcional=fake.sentence(),
                dispositivo_id=dispositivo.id,
                timestamp=datetime.datetime.now()
            )
            session.add(log)
            estado_anterior = estado
    session.commit()
    print("✓ Logs de estado creados sin repetir estados consecutivos")

print("🎉 ¡Base de datos poblada exitosamente!")
