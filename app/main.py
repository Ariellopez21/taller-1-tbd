import random
from faker import Faker
from sqlalchemy import select
from colorama import Fore, Style, init

from app.database import create_database, Session
from app import crud
from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo, Sensor

def simulacion():

    # 1. TipoDispositivo
    with Session() as session:
        for _ in range(25):
            crud.crear_tipodispositivo(
                session=session,
                fabricante=f"{fake.company()} {fake.company_suffix()}",
                modelo=f"{fake.word().capitalize()}-{fake.random_int(min=100, max=999)}{fake.random_letter().upper()}",
                descripcion=f"{fake.sentence()} {fake.paragraph(nb_sentences=2)}")
    
    # 2. GrupoDispositivos
    with Session() as session:
        for _ in range(10):
            crud.crear_grupodispositivos(
                session=session,
                nombre=f"{fake.color_name()}-{fake.random_int(min=1, max=100)}",
                descripcion=f"{fake.sentence()} {fake.paragraph(nb_sentences=1)}")
    
    # 3. Dispositivo
    tipo_dispositivo_id_inDB = session.execute(select(TipoDispositivo.id)).scalars().all()
    with Session() as session:
        for _ in range(80):
            crud.crear_dispositivo(
                session=session,
                numero_serie=fake.uuid4(),
                mac_address=fake.mac_address(),
                version_firmware=f"{fake.random_int(min=1, max=5)}.{fake.random_int(min=0, max=9)}.{fake.random_int(min=0, max=20)}",
                descripcion_ubicacion=fake.address().replace("\n", ", "),
                fecha_registro=fake.date_time_this_year(),
                tipo_dispositivo_id=random.choice(tipo_dispositivo_id_inDB)
            )

    # 4. DispositivosAgrupados
    dispositivo_id_inDB = session.execute(select(Dispositivo.id)).scalars().all()
    grupo_dispositivos_id_inDB = session.execute(select(GrupoDispositivos.id)).scalars().all()
    
    with Session() as session:
        for _ in range(110):
            crud.asociar_dispositivo_grupodispositivo(
                session=session,
                dispositivo_id=random.choice(dispositivo_id_inDB),
                grupo_dispositivo_id=random.choice(grupo_dispositivos_id_inDB)
            )   

    # 5. Sensor

    generic_sensors = ["ESP32","ESP32-CAM","ESP32-WROOM","ESP8266","NodeMCU","BME280","DHT11","DHT22","BMP180","BMP280","MQ-2","MQ-135","HC-SR04","PIR Motion Sensor","LDR","DS18B20","GY-521 (MPU6050)","HX711","MAX30100","RC522","TCS34725","VL53L0X","INA219","LM35","ACS712"]
    units_measurement = ["°C", "%", "Pa", "m/s", "g", "°K", "°F", "PSI", "mmHg", "Primes", "kPa", "mA", "V", "Ω", "Hz", "Lux", "dB", "ppm", "g/m³", "mol/m²/s", "J/s", "N/m²"]
    with Session() as session:
        for _ in range(120):
            crud.crear_sensor(
                session=session,
                tipo=random.choice(generic_sensors),
                unidad_medida=random.choice(units_measurement),
                dispositivo_id=random.choice(dispositivo_id_inDB)
            )    

    # 6. LecturaDato
    sensor_id_inDB = session.execute(select(Sensor.id)).scalars().all()

    with Session() as session:
        for _ in range(300):
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
        for _ in range(300):
            crud.crear_log_estado_dispositivo(
                session=session,
                dispositivo_id=random.choice(dispositivo_id_inDB),
                estado=random.choice(log_states),
                mensaje=fake.sentence(),
            )  

