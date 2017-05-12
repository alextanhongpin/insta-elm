module Page.Topic.Types exposing (..)

type alias Model =
    { topic : String -- Store the query parameter for the topic
    }

model : Model
model =
    { topic = ""
    }


-- MSG 


type Msg
    = Nth
    | GoTo String String