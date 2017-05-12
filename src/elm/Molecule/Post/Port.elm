port module Molecule.Post.Port exposing (..)


import Molecule.Post.Types exposing (PostID, Post)


-- PUB


port requestPosts : () -> Cmd msg -- GET /topics
port createPost : Post -> Cmd msg

-- SUB


port responsePosts : (List(PostID, Post) -> msg) -> Sub msg -- GET /topics response