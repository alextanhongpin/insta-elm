module Molecule.Post.Types exposing (..)


-- MODEL


type alias Post =
    { photoUrl : String
    , userId : String
    , displayName : String
    , alt : String
    , content : String
    , createdAt : String
    , updatedAt : String
    }


type alias PostID = String


-- MSG


--type TopicMsg 
--    = All (List(TopicID, Topic))
--    | 