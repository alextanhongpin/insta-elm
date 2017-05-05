module Page.Photo.Types exposing (Comment, Model, model, Msg(Like, AddComment, CancelEdit, SubmitEdit, EditComment, DeleteComment, EditingComment, TypeComment, ResponseComments))


-- MODEL


type alias Comment = 
    { photoId : String
    , text : String
    , userId : String
    }

-- Use photo recognition to prevent nude photos
type alias Model = 
    { isLiked : Bool
    , comments : List Comment -- The list of comments
    , comment : String -- The comment to be posted
    , isEditing : Bool
    -- Use spam recognition to prevent spamming
    , ghostID : String
    , ghostComment : Comment -- Temporary store the comment to be edited
    , errorEditTextEmpty : String -- Error display if the edit text is empty
    , photoUrl : String
    , photoID : String
    , newComments : List(CommentID, Comment)
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
    , photoUrl = ""
    , photoID = ""
    , newComments = []
    }


-- MSG


type alias PhotoID 
    = String

type alias CommentID
    = String

type Msg
    = Like
    | AddComment String
    | TypeComment String
    | DeleteComment Comment
    | EditComment CommentID Comment -- Trigger edit
    | EditingComment String -- Input value is changing
    | CancelEdit Comment 
    | SubmitEdit Comment
    | ResponseComments (List(CommentID, Comment))



