from fastapi import FastAPI

from sqlalchemy.ext.declarative import declarative_base
from routes import auth, song
from database import engine
from models.base import Base


app = FastAPI()

app.include_router(auth.router, prefix="/auth")
app.include_router(song.router, prefix="/song")


Base.metadata.create_all(engine)
