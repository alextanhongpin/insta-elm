module Page.Login.Types exposing (Model, Msg(..), model, User)



-- MODEL


type alias Model = 
    { placeholder : String
    , email : String
    , password : String
    , error : String
    , isAuthorized : Bool
    }


type alias User = 
  { displayName : String
  , email : String
  , emailVerified : Bool
  , photoURL : String
  , isAnonymous : Bool
  , uid : String
}



model : Model
model = 
    { placeholder = ""
    , email = ""
    , password = ""
    , error = ""
    , isAuthorized = False
    }


-- MSG


type Msg 
    = Login
    | LoginSuccess User
    | LoginError String
    | OnInputEmail String
    | OnInputPassword String
    | OnSubmitLogin