module Page.Topics.View exposing (view)

import Page.Topics.Types exposing (Model, Msg(..))

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href, style)

import Color exposing (..)
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


colorToCssRgb : Color.Color -> String
colorToCssRgb color =
    let
        rgb = Color.toRgb(color)
    in
        "rgb(" ++ toString(rgb.red) ++ "," ++ toString(rgb.green) ++ "," ++ toString(rgb.blue) ++ ")"

hslColorToCssRgb : Color.Color -> String
hslColorToCssRgb color =
    let
        rgb = Color.toRgb(color)
    in
        "rgb(" ++ toString(rgb.red) ++ "," ++ toString(rgb.green) ++ "," ++ toString(rgb.blue) ++ ")"



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "page page-topics" ]
        [ div [] (topics 
                |> List.sort
                |> List.indexedMap (,)
                |> List.map listView
        )
    ]


colorGenerator : (Int, Int) -> String
colorGenerator (length, index) =
    let 
        multiplier = floor(toFloat(360) / toFloat(length))
        degree = toFloat(multiplier * index)
    in
        hslColorToCssRgb(Color.hsl (degrees degree) 1 0.75)


listView : (Int, String) -> Html Msg
listView (id, content) =
    a 
    [ class "topic"
    , href (reverseRoute (TopicRoute (String.toLower content)))
    , onClickPreventDefault (GoToTopic (String.toLower content))]
    [ div 
        [ class "topic-image"
        , style [ ("background-color", colorGenerator((List.length topics), id))]
        ]
        [ text content ]
    , div [ class "br br-100" ] []
    , div [ class "topic-content" ] [ text (toString(id) ++ content ++ toString(List.length topics)) ]
    , div [] [ text "No topics yet" ]
    , div [ class "br br-100" ] []
    ]