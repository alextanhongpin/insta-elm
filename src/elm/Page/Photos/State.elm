module Page.Photos.State exposing (update)

import Page.Photos.Types exposing (Model, Msg(..))

update : Msg -> Model -> (Model, Cmd Msg)

update msg model =
    case msg of
        Something ->
            model ! []
