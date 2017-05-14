module Page.Profile.Types exposing (model, Model, PhotoInfo, Msg(..))


import Molecule.Post.Types exposing (TopicID, Topic)


-- MODEL


type alias Model = 
    { displayName : String
    , ghostDisplayName : String
    , email : String
    , emailVerified : Bool
    , photoURL : String
    , photos : List (String, PhotoInfo)
    , progress : Float
    , alt : String
    , uploadProgress : Float
    , enableEditProfile : Bool
    , count : Int
    , uid : String
    , topics : Maybe (List (TopicID, Topic))
    }


model : Model
model = 
    { displayName = ""
    , ghostDisplayName = ""
    , email = ""
    , emailVerified = False
    , photoURL = ""
    , photos = []
    , progress = 0.0
    , alt = ""
    , uploadProgress = 0.0
    , enableEditProfile = False
    , count = 0
    , uid = ""
    , topics = Just [ ("1", Topic "John Doe" "Today" "Today" "Hello World" "This is a hello world content" "apple" 0 "none" "") ]
    }

type alias PhotoInfo =
    { photoUrl : String
    , userId : String
    , displayName : String
    , alt : String
    , createdAt : String
    , updatedAt : String
    }

type alias NodeID = String

--type alias Photo = 
--    { key : String
--    , data : PhotoInfo
--    }


-- MSG


type Msg 
    = NavigateTo String
    | UploadFile NodeID PhotoInfo
    | ProfilePhoto String
    | ProfilePhotoSuccess String
    --| ResponsePhotos (List (String, PhotoInfo))
    | Progress Float
    | Caption String
    | UploadProgress Float
    | ToggleEditProfile
    | SubmitEdit
    | DisplayName String
    | SetDisplayNameSuccess String
    | PhotoCountSuccess Int
    | GoToTopic String
    | GoTo String String

