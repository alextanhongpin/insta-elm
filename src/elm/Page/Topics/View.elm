module Page.Topics.View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


-- ATOM

import Atom.Color as Color exposing (..)
import Atom.Break.View exposing (br1, br2, br3)

import Page.Topics.Types exposing (Model, Msg(..))


-- ROUTER


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(TopicRoute))


-- VIEW 

type alias Topic =
    { id : String
    , title : String
    , description : String 
    }


topics : List String
topics = ["Computer", "Software", "Hardware", "Apple", "Android", "Mobile Phones and Tablet", "Photography, Digital Imaging and Video", "Codemasters","Open Source", "Arts & Design", "Musician", "Property Talk", "Finance, Business and Investment House", "Real World Issues", "Education Essentials", "Job & Careers", "Brides & Groom", "Pregnancy & Parenting", "Health & Fitness", "Grab & Uber", "Movies and Music", "Anime", "Dota2", "Console Couches", "Kopitiam", "Cupid's Corner", "Pets", "The Sports Channel", "Football", "Hobbies, Collectibles and Model Kits", "Travel & Living", "Girl's Forum", "Men's Style and Fashion"]


classifieds : List String
classifieds = [ "Job enlistment", "Properties", "Business for Sale", "Services Noticeboard", "Events and gatherings" ]


-- VIEW


view : Model -> Html Msg
view model =
    let
        topicLen = List.length topics
        topicLabel = if topicLen == 1 then "topic" else "topics"

        filteredTopics 
            = topics 
            |> List.sort
            |> List.indexedMap (,)
            |> List.filter (\(_, a) -> String.contains (model.query) (String.toLower a))

        filteredTopicsLen = List.length filteredTopics
    in
        div [ class "page page-topics" ]
            [ div [ class "container col-10"]
                [ br2
                , br2
                , div [ class "form-search-topic" ]
                    [ input
                        [ class "input-search-topic"
                        , type_ "search"
                        , placeholder "Search a group..."
                        , onInput Search
                        , value model.query ] []
                    ]
                , br2
                , br2
                , div [ class "topic-count" ] [ text (toString(filteredTopicsLen) ++ " out of " ++ toString(topicLen) ++ " " ++ topicLabel) ]
                , div [ class "topics" ] (List.map listView filteredTopics)

                , if filteredTopicsLen == 0 then
                    div [] [ text "There are no content that matches the keyword" ]
                else
                    span [] []
                , br2
                , br2
                , br2
            ]
        ]


-- SUBVIEW


listView : (Int, String) -> Html Msg
listView (id, content) =
    div [ class "topic-wrapper" ] 
        [ a 
            [ class "topic"
            , href (reverseRoute (TopicRoute (String.toLower content)))
            , onClickPreventDefault (GoToTopic (String.toLower content))]
            [ div 
                [ class "topic-image"
                , style [ ("background-color", Color.generate((List.length topics), id))]
                ]
                [ text content ]
            , div [ class "br br-100" ] []
            -- , div [ class "topic-content" ] [ text (toString(id) ++ content ++ toString(List.length topics)) ]
            -- , div [] [ text "No topics yet" ]
            , div [] [ text "Description" ]
            , div [ class "br br-100" ] []
            ]
    ]












