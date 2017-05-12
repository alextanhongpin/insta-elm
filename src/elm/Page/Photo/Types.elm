module Page.Photo.Types exposing (Model, model, Msg(..))


-- MODEL


import Molecule.Comment.Types exposing (Comment, CommentID, CommentMsg(..), CommentEditMsg(..))

import Molecule.Photo.Types exposing (Photo, PhotoID)



-- Use photo recognition to prevent nude photos
type alias Model = 
    { isLiked : Bool
    , comments : List(CommentID, Comment) -- The list of comments
    , comment : String -- The comment to be posted
    , isEditing : Bool
    -- Use spam recognition to prevent spamming
    , ghostID : String
    , ghostComment : Comment -- Temporary store the comment to be edited
    , errorEditTextEmpty : String -- Error display if the edit text is empty
    , photoID : String
    , userId : String
    , photo : Photo
    }


model : Model
model = 
    { isLiked = False
    , comments = []
    , comment = ""
    , isEditing = False
    , ghostID = ""
    , ghostComment = Comment "" "" ""
    , errorEditTextEmpty = ""
    , photoID = ""
    , userId = ""
    , photo = Photo "" "" "" "" "" ""
    }



type Msg
    = Like
    | ResponsePhoto (PhotoID, Photo)
    | DeletePhoto String
    | DeletePhotoSuccess String
    | CommentAction CommentMsg
    | CommentEditAction CommentEditMsg


