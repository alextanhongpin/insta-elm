{--Port.Photo is a program that contains the port definitions for photo related
firebase connection
--}

port module Molecule.Photo.Port exposing (..)


-- MODEL


import Molecule.Photo.Types exposing (Photo, PhotoID)


-- PUB 


port photoCount : () -> Cmd msg
port deletePhoto : PhotoID -> Cmd msg
port requestPhoto : PhotoID -> Cmd msg
port requestPublicPhotos : () -> Cmd msg


-- SUB


port photoCountSuccess : (Int -> msg) -> Sub msg
port deletePhotoSuccess : (PhotoID -> msg) -> Sub msg
port responsePhoto : ((PhotoID, Photo) -> msg) -> Sub msg
port responsePublicPhotos : (List(PhotoID, Photo) -> msg) -> Sub msg