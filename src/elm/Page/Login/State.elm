module Page.Login.State exposing (..)

import Page.Login.Types exposing (Model, Msg(Login, OnInputEmail, OnInputPassword, OnSubmitLogin))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login -> 
            (model, Cmd.none)

        OnInputEmail newEmail -> 
            ({ model | email = newEmail }, Cmd.none)

        OnInputPassword newPassword ->
            ({ model | password = newPassword }, Cmd.none)

        OnSubmitLogin ->
            if .email model == "john.doe@mail.com" &&
               .password model == "123456" then 
                ({ model | hint = ""
                         , isAuthorized = True
                         , password = ""
                         , email = "" }, Cmd.none)
            else 
                ({ model | hint = "invalid", isAuthorized = False }, Cmd.none)
