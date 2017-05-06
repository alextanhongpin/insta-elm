{--Port.Profile is a program that contains the port definitions
for User related ports
--}

port module Port.Profile exposing (..)


type alias DisplayName = String

-- Send a display name to the js port
port setDisplayName : DisplayName -> Cmd msg

-- If successful, then get back the user name
port setDisplayNameSuccess : (DisplayName -> msg) -> Sub msg
