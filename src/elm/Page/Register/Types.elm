module Page.Register.Types exposing (Model, model, Msg(Register, OnInputEmail, OnInputPassword))


-- MODEL


type alias Model = 
    { email : String
    , password : String
    , error : String
    }

model : Model
model = 
    { email = ""
    , password = ""
    , error = ""
    }


-- MSG


type Msg 
    = Register
    | OnInputEmail String
    | OnInputPassword String