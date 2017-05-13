module Page.Login.View exposing (..)

import Html exposing (Html, br, button, div, form, input, text, label)
import Html.Attributes exposing (placeholder, value, class, type_, id, for, disabled)
import Html.Events exposing (onClick, onInput)
import Router.Main exposing (onClickPreventDefault)

-- PAGES
import Atom.Input.Types as InputModel exposing (Model)
import Atom.Input.View as Input exposing (view)

import Page.Login.Types as LoginTypes exposing (Model, Msg(Login, OnInputEmail, OnInputPassword))


view : LoginTypes.Model -> Html Msg
view model =
    let
        hasEmail
            = model.email
            |> String.trim
            |> String.isEmpty
        hasPassword 
            = model.password
            |> String.trim
            |> String.isEmpty

        buttonText = if model.hasSubmitLogin then "Loading..." else "Continue"


        isButtonDisabled = if model.hasSubmitLogin then True else hasPassword || hasEmail

        emailInput = Input.view (InputModel.Model "email" "Email" "Enter email" "email")
        passwordInput = Input.view (InputModel.Model "password" "Password" "Enter password" "password")


    in
        div [ class "page page-login" ] 
            [ div [ class "container col-4"]
                [ div [ class "br br-200" ] []
                , div [ class "page-title"] [ text "Login to Continue" ]
                
                -- BR
                , div [ class "br br-200" ] []

                , form [] 
                    [ div [ class "br br-200" ] []

                    , emailInput OnInputEmail model.email
                    , passwordInput OnInputPassword model.password
                    -- , inputGroupLogin model
                    -- , passwordGroupLogin model
                    
                    -- BR
                    , div [ class "br br-50" ] []

                    , div [ class "hint is-error" ] [ text model.error ]
                    -- BR
                    , div [ class "br br-200" ] []

                    , button [ class "button", onClickPreventDefault Login, disabled isButtonDisabled ] [ text buttonText ]
                ]
            ]
        ]


--inputGroupLogin : LoginTypes.Model -> Html Msg
--inputGroupLogin model = 
--    div [ class "input-group" ] 
--        [ div [ class "br br-50" ] []
--        , div []
--            [ label 
--                [ class "input-group__label"
--                , for "email" ] 
--                [ text "Email" ] 
--                ]
--        , div [] 
--            [ input 
--                [ class "input-group__input"
--                , placeholder "Enter email"
--                , id "email"
--                , type_ "email"
--                , onInput OnInputEmail
--                , value model.email 
--                ] [] 
--        ]
--    ]

--passwordGroupLogin : LoginTypes.Model -> Html Msg
--passwordGroupLogin model = 
--    div [ class "input-group" ] 
--        [ div [ class "br br-50" ] []
--        , div []
--            [ label 
--                [ class "input-group__label"
--                , for "password" ] 
--                [ text "Password" ] 
--                ]
--        , div [] 
--            [ input 
--                [ class "input-group__input"
--                , placeholder "Enter password"
--                , id "password"
--                , type_ "password"
--                , onInput OnInputPassword
--                , value model.password 
--                ] [] 
--        ]
--    ]