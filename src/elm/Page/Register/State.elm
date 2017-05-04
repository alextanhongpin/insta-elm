module Page.Register.State exposing (update)

import Page.Register.Types exposing (Msg(Register), Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Register ->
            (model, Cmd.none)