module Page.Profile.Types exposing (model, Model, PhotoInfo, Msg(..))

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

type Msg 
    = NavigateTo String
    | UploadFile NodeID PhotoInfo
    | ProfilePhoto String
    | ProfilePhotoSuccess String
    | ResponsePhotos (List (String, PhotoInfo))
    | Progress Float
    | Caption String
    | UploadProgress Float
    | ToggleEditProfile
    | SubmitEdit
    | DisplayName String
    | SetDisplayNameSuccess String
    | PhotoCountSuccess Int

