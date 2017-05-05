module Page.Profile.View exposing (view)

import Html exposing (Html, a, b, br, div, span, text, input, img)
import Html.Attributes exposing (class, href, type_, id, src, width, height)
import Html.Events exposing (on)
import Json.Decode as Json


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(PhotoRoute))

-- VIEW
import Page.Profile.Types exposing (Model, PhotoInfo, Msg(NavigateTo, UploadFile))

view : Model -> Html Msg
view model =
    div [ class "page page--profile" ] 
        [ user model
        ]


-- SUBVIEW


user : Model -> Html Msg
user model =
    div [ class "user" ] 
        [ br [] []
        , div [ class "user-photo" ] [ ]
        , br [] []
        , b [] [ text model.displayName ]
        , b [] [ text model.email ]
        , div [] 
            [ div [] [ text "Upload Photo" ]
            , input [ id "uploader", type_ "file", on "change" (Json.succeed (UploadFile "uploader")) ] []
            ]
        , div [] 
            [ span [] [ text "101 Followers" ]
            , span [] [ text " " ] 
            , span [] [ text "100 Photos" ]
            ]
        , div [] (List.map photoView model.photos)
        -- , div [] (List.map grids ["1", "2", "3", "4", "5", "6"])
    ]

photoView : (String, PhotoInfo) -> Html Msg
photoView (key, data) =
    let 
        url = reverseRoute (PhotoRoute key)
    in
        a [ id key
          , href url 
          , onClickPreventDefault (NavigateTo key)
          ] [ img [ class "grid", src data.photoUrl ] []
            ]


--grids : String -> Html Msg
--grids str =
--    let
--        url = reverseRoute (PhotoRoute str)
--    in
--        a [ class "grid"
--          , href url
--          , onClickPreventDefault (NavigateTo url)
--         ] [ text str ]




