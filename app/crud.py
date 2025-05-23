import datetime
from enum import auto
from re import A, U
from tkinter import Y
from litestar import get, post, Controller, patch, delete 
#from dataclasses import dataclass
#from litestar import put, delete, patch, Router

from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import DATE, select, desc, and_, or_
from sqlalchemy.exc import IntegrityError
from advanced_alchemy.exceptions import NotFoundError
from advanced_alchemy.filters import ComparisonFilter, CollectionFilter

from typing import Sequence

from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo, DispositivosAgrupados, Sensor, LecturaDato, LogEstadoDispositivo


from app import dtos
from app import repositories as repo
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
        print(f"Asociación eliminada: Dispositivo {dispositivo_id} - Grupo {grupo_dispositivo_id}")

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
            #print(f"Log registrado: {estado} para dispositivo {dispositivo_id}")
        except IntegrityError:
            session.rollback()

class TipoDispositivoController(Controller):
    path = '/tipos_dispositivos'
    tags = ["Tipo"]
    # return_dto=TipoDispositivoReadDTO proviene de import app.dtos
    return_dto=dtos.TipoDispositivoReadDTO
    dependencies = {
        # provide_tipodispositivo_repo proviene de import app.repositories
        "tipodispositivo_repo": Provide(repo.provide_tipodispositivo_repo)
    }
    # tipodispositivo_repo: proviene de import app.repositories
    # Sequence[TipoDispositivo]: es una lista de objetos TipoDispositivo
    @get("/")
    async def list_items(self, 
                         tipodispositivo_repo: repo.TipoDispositivoRepository
                         ) -> Sequence[TipoDispositivo]:
        return tipodispositivo_repo.list()
    '''
    @post("/", dto=dtos.TipoDispositivoCreateDTO)
    async def create_item(self, tipodispositivo_repo: repo.TipoDispositivoRepository, data: DTOData[TipoDispositivo]) -> TipoDispositivo:
    '''
class GrupoDispositivosController(Controller):
    path = '/grupos_dispositivos'
    tags = ["Grupo"]
    return_dto=dtos.GrupoDispositivosReadDTO
    dependencies = {
        "grupodispositivos_repo": Provide(repo.provide_grupodispositivos_repo)
    }

    @get("/")
    async def list_items(self, 
                         grupodispositivos_repo: repo.GrupoDispositivosRepository
                         ) -> Sequence[GrupoDispositivos]:
        return grupodispositivos_repo.list()
    '''
    @post("/", dto=dtos.GrupoDispositivosCreateDTO)
    async def create_item(self, grupodispositivos_repo: repo.GrupoDispositivosRepository, data: DTOData[GrupoDispositivos]) -> GrupoDispositivos:
    '''
class DispositivoController(Controller):
    path = '/dispositivos'
    tags = ["Dispositivo"]
    return_dto=dtos.DispositivoReadDTO
    dependencies = {
        "dispositivo_repo": Provide(repo.provide_dispositivo_repo),
        "grupodispositivos_repo": Provide(repo.provide_grupodispositivos_repo)
    }

    @get("/")
    async def list_items(self, 
                         dispositivo_repo: repo.DispositivoRepository
                         ) -> Sequence[Dispositivo]:
        return dispositivo_repo.list()
    
    @get("/by_type/{tipo_dispositivo_id:int}")
    async def list_items_by_tipo(self,
                                 dispositivo_repo: repo.DispositivoRepository,
                                 tipo_dispositivo_id: int
                                 ) -> Sequence[Dispositivo]:
        return dispositivo_repo.list(ComparisonFilter("tipo_dispositivo_id","eq",value=tipo_dispositivo_id))

    '''
    @post("/", dto=dtos.DispositivoCreateDTO)
    async def create_item(self, dispositivo_repo: repo.DispositivoRepository, data: DTOData[Dispositivo]) -> Dispositivo:
    '''

class DispositivosAgrupadosController(Controller):
    path = '/dispositivos_agrupados'
    tags = ["Dispositivo/Grupo"]
    return_dto=dtos.DispositivosAgrupadosCreateDTO
    dependencies = {
        "dispositivosagrupados_repo": Provide(repo.provide_dispositivosagrupados_repo)
    }

    @get("/all")
    async def list_items(self, 
                         dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository
                         ) -> Sequence[DispositivosAgrupados]:
        return dispositivosagrupados_repo.list()
    
    @get("/by_group/{grupo_dispositivo_id:int}")
    async def list_items_by_group(self,
                                  dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository,
                                  grupo_dispositivo_id: int
                                  ) -> Sequence[DispositivosAgrupados]:
        return dispositivosagrupados_repo.list(ComparisonFilter("grupo_dispositivo_id","eq",value=grupo_dispositivo_id))

    @get("/by_device/{dispositivo_id:int}")
    async def list_items_by_device(self,
                                  dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository,
                                  dispositivo_id: int
                                  ) -> Sequence[DispositivosAgrupados]:
        return dispositivosagrupados_repo.list(ComparisonFilter("dispositivo_id","eq",value=dispositivo_id))


'''    @post("/{dispositivo_id:int}/{grupo_dispositivo_id:int}", dto=dtos.DispositivosAgrupadosCreateDTO)
    async def create_item(self, dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository, data: DTOData[DispositivosAgrupados]) -> DispositivosAgrupados:
        
    @delete("/{dispositivo_id:int}/{grupo_dispositivo_id:int}")
    async def delete_item(self,   dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository,dispositivo_id: int,grupo_dispositivo_id: int) -> None:
'''

class SensorController(Controller):
    path = '/sensores'
    tags = ["Sensor"]
    return_dto=dtos.SensorReadDTO
    dependencies = {
        "sensor_repo": Provide(repo.provide_sensor_repo)
    }

    @get("/")
    async def list_items(self, 
                         sensor_repo: repo.SensorRepository
                         ) -> Sequence[Sensor]:
        return sensor_repo.list()
    
    @get("/by_device/{dispositivo_id:int}")
    async def list_items_by_device(self,
                                  sensor_repo: repo.SensorRepository,
                                  dispositivo_id: int
                                  ) -> Sequence[Sensor]:
        return sensor_repo.list(ComparisonFilter("dispositivo_id","eq",value=dispositivo_id))
    
'''    @post("/", dto=dtos.SensorCreateDTO)
    async def create_item(self, sensor_repo: repo.SensorRepository, data: DTOData[Sensor]) -> Sensor:'''
        
class LecturaDatoController(Controller):
    path = '/lecturas_datos'
    tags = ["Lectura"]
    return_dto=dtos.LecturaDatoReadDTO
    dependencies = {
        "lecturadato_repo": Provide(repo.provide_lecturadato_repo)
    }

    @get("/")
    async def list_items(self, 
                         lecturadato_repo: repo.LecturaDatoRepository
                         ) -> Sequence[LecturaDato]:
        return lecturadato_repo.list()
    
    @get("/by_sensor/{sensor_id:int}")
    async def list_items_by_sensor(self,
                                  lecturadato_repo: repo.LecturaDatoRepository,
                                  sensor_id: int,
                                  n: int
                                  ) -> Sequence[LecturaDato]:
        stmt = (
            select(LecturaDato)
            .where(LecturaDato.sensor_id == sensor_id)
            .order_by(desc(LecturaDato.timestamp))
            .limit(n)
        )
        result = lecturadato_repo.session.execute(stmt).scalars().all()
        return result    
    
'''    @post("/", dto=dtos.LecturaDatoCreateDTO)
    async def create_item(self, lecturadato_repo: repo.LecturaDatoRepository, data: DTOData[LecturaDato]) -> LecturaDato:
'''

class LogEstadoDispositivoController(Controller):
    path = '/logs_estado_dispositivo'
    tags = ["Logs"]
    return_dto=dtos.LogEstadoDispositivoReadDTO
    dependencies = {
        "logestadodispositivo_repo": Provide(repo.provide_logestadodispositivo_repo)
    }

    @get("/")
    async def list_logs(self, 
                         logestadodispositivo_repo: repo.LogEstadoDispositivoRepository
                         ) -> Sequence[LogEstadoDispositivo]:
        return logestadodispositivo_repo.list()
    
    @get("/by_device/{dispositivo_id:int}")
    async def list_logs_by_device(self,
                                  logestadodispositivo_repo: repo.LogEstadoDispositivoRepository,
                                  dispositivo_id: int
                                  ) -> Sequence[LogEstadoDispositivo]:
        return logestadodispositivo_repo.list(ComparisonFilter("dispositivo_id","eq",value=dispositivo_id))
    
'''    @post("/", dto=dtos.LogEstadoDispositivoCreateDTO)
    async def create_log(self, logestadodispositivo_repo: repo.LogEstadoDispositivoRepository, data: DTOData[LogEstadoDispositivo]) -> LogEstadoDispositivo:'''
