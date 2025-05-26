from sqlalchemy.orm import Session
from sqlalchemy import select, desc, and_, or_
from sqlalchemy.exc import IntegrityError

import datetime

from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo, DispositivosAgrupados, Sensor, LecturaDato, LogEstadoDispositivo

'''
Bases:
GET: Para obtener resultados
POST: Para enviar resultados
PUT: Para actualizar
PATCH: Para actualizar parcialmente
DELETE: Para eliminar
DATA: Siempre incluir este parametro en las funciones para que se pueda utilizar el json del Litestar
DataTransferObjects (DTOs): Son clases que se utilizan para definir la estructura de los datos que se envían y reciben en las peticiones HTTP.
En vez de utilizar un return por cada función. se puede añadir como atributo de la clase.
En la función post usamos dto para entrada de datos y en la función get usamos return_dto para salida de datos.
'''

''' FUNCIONES POST '''

# Crear TipoDispositivo
def crear_tipodispositivo(session: Session, fabricante: str, modelo: str, descripcion: str) -> None:
    with session.begin():
        try:    
            stmt = select(TipoDispositivo).where(TipoDispositivo.modelo == modelo)
            allready_exist = session.execute(stmt).scalar_one_or_none()
            if allready_exist:
                print(f"TipoDispositivo con modelo {modelo} ya existe.")
                return
            else:
                tipo_dispositivo = TipoDispositivo(fabricante=fabricante, modelo=modelo, descripcion=descripcion)
                session.add(tipo_dispositivo)
        except IntegrityError:
            session.rollback()
            print(f"Error al crear TipoDispositivo: {fabricante} {modelo}.")

# Crear GrupoDispositivos
def crear_grupodispositivos(session: Session, nombre: str, descripcion: str) -> None:
    with session.begin():
        try:
            stmt = select(GrupoDispositivos).where(GrupoDispositivos.nombre == nombre)
            allready_exist = session.execute(stmt).scalar_one_or_none()
            if allready_exist:
                print(f"GrupoDispositivos con nombre '{nombre}' ya existe.")
                return
            else:
                grupo = GrupoDispositivos(nombre=nombre, descripcion=descripcion)
                session.add(grupo)
        except IntegrityError:
            session.rollback()
            print(f"Error al crear GrupoDispositivos: {nombre}.")

# Crear Dispositivo
def crear_dispositivo(session: Session, numero_serie: str, mac_address: str, version_firmware: str, ubicacion: str, fecha_registro: datetime.datetime, tipo_dispositivo_id: int) -> None:
    with session.begin():
        try:
            stmt = select(Dispositivo).where(
                or_(
                    Dispositivo.numero_serie == numero_serie,
                    Dispositivo.mac_address == mac_address
                )
            )
            allready_exist = session.execute(stmt).scalar_one_or_none()
            if allready_exist:
                print(f"Dispositivo con número de serie o MAC ya existente: {numero_serie} / {mac_address}")
                return
            else:
                dispositivo = Dispositivo(
                    numero_serie=numero_serie,
                    mac_address=mac_address,
                    version_firmware=version_firmware,
                    ubicacion=ubicacion,
                    fecha_registro=fecha_registro,
                    tipo_dispositivo_id=tipo_dispositivo_id
                )
                session.add(dispositivo)
        except IntegrityError:
            session.rollback()
            print(f"Error al crear Dispositivo: {numero_serie}.")

# Crear DispositivosAgrupados
# Esta función asocia un dispositivo a un grupo de dispositivos.
def asociar_dispositivo_grupodispositivo(session: Session, dispositivo_id: int, grupo_dispositivo_id: int) -> None:
    with session.begin():
        try:
            stmt = select(DispositivosAgrupados).where(
                and_(
                    DispositivosAgrupados.dispositivo_id == dispositivo_id,
                    DispositivosAgrupados.grupo_dispositivo_id == grupo_dispositivo_id
                )
            )
            allready_exist = session.execute(stmt).scalar_one_or_none()
            if allready_exist:
                print(f"Asociación ya existe: Dispositivo {dispositivo_id} con Grupo {grupo_dispositivo_id}")
                return
            else:
                asociar = DispositivosAgrupados(
                    dispositivo_id=dispositivo_id,
                    grupo_dispositivo_id=grupo_dispositivo_id
                )
                session.add(asociar)
        except IntegrityError:
            session.rollback()
            print(f"Error de integridad al asociar Dispositivo {dispositivo_id} y Grupo {grupo_dispositivo_id}")

