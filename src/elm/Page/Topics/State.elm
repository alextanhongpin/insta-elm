module Page.Topics.State exposing (update)

import Page.Topics.Types exposing (Model, Msg(..))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GoToTopic topic ->
            -- (model, Cmd.none)
            model ! []

        Search query ->
            { model | query = query } ! []