def interfaz_consola():
    init(autoreset=True)
    print(Fore.CYAN + Style.BRIGHT + "=" * 50)
    print(Fore.GREEN + Style.BRIGHT + "     BIENVENIDO A LA SIMULACIÓN DE DISPOSITIVOS IoT")
    print(Fore.CYAN + Style.BRIGHT + "=" * 50)

    while True:

        print()
        print(Fore.YELLOW + Style.BRIGHT + "Menú Principal:")
        print(Fore.BLUE + "1." + Style.RESET_ALL + " Ver todos los Tipos de Dispositivo")
        print(Fore.BLUE + "2." + Style.RESET_ALL + " Ver todos los Grupos de Dispositivos")
        print(Fore.BLUE + "3." + Style.RESET_ALL + " Ver todos los Dispositivos")
        print(Fore.BLUE + "4." + Style.RESET_ALL + " Ver Dispositivo por Tipo de Dispositivo")
        print(Fore.BLUE + "5." + Style.RESET_ALL + " Ver Dispositivo por Grupo de Dispositivos")
        print(Fore.BLUE + "6." + Style.RESET_ALL + " Ver Grupos de Dispositivos por un Dispositivo")
        print(Fore.BLUE + "7." + Style.RESET_ALL + " Ver Sensores por un Dispositivo")
        print(Fore.BLUE + "8." + Style.RESET_ALL + " Ver Lecturas por un Sensor")
        print(Fore.BLUE + "9." + Style.RESET_ALL + " Ver Logs de Estado por un Dispositivo")
        print(Fore.BLUE + "10." + Style.RESET_ALL + " Asociar Dispositivo a Grupo de Dispositivos")
        print(Fore.BLUE + "11." + Style.RESET_ALL + " Desasociar Dispositivo de Grupo de Dispositivos")
        print(Fore.RED + Style.BRIGHT + "0.  Salir")

        print()
        opcion = input(Fore.CYAN + "Selecciona una opción: ").strip()
        
        with Session() as session:
            match opcion:
                case "1":
                    crud.get_tipos_dispositivo(session)
                case "2":
                    crud.get_grupos_dispositivos(session)
                case "3":
                    crud.get_dispositivos(session)
                case "4":
                    tipo_dispositivo_id = int(input("Selecciona un ID de Tipo de Dispositivo: "))
                    crud.get_dispositivos_by_tipo(session=session, tipo_dispositivo_id=tipo_dispositivo_id)
                case "5":
                    grupo_dispositivo_id = int(input("Selecciona un ID de Grupo de Dispositivos: "))
                    crud.get_dispositivos_by_grupo(session=session, grupo_dispositivo_id=grupo_dispositivo_id)
                case "6":
                    dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                    crud.get_grupos_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
                case "7":
                    dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                    crud.get_sensores_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
                case "8":
                    sensor_id = int(input("Selecciona un ID de Sensor: "))
                    nro = int(input("Selecciona el número de lecturas a mostrar: "))
                    crud.get_lectura_datos_by_sensor(session=session, sensor_id=sensor_id, n=nro)
                case "9":
                    dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                    crud.get_logs_by_dispositivo(session=session, dispositivo_id=dispositivo_id)
                case "10":
                    dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                    grupo_dispositivo_id = int(input("Selecciona un ID de Grupo de Dispositivos: "))
                    crud.asociar_dispositivo_grupodispositivo(session=session, dispositivo_id=dispositivo_id, grupo_dispositivo_id=grupo_dispositivo_id)
                case "11":
                    dispositivo_id = int(input("Selecciona un ID de Dispositivo: "))
                    grupo_dispositivo_id = int(input("Selecciona un ID de Grupo de Dispositivos: "))
                    crud.desasociar_dispositivo_grupodispositivo(session=session, dispositivo_id=dispositivo_id, grupo_dispositivo_id=grupo_dispositivo_id)
                case "0":
                    print(Fore.MAGENTA + Style.BRIGHT + "Fin del programa.")
                    break
                case _:
                    print(Fore.RED + Style.BRIGHT + "Opción no válida. Intenta de nuevo.")

if __name__ == "__main__":
    create_database()
    fake = Faker()
    simulacion()
    interfaz_consola()