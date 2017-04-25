# insta-elm
Simple app to understand the elm architecture

If you are using external libraries (moment.js, firebase, i18n etc), you have
to use ports as Elm doesn't support it.

Ports can be confusing at first. Here's a few key concepts to understand:

1. Ports is similar to a pub/sub system, with the commands named `subscribe` and `send` respectively.
2. In order to use ports, you have to declare `port module Main exposing (..)` at the top of your file.
3. You can declare multiple ports in the same file.
4. On the `index.js` (the compiled js), you subscribe to the events that are published through the `update` method using a `Cmd`
5. On the `index.js`, you can publish back to the `Main.elm` through the command `.send(args)`
6. On the `Main.elm`, you can publish the `model` (or any Elm data types) through a `Cmd`
7. On the `Main.elm`, you subscribe to the `index.js` publisher though a `Sub`
8. You have to use `Html.program` in order to subscribe to events from the `index.js`

```elm
{-- PUBLISH TO JS
    * this is the name of the event that you will subscribe to in index.js
    * in this example, we want to send a model to the index.js
--} 
port setStorage : Model -> Cmd msg


{-- SUBSCRIBE FROM JS
    * this is the name of the listener that you will publish to in index.js
    * in this example, we want to receive a string from the index.js
--}
port onStorageSet : (String -> msg) -> Sub msg


update msg model =
  case msg of
    -- The action that will trigger the subscriber in index.js
    PublishToJSFile value -> 
      ({ model | key1 = value1 }, Cmd.batch [ setStorage model, Cmd.none ] )
    SubscribeToJSFile value ->
      ({ model | key2 = value2 }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ onStorageSet SubscribeToJSFile
    ]
```

```js

var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'))

// Subscribe to setStorage
app.ports.setStorage.subscribe(function (valueFromElmModel) {
    // doSomething()
    // Publish to onStorageSet 
    app.ports.onStorageSet.send('valueToSendToElm')
})
```

## Http Request

Making http request in Elm is simple.

```elm

import Http
import Json.Decode as Decode


-- GET JSON


getMetadata : Http.Request Metadata
getMetadata =
  Http.get "https://example.api/endpoint" decodeMetadata

type alias Metadata =
  { author : String
  , pages: Int
  }

decodeMetadata : Decode.Decoder Metadata
decodeMetadata = 
  Decode.map2 Metadata -- If you need to map 4 items, use map4
    (Decode.field "author" Decode.string)
    (Decode.field "pages" Decode.int)


-- SEND REQUESTS

type Msg
  = LoadMetadata (Result Http.Error Metadata)


send : Cmd Msg
send = 
  Http.send LoadMetadata getMetadata
```
