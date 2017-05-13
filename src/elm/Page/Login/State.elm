port module Page.Login.State exposing (update, loginSuccess, loginError)

import Page.Login.Types exposing (Model, Msg(Login, LoginSuccess, LoginError, OnInputEmail, OnInputPassword, OnSubmitLogin))
import Molecule.User.Types exposing (User)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login -> 
            { model | hasSubmitLogin = True } ! [ login model ]
            --(model, Cmd.batch [ login model, Cmd.none ])
        
        LoginError error ->
            ({ model | error = error, hasSubmitLogin = False }, Cmd.none)
        
        OnInputEmail newEmail -> 
            ({ model | email = newEmail }, Cmd.none)

        OnInputPassword newPassword ->
            ({ model | password = newPassword }, Cmd.none)

        -- TODO: To be removed
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
