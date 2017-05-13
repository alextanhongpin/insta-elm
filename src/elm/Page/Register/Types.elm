module Page.Register.Types exposing (Model, model, Msg(Register, OnInputEmail, OnInputPassword))


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
    = Register
    | OnInputEmail String
    | OnInputPassword String