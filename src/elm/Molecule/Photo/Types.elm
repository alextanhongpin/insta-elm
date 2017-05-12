-- Photo is the photo metadata

module Molecule.Photo.Types exposing (Photo, PhotoID, PhotoMsg(..))


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


-- MSG


type PhotoMsg 
    = PublicAll (List(PhotoID, Photo))