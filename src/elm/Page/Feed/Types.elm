module Page.Feed.Types exposing (Model, model, Msg(..))


import Molecule.Photo.Types exposing (PhotoID, Photo, PhotoMsg(..))

type alias Model =
    { name : String
    , photos: List(PhotoID, Photo)
    }

model : Model
model =
    { name = ""
    , photos = []
    }


type alias TopicID = String
type Msg
    = GoToTopic TopicID
    | PhotoAction PhotoMsg