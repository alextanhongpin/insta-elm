module Page.Feed.State exposing (update)

import Page.Feed.Types exposing (..)
import Molecule.Photo.Types exposing (PhotoMsg(..))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        GoToTopic topicID ->
            (model, Cmd.none)

        PhotoAction childMsg ->
            case childMsg of
                PublicAll photos ->
                    ({ model | photos = photos }, Cmd.none)
        GoTo topic id ->
            model ! []