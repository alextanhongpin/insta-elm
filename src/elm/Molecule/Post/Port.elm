port module Molecule.Post.Port exposing (..)


import Molecule.Post.Types exposing (PostID, Post, TopicID, Topic)


-- PUB


port requestPosts : () -> Cmd msg -- GET /topics
port createPost : Post -> Cmd msg
port createTopic : Topic -> Cmd msg

-- SUB


port responsePosts : (List(PostID, Post) -> msg) -> Sub msg -- GET /topics response
port responseTopics : (List(TopicID, Topic) -> msg) -> Sub msg