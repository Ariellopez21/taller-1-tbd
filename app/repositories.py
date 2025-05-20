from advanced_alchemy.repository import SQLAlchemySyncRepository
from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo
from sqlalchemy.orm import Session

'''
Qué son las CRUD operations:
    CRUD es un acrónimo que se refiere a las operaciones básicas que se pueden realizar en una base de datos. 
    Estas operaciones son: Crear (Create), Leer (Read), Actualizar (Update) y Eliminar (Delete).
    Estas operaciones son fundamentales para la gestión de datos en aplicaciones web y sistemas de bases de datos.
SQLAlchemySyncRepository implementa las operaciones CRUD de manera sencilla y eficiente.
docs.advanced-alchemy.litestar.dev/reference/repository.html
'''
class TipoDispositivoRepository(SQLAlchemySyncRepository[TipoDispositivo]):
    model_type = TipoDispositivo

async def provide_tipodispositivo_repo(db_session: Session) -> TipoDispositivoRepository:
    """
    Provide a SQLAlchemySyncRepository for TipoDispositivo.
    """
    return TipoDispositivoRepository(session=db_session)


class GrupoDispositivosRepository(SQLAlchemySyncRepository[GrupoDispositivos]):
    model_type = GrupoDispositivos

async def provide_grupodispositivos_repo(db_session: Session) -> GrupoDispositivosRepository:
    """
    Provide a SQLAlchemySyncRepository for GrupoDispositivos.
    """
    return GrupoDispositivosRepository(session=db_session)

class DispositivoRepository(SQLAlchemySyncRepository[Dispositivo]):
    model_type = Dispositivo

async def provide_dispositivo_repo(db_session: Session) -> DispositivoRepository:
    """
    Provide a SQLAlchemySyncRepository for Dispositivo.
    """
    return DispositivoRepository(session=db_session)

