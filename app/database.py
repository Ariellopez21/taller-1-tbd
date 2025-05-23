'''
from litestar.plugins.sqlalchemy import SQLAlchemySyncConfig, SQLAlchemyPlugin

from app.models import Base

db_config = SQLAlchemySyncConfig(
    connection_string="postgresql+psycopg2:///iot_devices", create_all=True, metadata=Base.metadata
)

sqla_plugin = SQLAlchemyPlugin(config=db_config)
'''

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models import Base

engine = create_engine("postgresql+psycopg2:///iot_devices", echo=False)
Session = sessionmaker(engine) 

def create_database():
    Base.metadata.create_all(engine)