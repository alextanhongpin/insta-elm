port module Page.Profile.State exposing (update, requestPhotos, responsePhotos)

import Page.Profile.Types exposing (Model, PhotoInfo, Msg(NavigateTo, UploadFile, ResponsePhotos))
-- import Navigation

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        --NavigateTo url -> 
        --    (model, Navigation.newUrl url)
        NavigateTo id ->
            (model, Cmd.none)

        UploadFile id ->
            (model, uploadFile id)

        ResponsePhotos output ->
            let
                --keys = response
                --    |> List.map .key

                --objs = response
                --    |> List.map .data

                --output = List.map2 (,) keys objs
                photos = model.photos
                uniqueIds = photos
                    |> List.map Tuple.first

                filteredOutput = List.filter (\(a, b) -> not (List.member a uniqueIds)) output
                outputphotos = photos ++ filteredOutput
            in
                ({ model | photos = outputphotos }, Cmd.none)


-- PUB


port uploadFile : String -> Cmd msg
port requestPhotos : () -> Cmd msg


-- SUB


port responsePhotos : (List (String, PhotoInfo) -> msg) -> Sub msg

