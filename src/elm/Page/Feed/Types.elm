module Page.Feed.Types exposing (Model, model, Msg(..))


import Molecule.Post.Types exposing (TopicID, Topic)
import Molecule.Photo.Types exposing (PhotoID, Photo, PhotoMsg(..))


type alias Model =
    { name : String
    , topics : Maybe (List (TopicID, Topic))
    , photos: List(PhotoID, Photo)
    }

model : Model
model =
    { name = ""
    , topics = Just [ ("1", Topic "John Doe" "Today" "Today" "Hello World" "This is a hello world content" "apple" 0 "none" "") ]
    , photos = []
    }


type alias TopicID = String
type Msg
    = GoToTopic TopicID
    | PhotoAction PhotoMsg
    | GoTo String String