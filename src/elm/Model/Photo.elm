-- Photo is the photo metadata

module Model.Photo exposing (Photo, PhotoID)


-- MODEL


type alias Photo =
    { photoUrl : String
    , userId : String
    , displayName : String
    , alt : String
    , createdAt : String
    , updatedAt : String
    }


type alias PhotoID = String