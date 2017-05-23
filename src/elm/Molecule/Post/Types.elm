module Molecule.Post.Types exposing (TopicMsg(..), Post, PostID, Topic, TopicID)



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


type TopicMsg
    -- Get a list of topic
    = All (List(TopicID, Topic))