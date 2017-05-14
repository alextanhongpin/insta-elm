module Atom.Color exposing (..)


import Color exposing (..)


-- Generate an rgba string color
generate : (Int, Int) -> String
generate (length, index) =
    let 
        multiplier = floor(toFloat(360) / toFloat(length))
        degree = toFloat(multiplier * index)
    in
        hslColorToCssRgb(Color.hsl (degrees degree) 1 0.75)


colorToCssRgb : Color.Color -> String
colorToCssRgb color =
    let
        rgb = Color.toRgb(color)
    in
        "rgb(" ++ toString(rgb.red) ++ "," ++ toString(rgb.green) ++ "," ++ toString(rgb.blue) ++ ")"


hslColorToCssRgb : Color.Color -> String
hslColorToCssRgb color =
    let
        rgb = Color.toRgb(color)
    in
        "rgb(" ++ toString(rgb.red) ++ "," ++ toString(rgb.green) ++ "," ++ toString(rgb.blue) ++ ")"

