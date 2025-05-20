from litestar import Litestar
from app.database import sqla_plugin
from app import crud as controllers

app = Litestar(
    route_handlers=[controllers.TipoDispositivoController,
                    controllers.GrupoDispositivosController,
                    controllers.DispositivoController,
                    controllers.DispositivosAgrupadosController,
                    controllers.SensorController,
                    controllers.LecturaDatoController,
                    controllers.LogEstadoDispositivoController], 
    plugins=[sqla_plugin],
    debug=True)