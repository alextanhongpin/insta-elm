port module Molecule.Comment.Port exposing (..)

import Molecule.Comment.Model exposing (Comment, CommentID)
import Model.Photo exposing (PhotoID)


-- PUB


port requestComments : PhotoID -> Cmd msg
port createComment :  Comment -> Cmd msg
port deleteComment : (CommentID, Comment) -> Cmd msg
port updateComment : (CommentID, Comment) -> Cmd msg


-- SUB


port responseComments : (List (CommentID, Comment) -> msg) -> Sub msg
port deleteCommentSuccess : (String -> msg) -> Sub msg
port updateCommentSuccess : ((CommentID, Comment) -> msg) -> Sub msg

