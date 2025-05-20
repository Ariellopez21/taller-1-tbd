from advanced_alchemy.repository import SQLAlchemySyncRepository
from app.models import TipoDispositivo, GrupoDispositivos, Dispositivo, DispositivosAgrupados, Sensor, LecturaDato, LogEstadoDispositivo
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

class DispositivosAgrupadosRepository(SQLAlchemySyncRepository[DispositivosAgrupados]):
    model_type = DispositivosAgrupados
async def provide_dispositivosagrupados_repo(db_session: Session) -> DispositivosAgrupadosRepository:
    """
    Provide a SQLAlchemySyncRepository for DispositivosAgrupados.
    """
    return DispositivosAgrupadosRepository(session=db_session)

class SensorRepository(SQLAlchemySyncRepository[Sensor]):
    model_type = Sensor
async def provide_sensor_repo(db_session: Session) -> SensorRepository:
    """
    Provide a SQLAlchemySyncRepository for Sensor.
    """
    return SensorRepository(session=db_session)

class LecturaDatoRepository(SQLAlchemySyncRepository[LecturaDato]):
    model_type = LecturaDato

async def provide_lecturadato_repo(db_session: Session) -> LecturaDatoRepository:
    """
    Provide a SQLAlchemySyncRepository for LecturaDato.
    """
    return LecturaDatoRepository(session=db_session)

class LogEstadoDispositivoRepository(SQLAlchemySyncRepository[LogEstadoDispositivo]):
    model_type = LogEstadoDispositivo
async def provide_logestadodispositivo_repo(db_session: Session) -> LogEstadoDispositivoRepository:
    """
    Provide a SQLAlchemySyncRepository for LogEstadoDispositivo.
    """
    return LogEstadoDispositivoRepository(session=db_session)
