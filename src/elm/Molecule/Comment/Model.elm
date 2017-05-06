-- Comment is user's opinion on a photo

module Molecule.Comment.Model exposing (Comment, CommentID)


-- MODEL


type alias Comment = 
    { photoId : String
    , text : String
    , userId : String
    }


type alias CommentID = String