module Page.Register.Types exposing (Model, model, Msg(Register))


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


type Msg = Register