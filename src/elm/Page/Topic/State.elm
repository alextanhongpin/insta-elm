module Page.Topic.State exposing (update)


import Page.Topic.Types exposing (Model, Msg(..))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Nth ->
            (model, Cmd.none)