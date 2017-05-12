module Page.Topic.Types exposing (..)

type alias Model =
    { name : String
    }

model : Model
model =
    { name = ""
    }

type Msg
    = Nth