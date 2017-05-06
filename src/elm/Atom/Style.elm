{--Atom.Style contains helpers for css stylings--}

module Atom.Style exposing (imageCover)

-- imageCover takes the image source and renders a background image

type alias Src = String

imageCover : Src -> List (String, String)
imageCover src = 
      [ ( "background", "url(" ++ src ++ ") no-repeat center center / cover")
      ]

