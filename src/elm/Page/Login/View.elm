module Page.Login.View exposing (..)

import Html exposing (Html, br, button, div, form, input, text, label)
import Html.Attributes exposing (placeholder, value, class, type_, id, for)
import Html.Events exposing (onClick, onInput)
import Routing exposing (onClickPreventDefault)


-- ATOMS




-- PAGES


import Page.Login.Types exposing (Model, Msg(OnInputEmail, OnInputPassword, OnSubmitLogin))


view : Model -> Html Msg
view model =
    div [ class "page page--login" ] 
        [ div [ class "page-title"] [ text "Login to Continue" ]
        , form [] 
            [ div [ class "hint hint--error" ] [ text model.hint ]
            , inputGroupLogin model
            , br [] []
            , passwordGroupLogin model
            , br [] []
            , br [] []
            , button [ onClickPreventDefault OnSubmitLogin ] [ text "Submit" ]

        ]
    ]


inputGroupLogin : Model -> Html Msg
inputGroupLogin model = 
    div [] 
        [ div [] [ label [ for "email" ] [ text "Email" ] ]
        , div [] 
            [ input [ placeholder "Enter email"
            , id "email"
            , type_ "email"
            , onInput OnInputEmail
            , value model.email ] [] 
        ]
    ]

passwordGroupLogin : Model -> Html Msg
passwordGroupLogin model = 
    div [] 
        [ div [] [ label [ for "password" ] [ text "Password" ] ]
        , div [] 
            [ input [ placeholder "Enter password"
            , id "password"
            , type_ "password"
            , onInput OnInputPassword
            , value model.password ] [] 
            ]
    ]