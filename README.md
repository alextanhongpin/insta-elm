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
-- PUBLISH TO JS
port setStorage : Model -> Cmd msg


-- SUBSCRIBE FROM JS
port onStorageSet : (String -> msg) -> Sub msg


update msg model =
  case msg of
    AnActionThatWillTriggerTheJSSubscriber value -> 
      ({ model | key1 = value1 }, Cmd.batch [ setStorage model, Cmd.none ] )
    ListeningToIndexJsPublisher value ->
      ({ model | key2 = value2 }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ onStorageSet ListeningToIndexJsPublisher
    ]
```

```js

var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'))

// Subscribe to setStorage
app.ports.setStorage.subscribe(function (valueFromElmModel) {
    // doSomething()
})

// Publish to onStorageSet 
app.ports.onStorageSet.send(valueToSendToElm)


```