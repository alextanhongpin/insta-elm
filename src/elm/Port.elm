-- This program contains the global ports, as well as
-- subscriptions for the Main.elm

port module Port exposing (..)

import Types exposing (..)

import Mouse exposing (..)
-- MOLECULE


import Molecule.Comment.Types as CommentTypes exposing (CommentMsg(..))
import Molecule.Photo.Types as MPhotoTypes exposing(PhotoMsg(..))

import Molecule.Comment.Port as CommentPort exposing (..)
import Molecule.Photo.Port as PhotoPort exposing (..)



-- TYPES


import Page.Photo.Types as PhotoTypes
import Page.Profile.Types as ProfileTypes
import Page.Login.Types as LoginTypes
import Page.Feed.Types as FeedTypes


-- STATE


import Page.Login.State as LoginState
import Page.Profile.State as ProfileState
import Page.Register.State as RegisterState

import Port.Profile as ProfilePort exposing (..)

-- PUB


port authenticate : () -> Cmd msg
port signOut : () -> Cmd msg


-- SUB


port authenticateSuccess : (LoginTypes.User -> msg) -> Sub msg
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
    

    -- Login Page


    , Sub.map LoginPageMsg (LoginState.loginSuccess LoginTypes.LoginSuccess)
    , Sub.map LoginPageMsg (LoginState.loginError LoginTypes.LoginError)
    

    -- Profile Page


    , Sub.map ProfilePageMsg (ProfileState.responsePhotos ProfileTypes.ResponsePhotos)
    , Sub.map ProfilePageMsg (ProfileState.profilePhotoSuccess ProfileTypes.ProfilePhotoSuccess)
    , Sub.map ProfilePageMsg (ProfileState.progress ProfileTypes.Progress)
    , Sub.map ProfilePageMsg (ProfileState.uploadProgress ProfileTypes.UploadProgress)
    -- TODO: Instead of success, use callback
    , Sub.map ProfilePageMsg (ProfilePort.setDisplayNameSuccess ProfileTypes.SetDisplayNameSuccess)
    , Sub.map ProfilePageMsg (PhotoPort.photoCountSuccess ProfileTypes.PhotoCountSuccess)
    

    -- Photo Page


    , Sub.map PhotoPageMsg (PhotoPort.responsePhoto PhotoTypes.ResponsePhoto)
    , Sub.map PhotoPageMsg (PhotoPort.deletePhotoSuccess PhotoTypes.DeletePhotoSuccess)
    , Sub.map PhotoPageMsg (CommentPort.responseComments (PhotoTypes.CommentAction << CommentTypes.All))
    , Sub.map PhotoPageMsg (CommentPort.deleteCommentSuccess (PhotoTypes.CommentAction << CommentTypes.DeleteCallback))
    , Sub.map PhotoPageMsg (CommentPort.updateCommentSuccess (PhotoTypes.CommentAction << CommentTypes.UpdateCallback))


    -- Feed Page


    , Sub.map FeedPageMsg (PhotoPort.responsePublicPhotos (FeedTypes.PhotoAction << MPhotoTypes.PublicAll))
    , Mouse.clicks (\a -> OnMouseClick a)
    ]

