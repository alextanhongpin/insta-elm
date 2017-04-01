module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example
import Components.Hello exposing ( hello )


import Msgs exposing ( .. )

-- ATOMS
import Atom.Header exposing ( app_header )


-- MOLECULES
import Molecule.Card exposing ( card )


-- APP


main : Program Never Model Msg
main =
  Html.beginnerProgram 
  { model = model
  , view = view
  , update = update 
  }


-- MODEL


type alias Model = 
  { comment : String }

model : Model
model = 
  { comment = "Hello" }


-- UPDATE



update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    OnChange a -> { model | comment = a }


-- VIEW


-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [] [
    app_header,
    br [] [],
    card model.comment
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
