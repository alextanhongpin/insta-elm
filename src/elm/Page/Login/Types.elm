module Page.Login.Types exposing (..)


-- MODEL


type alias Model = 
    { placeholder : String
    , email : String
    }

model : Model
model = 
    { placeholder = ""
    , email = ""
    }


-- MSG


type Msg 
    = Login
    | OnInputEmail String