# Desasociar DispositivosAgrupados
# Esta función elimina la asociación entre un dispositivo y un grupo de dispositivos.
def desasociar_dispositivo_grupodispositivo(session: Session, dispositivo_id: int, grupo_dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(DispositivosAgrupados).where(
            and_(
                DispositivosAgrupados.dispositivo_id == dispositivo_id,
                DispositivosAgrupados.grupo_dispositivo_id == grupo_dispositivo_id
            )
        )
        asociacion = session.execute(stmt).scalar_one_or_none()
        if not asociacion:
            print(f"No existe asociación entre Dispositivo {dispositivo_id} y Grupo {grupo_dispositivo_id}")
            return

        session.delete(asociacion)

# Crear Sensor
def crear_sensor(session: Session, tipo: str, unidad_medida: str, dispositivo_id: int) -> None:
    with session.begin():
        try:
            sensor = Sensor(
                tipo_sensor=tipo,
                unidad_medida=unidad_medida,
                dispositivo_id=dispositivo_id
            )
            session.add(sensor)
        except IntegrityError:
            session.rollback()
            print(f"Error al crear sensor '{tipo}' para dispositivo {dispositivo_id}.")

# Crear LecturaDato
def crear_lectura_dato(session: Session, valor_leido: str, sensor_id: int) -> None:
    with session.begin():
        try:
            nueva_lectura = LecturaDato(
                valor_leido=valor_leido,
                sensor_id=sensor_id
            )
            session.add(nueva_lectura)
        except IntegrityError:
            session.rollback()
            print(f"Error al registrar lectura para sensor {sensor_id}")

# Crear LogEstadoDispositivo
def crear_log_estado_dispositivo(session: Session, dispositivo_id: int, estado: str, mensaje: str) -> None:
    with session.begin():
        try:
            stmt = (    
                select(LogEstadoDispositivo)
                .where(LogEstadoDispositivo.dispositivo_id == dispositivo_id)
                .order_by(desc(LogEstadoDispositivo.id))
                .limit(1)
            )
            last_log = session.execute(stmt).scalar_one_or_none()

            if last_log and last_log.estado == estado:
                return

            log = LogEstadoDispositivo(
                dispositivo_id=dispositivo_id,
                estado=estado,
                mensaje_opcional=mensaje
            )
            session.add(log)
        except IntegrityError:
            session.rollback()

''' FUNCIONES GET '''

# Obtener todos los Tipos de Dispositivo
def get_tipos_dispositivo(session: Session) -> None:
    with session.begin():
        stmt = select(TipoDispositivo)
        results = session.execute(stmt).scalars().all()

        if not results:
            print("No hay Tipos de Dispositivo registrados.")
            return

        print("Tipos de Dispositivo registrados:")
        for tipo in results:
            print(f"ID: {tipo.id} | Modelo: {tipo.modelo} | Fabricante: {tipo.fabricante} | Descripción: {tipo.descripcion}")

# Obtener todos los Grupos de Dispositivos
def get_grupos_dispositivos(session: Session) -> None:
    with session.begin():
        stmt = select(GrupoDispositivos)
        results = session.execute(stmt).scalars().all()

        if not results:
            print("No hay Grupos de Dispositivos registrados.")
            return

        print("Grupos de Dispositivos registrados:")
        for grupo in results:
            print(f"ID: {grupo.id} | Nombre: {grupo.nombre} | Descripción: {grupo.descripcion}")

# Obtener todos los Dispositivos  
def get_dispositivos(session: Session) -> None:
    with session.begin():
        stmt = select(Dispositivo)
        results = session.execute(stmt).scalars().all()

        if not results:
            print("No hay Dispositivos registrados.")
            return

        print("Dispositivos registrados:")
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Ubicación: {device.descripcion_ubicacion} | Tipo ID: {device.tipo_dispositivo_id}")

# MIGRACION V2: Obtener todos los Dispositivos con los campos nuevos:
def get_dispositivos_v2(session: Session) -> None:
    with session.begin():
        stmt = select(Dispositivo)
        results = session.execute(stmt).scalars().all()

        if not results:
            print("No hay Dispositivos registrados.")
            return

        print("Dispositivos registrados:")
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Descripción Ubicación: {device.descripcion_ubicacion} | Coordenadas GPS: {device.coordenadas_gps} | Estado_actual: {device.estado_actual} | Tipo ID: {device.tipo_dispositivo_id}")

# Obtener Dispositivos Filtrados por TipoDispositivo
def get_dispositivos_by_tipo(session: Session, tipo_dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(Dispositivo).where(Dispositivo.tipo_dispositivo_id == tipo_dispositivo_id)
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay Dispositivos registrados para el Tipo de Dispositivo con ID {tipo_dispositivo_id}.")
            return

        print(f"Dispositivos registrados para el Tipo de Dispositivo con ID: {tipo_dispositivo_id}:")
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Ubicación: {device.descripcion_ubicacion}")

# MIGRACIÓN V2: Obtener Dispositivos Filtrados por TipoDispositivo con los campos nuevos:
def get_dispositivos_by_tipo_v2(session: Session, tipo_dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(Dispositivo).where(Dispositivo.tipo_dispositivo_id == tipo_dispositivo_id)
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay Dispositivos registrados para el Tipo de Dispositivo con ID {tipo_dispositivo_id}.")
            return

        print(f"Dispositivos registrados para el Tipo de Dispositivo con ID: {tipo_dispositivo_id}:")
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Descripción Ubicación: {device.descripcion_ubicacion} | Coordenadas GPS: {device.coordenadas_gps} | Estado_actual: {device.estado_actual} | Tipo ID: {device.tipo_dispositivo_id}")


# Obtener Dispositivos asociados a un GrupoDispositivo
def get_dispositivos_by_grupo(session: Session, grupo_dispositivo_id: int) -> None:
    with session.begin():
        stmt = (
            select(Dispositivo)
            .join(DispositivosAgrupados)
            .where(DispositivosAgrupados.grupo_dispositivo_id == grupo_dispositivo_id)
        )

        results = session.execute(stmt).scalars().all()
        if not results:
            print(f"No hay dispositivos asociados al grupo con ID {grupo_dispositivo_id}.")
            return
        
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Ubicación: {device.descripcion_ubicacion}")

# MIGRACIÓN V2: Obtener Dispositivos asociados a un GrupoDispositivo con los campos nuevos:
def get_dispositivos_by_grupo_v2(session: Session, grupo_dispositivo_id: int) -> None:
    with session.begin():
        stmt = (
            select(Dispositivo)
            .join(DispositivosAgrupados)
            .where(DispositivosAgrupados.grupo_dispositivo_id == grupo_dispositivo_id)
        )

        results = session.execute(stmt).scalars().all()
        if not results:
            print(f"No hay dispositivos asociados al grupo con ID {grupo_dispositivo_id}.")
            return
        
        for device in results:
            print(f"ID: {device.id} | N° Serie: {device.numero_serie} | MAC: {device.mac_address} | Firmware: {device.version_firmware} | Descripción Ubicación: {device.descripcion_ubicacion} | Coordenadas GPS: {device.coordenadas_gps} | Estado_actual: {device.estado_actual} | Tipo ID: {device.tipo_dispositivo_id}")


# Obtener GrupoDispositivo asociados a un Dispositivo
def get_grupos_by_dispositivo(session: Session, dispositivo_id: int) -> None:
    with session.begin():
        stmt = (
            select(GrupoDispositivos)
            .join(DispositivosAgrupados)
            .where(DispositivosAgrupados.dispositivo_id == dispositivo_id)
        )

        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay grupos asociados al dispositivo con ID {dispositivo_id}.")
            return

        for group in results:
            print(f"ID: {group.id} | Nombre: {group.nombre} | Descripción: {group.descripcion}")

# Obtener todos los Sensores asociados a un Dispositivo
def get_sensores_by_dispositivo(session: Session, dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(Sensor).where(Sensor.dispositivo_id == dispositivo_id)
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay sensores asociados al dispositivo con ID {dispositivo_id}.")
            return

        for sensor in results:
            print(f"ID: {sensor.id} | Tipo: {sensor.tipo_sensor} | Unidad: {sensor.unidad_medida}")

# MIGRACIÓN V2: Obtener todos los Sensores asociados a un Dispositivo con los campos nuevos:
def get_sensores_by_dispositivo_v2(session: Session, dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(Sensor).where(Sensor.dispositivo_id == dispositivo_id)
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay sensores asociados al dispositivo con ID {dispositivo_id}.")
            return

        for sensor in results:
            print(f"ID: {sensor.id} | Tipo: {sensor.tipo_sensor} | Unidad: {sensor.unidad_medida} | Umbral Alerta: {sensor.umbral_alerta}")


# Obtener las últimas N lecturaDatos de un Sensor específico
def get_lectura_datos_by_sensor(session: Session, sensor_id: int, n: int) -> None:
    with session.begin():
        stmt = (
            select(LecturaDato)
            .where(LecturaDato.sensor_id == sensor_id)
            .order_by(desc(LecturaDato.timestamp))
            .limit(n)
        )
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay lecturas para el sensor con ID {sensor_id}.")
            return

        for lectura in results:
            print(f"ID: {lectura.id} | Valor: {lectura.valor_leido} | Timestamp: {lectura.timestamp}")

# Obtener todos los LogsEstadoDispositivo de un Dispositivo
def get_logs_by_dispositivo(session: Session, dispositivo_id: int) -> None:
    with session.begin():
        stmt = select(LogEstadoDispositivo).where(LogEstadoDispositivo.dispositivo_id == dispositivo_id)
        results = session.execute(stmt).scalars().all()

        if not results:
            print(f"No hay logs para el dispositivo con ID {dispositivo_id}.")
            return

        for log in results:
            print(f"ID: {log.id} | Estado: {log.estado} | Mensaje: {log.mensaje_opcional} | Timestamp: {log.timestamp}")
