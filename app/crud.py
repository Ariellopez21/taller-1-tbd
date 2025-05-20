from enum import auto
from litestar import get, post, Controller, patch, delete 
#from dataclasses import dataclass
#from litestar import put, delete, patch, Router

from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from advanced_alchemy.exceptions import NotFoundError
from advanced_alchemy.filters import ComparisonFilter, CollectionFilter

from typing import Sequence

from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo
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

