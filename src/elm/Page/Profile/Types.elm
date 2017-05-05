module Page.Profile.Types exposing (model, Model, PhotoInfo, Msg(NavigateTo, UploadFile, ResponsePhotos))

type alias Model = 
    { displayName : String
    , email : String
    , emailVerified : Bool
    , photoURL : String
    , photos : List (String, PhotoInfo)
    }


model : Model
model = 
    { displayName = ""
    , email = ""
    , emailVerified = False
    , photoURL = ""
    , photos = []
    }

type alias PhotoInfo =
    { photoUrl : String
    , userId : String
    }

--type alias Photo = 
--    { key : String
--    , data : PhotoInfo
--    }

type Msg 
    = NavigateTo String
    | UploadFile String
    | ResponsePhotos (List (String, PhotoInfo))

