from litestar import Litestar
from app.database import sqla_plugin
from app.crud import TipoDispositivoController

app = Litestar(
    route_handlers=[TipoDispositivoController], 
    plugins=[sqla_plugin],
    debug=True)