from faker import Faker
import random
import datetime

from app.database import create_database, Session
from app import crud
from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo, Sensor
from sqlalchemy import select


def simulacion():

    # 1. TipoDispositivo
    with Session() as session:
        for _ in range(5):
            crud.crear_tipodispositivo(
                session=session,
                fabricante=f"{fake.company()} {fake.company_suffix()}",
                modelo=f"{fake.word().capitalize()}-{fake.random_int(min=100, max=999)}{fake.random_letter().upper()}",
                descripcion=f"{fake.sentence()} {fake.paragraph(nb_sentences=2)}")
    
    # 2. GrupoDispositivos
    with Session() as session:
        for _ in range(5):
            crud.crear_grupodispositivos(
                session=session,
                nombre=f"{fake.color_name()}-{fake.random_int(min=1, max=100)}",
                descripcion=f"{fake.sentence()} {fake.paragraph(nb_sentences=1)}")
    
    # 3. Dispositivo
    tipo_dispositivo_id_inDB = session.execute(select(TipoDispositivo.id)).scalars().all()
    with Session() as session:
        for _ in range(5):
            crud.crear_dispositivo(
                session=session,
                numero_serie=fake.uuid4(),
                mac_address=fake.mac_address(),
                version_firmware=f"{fake.random_int(min=1, max=5)}.{fake.random_int(min=0, max=9)}.{fake.random_int(min=0, max=20)}",
                ubicacion=fake.address().replace("\n", ", "),
                fecha_registro=fake.date_time_this_year(),
                tipo_dispositivo_id=random.choice(tipo_dispositivo_id_inDB)
            )

    # 4. DispositivosAgrupados
    dispositivo_id_inDB = session.execute(select(Dispositivo.id)).scalars().all()
    grupo_dispositivos_id_inDB = session.execute(select(GrupoDispositivos.id)).scalars().all()
    
    with Session() as session:
        for _ in range(5):
            crud.asociar_dispositivo_grupodispositivo(
                session=session,
                dispositivo_id=random.choice(dispositivo_id_inDB),
                grupo_dispositivo_id=random.choice(grupo_dispositivos_id_inDB)
            )   

    # Desasociar
    '''
    with Session() as session:
        crud.desasociar_dispositivo_grupodispositivo(
            session=session,
            dispositivo_id=1,
            grupo_dispositivo_id=2
        )
    '''

    # 5. Sensor

    generic_sensors = ["ESP32","ESP32-CAM","ESP32-WROOM","ESP8266","NodeMCU","BME280","DHT11","DHT22","BMP180","BMP280","MQ-2","MQ-135","HC-SR04","PIR Motion Sensor","LDR","DS18B20","GY-521 (MPU6050)","HX711","MAX30100","RC522","TCS34725","VL53L0X","INA219","LM35","ACS712"]
    units_measurement = ["°C", "%", "Pa", "m/s", "g", "°K", "°F", "PSI", "mmHg", "Primes", "kPa", "mA", "V", "Ω", "Hz", "Lux", "dB", "ppm", "g/m³", "mol/m²/s", "J/s", "N/m²"]
    with Session() as session:
        for _ in range(5):
            crud.crear_sensor(
                session=session,
                tipo=random.choice(generic_sensors),
                unidad_medida=random.choice(units_measurement),
                dispositivo_id=random.choice(dispositivo_id_inDB)
            )    

    # 6. LecturaDato
    sensor_id_inDB = session.execute(select(Sensor.id)).scalars().all()

    with Session() as session:
        for _ in range(20):
            crud.crear_lectura_dato(
                session=session,
                valor_leido=str(round(random.uniform(10.0, 100.0), 2)),
                sensor_id=random.choice(sensor_id_inDB)
            )   

    # 7. LogEstadoDispositivo
    log_states = [
        "activo", "inactivo", "en mantenimiento", "error", "reiniciado",
        "firmware update", "sin conexión", "bajo batería", "apagado", "en espera"
    ]

    with Session() as session:
        for _ in range(10):
            crud.crear_log_estado_dispositivo(
                session=session,
                dispositivo_id=random.choice(dispositivo_id_inDB),
                estado=random.choice(log_states),
                mensaje=fake.sentence(),
            )

def interfaz_consola():
    print("=====================================")
    print("BIENVENIDO A LA SIMULACIÓN DE DISPOSITIVOS IoT")
    print("Esta simulación asume que el usuario sabe lo que está haciendo.")
    print("Por lo que solo se deben realizar consultas a IDs existentes en la base de datos.")
    print("=====================================")
    while True:
        print("\nMENÚ PRINCIPAL - CONSULTAS")
        print("1. Ver todos los Tipos de Dispositivo")
        print("2. Ver todos los Grupos de Dispositivos")
        print("3. Ver todos los Dispositivos")
        print("4. Ver Dispositivo por Tipo de Dispositivo")
        print("5. Ver Dispositivo por Grupo de Dispositivos")
        print("6. Ver Grupos de Dispositivos por un Dispositivo")
        print("7. Ver Sensores por un Dispositivo")
        print("8. Ver Lecturas por un Sensor")
        print("9. Ver Logs de Estado por un Dispositivo")
        print("0. Salir")

        opcion = input("Selecciona una opción: ").strip()
        
        with Session() as session:
            if opcion == "1":
                crud.get_tipos_dispositivo(session)
            elif opcion == "2":
                crud.get_grupos_dispositivos(session)
            elif opcion == "3":
                crud.get_dispositivos(session)
            elif opcion == "4":
                tipo_dispositivo_id = int(input("Selecciona un ID de Tipo de Dispositivo: "))
                crud.get_dispositivos_by_tipo(session=session, tipo_dispositivo_id=tipo_dispositivo_id)
            elif opcion == "5":
                grupo_dispositivo_id = int(input("Selecciona un ID de Grupo de Dispositivos: "))
                crud.get_dispositivos_by_grupo(session=session, grupo_dispositivo_id=grupo_dispositivo_id)
            elif opcion == "6":
                dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                crud.get_grupos_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
            elif opcion == "7":
                dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                crud.get_sensores_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
            elif opcion == "8":
                sensor_id = int(input("Selecciona un ID de Sensor: "))
                nro = int(input("Selecciona el número de lecturas a mostrar: "))
                crud.get_lectura_datos_by_sensor(session=session, sensor_id=sensor_id, n=nro)
            elif opcion == "9":
                dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                crud.get_logs_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
            elif opcion == "0":
                print("Fin del programa.")
                break
            else:
                print("Opción no válida. Intenta de nuevo.")
    


if __name__ == "__main__":
    create_database()
    fake = Faker()
    simulacion()
    interfaz_consola()