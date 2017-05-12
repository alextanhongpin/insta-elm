module Molecule.Comment.Types exposing (Comment, CommentID, CommentMsg(..), CommentEditMsg(..))


-- MODEL


type alias Comment = 
    { photoId : String
    , text : String
    , userId : String
    }


type alias CommentID = String
type alias Text = String


-- MSG


-- CRUD Msg
type CommentMsg
    = Create Text -- Create a comment
    | All (List(CommentID, Comment)) -- Get a list of comments
    | Update CommentID Comment -- Update a comment
    | UpdateCallback (CommentID, Comment) -- Callback when update is completed (async)
    | Delete CommentID Comment -- Delete a comment
    | DeleteCallback CommentID -- Callback when delete is completed (async)
    -- UI Msg
    | InputComment Text -- User types in the comment field

-- UI Msg
type CommentEditMsg
    = Edit CommentID Comment -- User clicks on edit comment
    | InputEdit String -- User types in the edit comment field
    | Cancel Comment -- User cancels the edit

