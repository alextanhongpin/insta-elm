module Page.Topics.Types exposing (Model, model, Msg(..))


-- MODEL


type alias Model = 
    { name : String 
    , query : String
    }

model : Model
model = 
    { name = ""
    , query = ""
    }

type alias Topic = String


-- MSG


type Msg
    = GoToTopic Topic
    | Search String