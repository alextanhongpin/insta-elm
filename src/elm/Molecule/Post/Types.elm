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

type alias TopicID = String
type alias Topic =
    { owner : String
    , createdAt : String
    , updatedAt : String
    , title : String
    , content : String
    , topic : String
    , commentCount : Int
    , url : String
    , photoURL : String }

-- MSG


--type TopicMsg 
--    = All (List(TopicID, Topic))
--    | 