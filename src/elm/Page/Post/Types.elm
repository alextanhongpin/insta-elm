module Page.Post.Types exposing (Model, Comment, CommentID, model, Msg(..))

import Dom exposing (..)
-- MODEL 


type alias Model =
    { comment : String
    , comments : List (CommentID, Comment)
    , showEdit : Bool
    , isEditing: Bool
    , editIndex : String
    , ghostComment : Comment
    , error : Maybe String
    , owner : String
    }


model : Model
model =
    { comment = ""
    , comments =
        [ ("1", Comment "John Doe" "thios is aweomse" False)
        , ("2", Comment "Axel F" "Crazy Frog!" False)
        , ("3", Comment "Haha" "Damn!" False)
        ]
    , showEdit = False
    , isEditing = False
    , editIndex = ""
    , ghostComment = Comment "" "" False
    , error = Nothing
    , owner = ""
    }


type alias Comment =
    { name : String
    , text : String
    , isEdited : Bool }

type alias CommentID = String

-- MSG


type Msg
    = OnKeyDown Int
    | NoOp
    | OnInputComment String
    | ToggleEdit CommentID
    | OnEdit CommentID
    | OnTypeEdit String
    | OnSubmitEdit Int
    | OnCancelEdit
    | OnDelete CommentID
    | OnBlurEditMenu
    | FocusOn String
    | FocusResult (Result Dom.Error())






