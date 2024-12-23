import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile

from database import get_db
from middleware.auth_middleware import auth_middleware
from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favorite import FavoriteSong

from sqlalchemy.orm import joinedload, Session


router = APIRouter()

# Configuration
cloudinary.config(
    cloud_name="dksphsszm",
    api_key="652748625486461",
    api_secret="d3V5BY2bJxFN10kg2zUGBUY18Kg",
    secure=True,
)


@router.post("/upload")
def upload_song(
    song: UploadFile = File(...),
    thumbnail: UploadFile = File(...),
    artist: str = Form(...),
    song_name: str = Form(...),
    hex_code: str = Form(...),
    db=Depends(get_db),
    auth_dict=Depends(auth_middleware),
):

    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(
        song.file, resource_type="video", folder=f"songs/{song_id}"
    )
    thumbnail_res = cloudinary.uploader.upload(
        thumbnail.file, resource_type="image", folder=f"songs/{song_id}"
    )
    # store db

    new_song = Song(
        id=song_id,
        song_url=song_result["url"],
        thumbnail_url=thumbnail_res["url"],
        artist=artist,
        song_name=song_name,
        hex_code=hex_code,
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)

    return new_song


@router.get("/list")
def list_songs(db=Depends(get_db), auth_dict=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs


@router.post('/favorite')
def favorite_song(song: FavoriteSong, 
                  db: Session=Depends(get_db), 
                  auth_details=Depends(auth_middleware)):
    # song is already favorited by the user
    user_id = auth_details['uid']

    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()), song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}

@router.get("/list/favorites")
def list_songs(db=Depends(get_db), auth_dict=Depends(auth_middleware)):
    user_id = auth_dict['uid']
    fav_songs = (
        db.query(Favorite)
        .filter(Favorite.user_id == user_id).options(
            joinedload(Favorite.song)
        ).all()
    )
    return fav_songs