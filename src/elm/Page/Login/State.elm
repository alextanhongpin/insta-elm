port module Page.Login.State exposing (update, loginSuccess, loginError)

import Page.Login.Types exposing (User, Model, Msg(Login, LoginSuccess, LoginError, OnInputEmail, OnInputPassword, OnSubmitLogin))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login -> 
            (model, Cmd.batch [ login model, Cmd.none ])
        
        LoginError error ->
            ({ model | error = error }, Cmd.none)
        
        OnInputEmail newEmail -> 
            ({ model | email = newEmail }, Cmd.none)

        OnInputPassword newPassword ->
            ({ model | password = newPassword }, Cmd.none)

        OnSubmitLogin ->
            if .email model == "john.doe@mail.com" &&
               .password model == "123456" then 
                ({ model | error = ""
                         , isAuthorized = True
                         , password = ""
                         , email = "" }, Cmd.none)
            else 
                ({ model | error = "invalid", isAuthorized = False }, Cmd.none)

        _ ->
            (model, Cmd.none)

-- PUB


port login : Model -> Cmd msg


-- SUB


port loginSuccess : (User -> msg) -> Sub msg
port loginError : (String -> msg) -> Sub msg
