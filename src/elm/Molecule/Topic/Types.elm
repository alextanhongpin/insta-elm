module Molecule.Topic.Types exposing (..)


-- MODEL


type alias Topic =
    { photoUrl : String
    , userId : String
    , displayName : String
    , alt : String
    , content : String
    , createdAt : String
    , updatedAt : String
    }


type alias TopicID = String


-- MSG


--type TopicMsg 
--    = All (List(TopicID, Topic))
--    | 