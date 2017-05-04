
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