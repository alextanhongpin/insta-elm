module Page.Login.Types exposing (..)


-- MODEL


type alias Model = 
    { placeholder : String
    , email : String
    , password : String
    , hint : String
    , isAuthorized : Bool
    }

model : Model
model = 
    { placeholder = ""
    , email = ""
    , password = ""
    , hint = ""
    , isAuthorized = False
    }


-- MSG


type Msg 
    = Login
    | OnInputEmail String
    | OnInputPassword String
    | OnSubmitLogin