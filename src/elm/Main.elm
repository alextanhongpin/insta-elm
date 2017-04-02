port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example
import Components.Hello exposing ( hello )


import Msgs exposing ( .. )
import Model exposing ( .. )
-- ATOMS
import Atom.Header exposing ( app_header )


-- MOLECULES
import Molecule.Card exposing ( card )


-- APP


main : Program Never Model Msg
main =
  Html.program 
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL



model : Model
model = 
  { comment = "Hello"
  , fromPort = ""
  }

init : (Model, Cmd Msg)
init = (model, Cmd.none)


-- UPDATE



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> 
      (model, Cmd.none)

    -- the setStorage is port that is responsible for sending a model to the index.html
    OnChange a -> 
      ({ model | comment = a }, Cmd.batch [ setStorage model, Cmd.none ] )

    -- listen to the external port
    OnStorageSet a ->
      ({ model | fromPort = a }, Cmd.none)

-- SUBSCRIPTIONS


-- Pub


port setStorage : Model -> Cmd msg


-- Sub


port onStorageSet : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onStorageSet OnStorageSet
    ]


-- VIEW


-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [] [
    app_header,
    br [] [],
    card model
  ]


-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }

