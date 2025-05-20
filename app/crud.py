from enum import auto
from litestar import get, post, Controller, patch, delete 
#from dataclasses import dataclass
#from litestar import put, delete, patch, Router

from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select, desc
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
    
    @post("/", dto=dtos.TipoDispositivoCreateDTO)
    async def create_item(self, 
                          tipodispositivo_repo: repo.TipoDispositivoRepository, 
                          data: DTOData[TipoDispositivo]
                          ) -> TipoDispositivo:
        try:
            return tipodispositivo_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe un TipoDispositivo con ese modelo.", extra={"YA EXISTE": "hola"})
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))

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
    
    @post("/", dto=dtos.GrupoDispositivosCreateDTO)
    async def create_item(self, 
                          grupodispositivos_repo: repo.GrupoDispositivosRepository, 
                          data: DTOData[GrupoDispositivos]
                          ) -> GrupoDispositivos:
        try:
            return grupodispositivos_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe un GrupoDispositivos con ese nombre.")
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))

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

    @post("/", dto=dtos.DispositivoCreateDTO)
    async def create_item(self, 
                          dispositivo_repo: repo.DispositivoRepository, 
                          data: DTOData[Dispositivo]
                          ) -> Dispositivo:
        try:
            return dispositivo_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe un Dispositivo con ese número de serie o dirección MAC.")
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))
    ''' 
    @patch("/{dispositivo_id:int}", dto=dtos.DispositivoCreateDTO)
    async def asociar_grupo(self,
                            dispositivo_id: int,
                            grupo_id: int,
                            dispositivo_repo: repo.DispositivoRepository,
                            grupodispositivos_repo: repo.GrupoDispositivosRepository
                            ) -> Dispositivo | None:
        try:
            grupo = grupodispositivos_repo.get(grupo_id)
            if not grupo:
                raise HTTPException(status_code=404, detail="Grupo no encontrado")

            def actualizar(dispositivo: Dispositivo):
                dispositivo.grupos_dispositivos.append(grupo)

            dispositivo, _ = dispositivo_repo.get_and_update(
                match_fields="id",
                id=dispositivo_id,
                update=actualizar,
                auto_commit=True
            )

            return dispositivo
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error al asociar grupo: {e}")
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


    @post("/{dispositivo_id:int}/{grupo_dispositivo_id:int}", dto=dtos.DispositivosAgrupadosCreateDTO)
    async def create_item(self, 
                          dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository, 
                          data: DTOData[DispositivosAgrupados]
                          ) -> DispositivosAgrupados:
        try:
            return dispositivosagrupados_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe una asociación entre ese dispositivo y grupo.")
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))
        
    @delete("/{dispositivo_id:int}/{grupo_dispositivo_id:int}")
    async def delete_item(self, 
                      dispositivosagrupados_repo: repo.DispositivosAgrupadosRepository,
                      dispositivo_id: int,
                      grupo_dispositivo_id: int
                      ) -> None:
        stmt = select(DispositivosAgrupados).where(
            DispositivosAgrupados.dispositivo_id == dispositivo_id,
            DispositivosAgrupados.grupo_dispositivo_id == grupo_dispositivo_id)
        result = dispositivosagrupados_repo.session.execute(stmt).scalar_one_or_none()

        if not result:
            raise HTTPException(status_code=404, detail="Asociación no encontrada.")

        dispositivosagrupados_repo.session.delete(result)
        dispositivosagrupados_repo.session.commit()

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
    
    @post("/", dto=dtos.SensorCreateDTO)
    async def create_item(self, 
                          sensor_repo: repo.SensorRepository, 
                          data: DTOData[Sensor]
                          ) -> Sensor:
        try:
            return sensor_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe un Sensor con ese nombre.")
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))
        
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
    
    @post("/", dto=dtos.LecturaDatoCreateDTO)
    async def create_item(self, 
                          lecturadato_repo: repo.LecturaDatoRepository, 
                          data: DTOData[LecturaDato]
                          ) -> LecturaDato:
        try:
            return lecturadato_repo.add(data.create_instance(), auto_commit=True)
        except IntegrityError:
            raise HTTPException(status_code=400, detail="Ya existe una Lectura con ese timestamp.")
        except Exception as e:
            print("ERROR EN CREATE_ITEM:", e)
            raise HTTPException(status_code=500, detail=str(e))

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
    
    @post("/", dto=dtos.LogEstadoDispositivoCreateDTO)
    async def create_log(self, 
                          logestadodispositivo_repo: repo.LogEstadoDispositivoRepository, 
                          data: DTOData[LogEstadoDispositivo]
                          ) -> LogEstadoDispositivo:
        try:
            new_log = data.create_instance()

            stmt = (
                select(LogEstadoDispositivo)
                .where(LogEstadoDispositivo.dispositivo_id == new_log.dispositivo_id)
                .order_by(desc(LogEstadoDispositivo.timestamp))
                .limit(1)
            )
            last_log = logestadodispositivo_repo.session.execute(stmt).scalar_one_or_none()
            
            if last_log and last_log.estado == new_log.estado:
                raise HTTPException(status_code=400, detail="El estado ya fue registrado recientemente.")

            logestadodispositivo_repo.add(new_log, auto_commit=True)
            return new_log

        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error al registrar log de estado: {e}")