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

app.ports.dispatchGreet.subscribe(function (greet) {
  console.log('Listening to dispatch greet:', greet)
  app.ports.subscribeGreet.send('this is random')
})

app.ports.authenticate.subscribe(function () {
  var config = {
    // Place config here

  }
  firebase.initializeApp(config)

  firebase.auth().onAuthStateChanged(function (user) {
    console.log(user)
    if (user) {
      app.ports.onAuthenticateStateChange.send('success')
      var displayName = user.displayName
      var email = user.email
      var emailVerified = user.emailVerified
      var photoURL = user.photoURL
      var isAnonymous = user.isAnonymous
      var uid = user.uid
      var providerData = user.providerData
    } else {
      app.ports.onAuthenticateStateChange.send('fail')
    }
  })
})
