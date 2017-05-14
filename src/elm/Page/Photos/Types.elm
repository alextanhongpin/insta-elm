module Page.Photos.Types exposing (Model, model, Msg(..))


-- MODEL


type alias Model =
    { query : String
    }

model : Model
model = 
    { query = ""
    }


type Msg 
    = Something