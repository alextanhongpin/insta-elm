module Page.Register.View exposing (view)

import Html exposing (Html, br, button, div, form, input, text, label)
import Html.Attributes exposing (placeholder, value, class, type_, id, for, disabled)
import Html.Events exposing (onClick, onInput)
import Router.Main exposing (onClickPreventDefault)


-- PAGES
import Atom.Input.Types as InputModel exposing (Model)
import Atom.Input.View as Input exposing (view)

import Page.Register.Types as RegisterTypes exposing (Model, Msg(Register, OnInputEmail, OnInputPassword))

view : RegisterTypes.Model -> Html Msg
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
        div [ class "page page-register" ] 
            [ div [ class "container col-4"]
                [ div [ class "br br-200" ] []
                , div [ class "page-title"] [ text "Create an account" ]
                
                -- BR
                , div [ class "br br-200" ] []

                , form [] 
                    [ div [ class "br br-200" ] []

                    , emailInput OnInputEmail model.email
                    , passwordInput OnInputPassword model.password

                    -- BR
                    , div [ class "br br-50" ] []

                    , div [ class "hint is-error" ] [ text model.error ]
                    -- BR
                    , div [ class "br br-200" ] []

                    , button [ class "button", onClickPreventDefault Register, disabled isButtonDisabled ] [ text buttonText ]
                ]
            ]
        ]
