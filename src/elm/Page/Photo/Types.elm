module Page.Photo.Types exposing (Comment, Model, model, Msg(Like, AddComment, CancelEdit, SubmitEdit, EditComment, DeleteComment, EditingComment, TypeComment))

import List
-- MODEL

type alias Comment = 
    { id : String
    , text : String
    , displayName : String
    }

-- Use photo recognition to prevent nude photos
type alias Model = 
    { isLiked : Bool
    , comments : List Comment -- The list of comments
    , comment : String -- The comment to be posted
    , isEditing : Bool
    -- Use spam recognition to prevent spamming
    , ghostComment : Comment -- Temporary store the comment to be edited
    , errorEditTextEmpty : String -- Error display if the edit text is empty
    }


model : Model
model = 
    { isLiked = False
    , comments = 
        [ Comment "1" "This is awesome!" "Baby.Doe"
        , Comment "2" "Great shot!" "Big Fan"
        , Comment "3" "Where was it?" "Tadaaa"
        ]
    , comment = ""
    , isEditing = False
    , ghostComment = Comment "" "" ""
    , errorEditTextEmpty = ""
    }


-- MSG


type alias PhotoID 
    = String

type Msg
    = Like
    | AddComment String
    | TypeComment String
    | DeleteComment Comment
    | EditComment Comment -- Trigger edit
    | EditingComment String -- Input value is changing
    | CancelEdit Comment 
    | SubmitEdit Comment



