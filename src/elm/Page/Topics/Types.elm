module Page.Topics.Types exposing (Model, model, Msg(..))


-- MODEL


type alias Model = 
    { name : String 
    }

model : Model
model = 
    { name = ""
    }

type alias Topic = String


-- MSG


type Msg
    = GoToTopic Topic