from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try:
        # get the user token from headers
        if not x_auth_token:
            raise HTTPException(
                status_code=401, detail="Token not found, access denied"
            )

        # decode jwt token
        verified_token = jwt.decode(x_auth_token, "password_key", "HS256")

        if not verified_token:
            raise HTTPException(401, "Token verification failed, authorization denied")

        uid = verified_token.get("id")

        return {"uid": uid, "token": x_auth_token}
    except:
        raise HTTPException(401, "Token is not valid, authorization failed")
