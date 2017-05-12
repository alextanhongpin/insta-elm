module Page.Topic.View exposing (view)


-- HTML


import Html exposing (Html, br, div, text, h3, h4, input, button, textarea)
import Html.Attributes exposing (class, type_, placeholder)
import Router.Types exposing (Route(..))

-- ATOM


import Atom.Icon.View as Icon exposing (view)


-- MOLECULE


import Molecule.Post.View as PostView exposing (view)


-- PAGE


import Page.Topic.Types exposing (Model, Msg(..))


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "page page-topic" ]
        [ div [ class "container col-8" ] 
            [ h3 [ class "h3" ] [ text model.topic ]
            , h4 [ class "h4"] [ text ("Everything about " ++ model.topic)] 

            
            -- BR
            , div [ class "br br-200" ] []


            , div [ class "form-topic" ]
                [ input [ type_ "text", placeholder "Enter title" ] []
                , textarea [ class "form-topic__textarea", placeholder "Enter Topic" ] []
                , input [ type_ "file" ] []
                , Icon.view "add_a_photo"
                , button [ class "" ] [ text "Submit" ]
                ]


            -- BR
            , div [ class "br br-200" ] []


            , div [ class "posts"]
                [ postViewWrapper model.topic "name"
                , postViewWrapper model.topic "a"
                , postViewWrapper model.topic "b"
                ]
            ]
            , div [] [ text "show more" ]
        ]


-- SUBVIEW


postViewWrapper : String -> String -> Html Msg
postViewWrapper topic url = 
    div []
        [ PostView.view (PostRoute topic url) (GoTo topic url)
        , div [ class "br br-100" ] []
        ]







