from enum import auto
from litestar import get, post, Controller, patch, delete 
#from dataclasses import dataclass
#from litestar import put, delete, patch, Router

from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import select
from advanced_alchemy.exceptions import NotFoundError
from advanced_alchemy.filters import ComparisonFilter, CollectionFilter

from typing import Sequence

from app.models import TipoDispositivo
from app.dtos import TipoDispositivoReadDTO
from app.repositories import TipoDispositivoRepository, provide_tipodispositivo_repo

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
    path = '/items'
    tags = ["items"]
    # return_dto=TipoDispositivoReadDTO proviene de import app.dtos
    return_dto=TipoDispositivoReadDTO
    dependencies = {
        # provide_tipodispositivo_repo proviene de import app.repositories
        "tipodispositivo_repo": Provide(provide_tipodispositivo_repo)
    }
    # tipodispositivo_repo: proviene de import app.repositories
    # Sequence[TipoDispositivo]: es una lista de objetos TipoDispositivo
    @get("/")
    async def list_items(self, tipodispositivo_repo: TipoDispositivoRepository) -> Sequence[TipoDispositivo]:
        return tipodispositivo_repo.list()
