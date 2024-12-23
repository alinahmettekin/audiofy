import uuid
import bcrypt
import jwt
from fastapi import Depends, HTTPException, Header

from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from database import get_db
from sqlalchemy.orm import Session, joinedload

from pydantic_schemas.user_login import UserLogin

router = APIRouter()


@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):

    user_db = db.query(User).filter(User.email == user.email).first()
    print(user_db)

    if user_db:
        raise HTTPException(status_code=400, detail="User already exists")

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(
        id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw
    )
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db


@router.post("/login", status_code=200)
def login_user(user: UserLogin, db: Session = Depends(get_db)):

    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=404, detail="User not found")

    if user_db:
        is_pw_match = bcrypt.checkpw(user.password.encode(), user_db.password)

        if is_pw_match:
            token = jwt.encode(
                {
                    "id": user_db.id,
                },
                "password_key",
            )
            return {"token": token, "user": user_db}
        else:
            raise HTTPException(status_code=401, detail="Invalid credentials")


@router.get("/")
def current_user_data(
    db: Session = Depends(get_db),
    x_auth_token=Header(),
    user_dict=Depends(auth_middleware),
):
    user = db.query(User).filter(User.id == user_dict["uid"]).options(
        joinedload(User.favorites)
    ).first()

    if not user:
        raise HTTPException(404, "User not found!")

    return user
