module Page.Login.Types exposing (Model, Msg(..), model)

import Molecule.User.Types exposing (User)

-- MODEL


type alias Model = 
    { email : String
    , password : String
    , error : String
    , isAuthorized : Bool
    , hasSubmitLogin : Bool
    }




model : Model
model = 
    { email = ""
    , password = ""
    , error = ""
    , isAuthorized = False
    , hasSubmitLogin = False
    }


-- MSG


type Msg 
    = Login
    | LoginSuccess User
    | LoginError String
    | OnInputEmail String
    | OnInputPassword String
    | OnSubmitLogin