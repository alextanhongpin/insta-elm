port module Molecule.Topic.Port exposing (..)


import Molecule.Topic.Types exposing (TopicID, Topic)


-- PUB


port requestTopics : () -> Cmd msg -- GET /topics
port createTopic : Topic -> Cmd msg

-- SUB


port responseTopics : (List(TopicID, Topic) -> msg) -> Sub msg -- GET /topics response