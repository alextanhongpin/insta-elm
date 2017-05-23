-- This program contains the global ports, as well as
-- subscriptions for the Main.elm

port module Port exposing (..)

import Types exposing (..)

-- import Mouse exposing (..)

-- MOLECULE


import Molecule.Comment.Types as CommentTypes exposing (CommentMsg(..))
import Molecule.Photo.Types as MPhotoTypes exposing(PhotoMsg(..))
import Molecule.User.Types exposing (User)
import Molecule.Post.Types as PostTypes exposing (..)


import Molecule.Comment.Port as CommentPort exposing (..)
import Molecule.Photo.Port as PhotoPort exposing (..)
import Molecule.Post.Port as PostPort exposing (..)



-- TYPES


import Page.Photo.Types as PhotoTypes
import Page.Topic.Types as TopicTypes
import Page.Profile.Types as ProfileTypes
import Page.Login.Types as LoginTypes
import Page.Feed.Types as FeedTypes


-- STATE


import Page.Login.State as LoginState
import Page.Profile.State as ProfileState
import Page.Register.State as RegisterState
import Page.Topic.State as TopicState
import Port.Profile as ProfilePort exposing (..)

-- PUB


port authenticate : () -> Cmd msg
port signOut : () -> Cmd msg


-- SUB


port authenticateSuccess : (User -> msg) -> Sub msg
port onAuthenticateStateChange : (String -> msg) -> Sub msg

-- A subscriber to get access token from the localStorage
port portSubscribeToken : (String -> msg) -> Sub msg
port logoutSuccess : (String -> msg) -> Sub msg


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onAuthenticateStateChange Authenticate
    , RegisterState.onRegistered RegisterCallback 
    , logoutSuccess LogoutSuccess
    , authenticateSuccess AuthenticateSuccess
    {-- This is a bit tricky:
      We map the Child subscription to the childMsg first
      which will be the parameters for loginPageMsg
    --}
    

    -- LOGIN PAGE


    , Sub.map LoginPageMsg (LoginState.loginSuccess LoginTypes.LoginSuccess)
    , Sub.map LoginPageMsg (LoginState.loginError LoginTypes.LoginError)
    

    -- PROFILE PAGE


    -- , Sub.map ProfilePageMsg (ProfileState.responsePhotos ProfileTypes.ResponsePhotos)
    , Sub.map ProfilePageMsg (ProfileState.profilePhotoSuccess ProfileTypes.ProfilePhotoSuccess)
    , Sub.map ProfilePageMsg (ProfileState.progress ProfileTypes.Progress)
    , Sub.map ProfilePageMsg (ProfileState.uploadProgress ProfileTypes.UploadProgress)
    -- TODO: Instead of success, use callback
    , Sub.map ProfilePageMsg (ProfilePort.setDisplayNameSuccess ProfileTypes.SetDisplayNameSuccess)
    , Sub.map ProfilePageMsg (PhotoPort.photoCountSuccess ProfileTypes.PhotoCountSuccess)
    

    -- PHOTO PAGE


    , Sub.map PhotoPageMsg (PhotoPort.responsePhoto PhotoTypes.ResponsePhoto)
    , Sub.map PhotoPageMsg (PhotoPort.deletePhotoSuccess PhotoTypes.DeletePhotoSuccess)
    , Sub.map PhotoPageMsg (CommentPort.responseComments (PhotoTypes.CommentAction << CommentTypes.All))
    , Sub.map PhotoPageMsg (CommentPort.deleteCommentSuccess (PhotoTypes.CommentAction << CommentTypes.DeleteCallback))
    , Sub.map PhotoPageMsg (CommentPort.updateCommentSuccess (PhotoTypes.CommentAction << CommentTypes.UpdateCallback))


    -- FEED PAGE


    -- NOTE: Even after commenting, you should remove the Cmd from the respective route. Here we are only hiding the response sub
    -- , Sub.map FeedPageMsg (PhotoPort.responsePublicPhotos (FeedTypes.PhotoAction << MPhotoTypes.PublicAll))
    --, Mouse.clicks (\a -> OnMouseClick a)

    -- TOPIC PAGE


    , Sub.map TopicPageMsg (PostPort.responseTopics (TopicTypes.TopicAction << PostTypes.All))
    ]

