from litestar.plugins.sqlalchemy import SQLAlchemySyncConfig, SQLAlchemyPlugin

from app.models import Base

db_config = SQLAlchemySyncConfig(
    connection_string="sqlite:///db.sqlite3", create_all=True, metadata=Base.metadata
)

sqla_plugin = SQLAlchemyPlugin(config=db_config)
