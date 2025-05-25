from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models import Base

engine = create_engine("postgresql+psycopg2:///iot_devices", echo=False)
Session = sessionmaker(engine) 

def create_database():
    Base.metadata.create_all(engine)