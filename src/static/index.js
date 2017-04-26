// pull in desired CSS/SASS files
require('./styles/main.scss')
var $ = jQuery = require('../../node_modules/jquery/dist/jquery.js')           // <--- remove if jQuery not needed
require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js')   // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'))

// app.ports.Moment.send(0)
app.ports.setStorage.subscribe(function (word) {
  console.log('subscribe to login', word)
  const random = Math.random() > 0.5 ? 'Hello World 0123' : 'Goodbye world 456'
  app.ports.onStorageSet.send(random)
  app.ports.portSubscribeToken.send('asdio1i23lk1n')
})

