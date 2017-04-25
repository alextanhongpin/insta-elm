module View exposing (..)

import Html exposing (..)
import Html.Events exposing ( onClick )
import Types exposing (..)


-- ATOMS
import Atom.Header exposing ( app_header )


-- MOLECULES
import Molecule.Card exposing ( card )


-- VIEW

-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [] [
    app_header,
    button [ onClick FetchService ] [ text "Fetch service" ],
    div [ ] [ text model.metadata.title ],
    div [ ] [ text model.metadata.body ],
    div [ ] [ text (toString(model.metadata.id)) ],
    div [ ] [ text (toString(model.metadata.userId)) ],
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
