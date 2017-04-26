module Page.Login.State exposing (..)

import Page.Login.Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login -> 
            (model, Cmd.none)
        OnInputEmail newEmail -> 
            ({ model | email = newEmail }, Cmd.none)
