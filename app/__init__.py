from litestar import Litestar
from app.database import sqla_plugin
from app import crud as controllers

app = Litestar(
    route_handlers=[controllers.TipoDispositivoController,
                    controllers.GrupoDispositivosController,
                    controllers.DispositivoController], 
    plugins=[sqla_plugin],
    debug=True)