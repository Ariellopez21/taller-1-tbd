from litestar.plugins.sqlalchemy import SQLAlchemySyncConfig, SQLAlchemyPlugin

from app.models import Base

db_config = SQLAlchemySyncConfig(
    connection_string="postgresql+psycopg2:///iot_devices", create_all=True, metadata=Base.metadata
)

sqla_plugin = SQLAlchemyPlugin(config=db_config)
