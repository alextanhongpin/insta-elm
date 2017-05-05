port module Page.Register.State exposing (update, onRegistered)

import Page.Register.Types exposing (Msg(Register, OnInputEmail, OnInputPassword), Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Register ->
            (model, Cmd.batch [ register model, Cmd.none ])

        OnInputEmail newEmail -> 
            ({ model | email = newEmail }, Cmd.none)

        OnInputPassword newPassword ->
            ({ model | password = newPassword }, Cmd.none)


-- PUB

-- Pass in the model for registration
port register : Model -> Cmd msg


port onRegistered : (String -> msg) -> Sub msg

-- SUB