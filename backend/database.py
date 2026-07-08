# database.py 

import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Reads the DATABASE_URL from docker-compose environment variables
DATABASE_URL = os.getenv("DATABASE_URL")

# Creates the connection engine
engine = create_engine(DATABASE_URL)

# Each request gets its own session, closed after
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# All models inherit from this
Base = declarative_base()

# Dependency — used in every route to get a DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()