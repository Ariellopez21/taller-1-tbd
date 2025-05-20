
from advanced_alchemy.extensions.litestar import SQLAlchemyDTOConfig
from litestar.plugins.sqlalchemy import SQLAlchemyDTO

from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo

'''
DataTransferObjects (DTOs): Son clases que se utilizan para definir la estructura de los datos que se envían y reciben en las peticiones HTTP.

Es para manipular entradas y salidas

En estos casos se utiliza para esconder el campo id, ya que no es necesario que el cliente lo envíe al crear un nuevo elemento.

'''
class TipoDispositivoReadDTO(SQLAlchemyDTO[TipoDispositivo]):
    config = SQLAlchemyDTOConfig(exclude={"dispositivos"}, partial=True)
class TipoDispositivoCreateDTO(SQLAlchemyDTO[TipoDispositivo]):
    config = SQLAlchemyDTOConfig(exclude={"id", "dispositivos"}, partial=True)

class GrupoDispositivosReadDTO(SQLAlchemyDTO[GrupoDispositivos]):
    config = SQLAlchemyDTOConfig(exclude={"dispositivos"}, partial=True)
class GrupoDispositivosCreateDTO(SQLAlchemyDTO[GrupoDispositivos]):
    config = SQLAlchemyDTOConfig(exclude={"id", "dispositivos"}, partial=True)

class DispositivoReadDTO(SQLAlchemyDTO[Dispositivo]):
    config = SQLAlchemyDTOConfig(exclude={"tipo_dispositivo", "sensores", "logs_estado_dispositivo", "grupos_dispositivos"}, partial=True)
class DispositivoCreateDTO(SQLAlchemyDTO[Dispositivo]):
    config = SQLAlchemyDTOConfig(exclude={"id","tipo_dispositivo", "sensores", "logs_estado_dispositivo", "grupos_dispositivos"}, partial=True)

