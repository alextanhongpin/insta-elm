port module Page.Profile.State exposing (..)

import Page.Profile.Types exposing (Model, PhotoInfo, Msg(..))
import Port.Profile exposing (..)

-- import Navigation

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        --NavigateTo url -> 
        --    (model, Navigation.newUrl url)
        NavigateTo id ->
            (model, Cmd.none)

        UploadFile nodeID photoInfo ->
            (model, uploadFile (nodeID, photoInfo))

        ProfilePhoto id ->
            (model, profilePhoto id)

        ProfilePhotoSuccess photoURL ->
            ({ model | photoURL = photoURL}, Cmd.none)

        --ResponsePhotos output ->
        --    let
        --        photos = model.photos
        --        uniqueIds = photos
        --            |> List.map Tuple.first

        --        filteredOutput = List.filter (\(a, b) -> not (List.member a uniqueIds)) output
        --        outputphotos = photos ++ filteredOutput
        --    in
        --        ({ model | photos = outputphotos }, Cmd.none)

        Progress progress ->
            ({ model | progress = progress}, Cmd.none)

        UploadProgress progress ->
            ({ model | uploadProgress = progress }, Cmd.none)

        Caption caption ->
            ({ model | alt = caption}, Cmd.none)

        ToggleEditProfile ->
            ({ model | enableEditProfile = not model.enableEditProfile }, Cmd.none)

        SubmitEdit ->
            (model, Port.Profile.setDisplayName model.ghostDisplayName)

        DisplayName name ->
            ({ model | ghostDisplayName = name}, Cmd.none)

        SetDisplayNameSuccess name -> 
            ({ model | displayName = name, ghostDisplayName = "", enableEditProfile = False }, Cmd.none)

        PhotoCountSuccess count ->
            ({ model | count = count}, Cmd.none)

        _ ->
            model ! []
-- PUB


port uploadFile : (String, PhotoInfo) -> Cmd msg
port profilePhoto : String -> Cmd msg
port requestPhotos : () -> Cmd msg


-- SUB


port responsePhotos : (List (String, PhotoInfo) -> msg) -> Sub msg
port profilePhotoSuccess : (String -> msg) -> Sub msg
port progress : (Float -> msg) -> Sub msg
port uploadProgress : (Float -> msg) -> Sub msg
