// pull in desired CSS/SASS files
require('./styles/main.scss')
var $ = jQuery = require('../../node_modules/jquery/dist/jquery.js')           // <--- remove if jQuery not needed
require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js')   // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'))

// Holds the firebase context model
var models = {}

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
var config = {
    // Place firebase config here

}
firebase.initializeApp(config)

app.ports.authenticate.subscribe(function () {
  firebase.auth().onAuthStateChanged(function (user) {
    console.log('onAuthStateChanged')
    console.log('Logged in as:', user)
    if (user) {
      var userRecord = {
        displayName: user.displayName || '',
        email: user.email || '',
        emailVerified: user.emailVerified || false,
        photoURL: user.photoURL || '',
        isAnonymous: user.isAnonymous || false,
        uid: user.uid || ''
      }
      app.ports.onAuthenticateStateChange.send('success')
      app.ports.authenticateSuccess.send(userRecord)
      var providerData = user.providerData
      models.photo = new Photo(firebase, user.uid, app.ports)
      models.comment = new Comment(firebase, user.uid, app.ports)
    } else {
      // Reset
      Object.keys(models).forEach(function (key) {
        models[key] = null
      })
      app.ports.onAuthenticateStateChange.send('fail')
    }
  })
})

app.ports.register.subscribe(function (user) {
  firebase.auth().createUserWithEmailAndPassword(user.email, user.password).catch(function (error) {
    // Handle Errors here.
    var errorCode = error.code
    var errorMessage = error.message
    // app.ports.onRegisterError.send()
    // ...
  }).then(function (data) {
    console.log('Registered success', data)
    app.ports.onRegistered.send('success')
  })
})

app.ports.login.subscribe(function (user) {
  console.log('login in user:', user)
  firebase.auth().signInWithEmailAndPassword(user.email, user.password)
  .then(function (data) {
    var userRecord = {
      displayName: user.displayName || '',
      email: user.email || '',
      emailVerified: user.emailVerified || false,
      photoURL: user.photoURL || '',
      isAnonymous: user.isAnonymous || false,
      uid: user.uid || ''
    }
    app.ports.loginSuccess.send(userRecord)
  })
  .catch(function (error) {
    // Handle Errors here.
    var errorCode = error.code
    var errorMessage = error.message

    console.log(errorCode, errorMessage)
    app.ports.loginError.send(errorMessage)
  })
})

app.ports.signOut.subscribe(function () {
  firebase.auth().signOut().then(function () {
    // Sign-out successful.
    console.log('successfully logged out')
    app.ports.logoutSuccess.send('')
  }).catch(function (error) {
    // An error happened.
  })
})

// Equivalent to POST /photos
app.ports.uploadFile.subscribe(function (id) {
  models.photo.uploadPhoto(id)
})

// Equivalent to GET /photos
app.ports.requestPhotos.subscribe(function () {
      // models.photo.create()
  models.photo.getByUserId().then(function (data) {
    console.log('getByIserd', data)
    app.ports.responsePhotos.send(data)
  })
})

// Equivalent to POST /comments
app.ports.createComment.subscribe(function (comment) {
  console.log('creating comments', comment)
  models.comment.create(comment).then(function (newComment) {
    app.ports.responseComments.send(newComment)
  })
})

// Equivalent to GET /comments
app.ports.requestComments.subscribe(function (photoID) {
  console.log('Requesting comments for photoID:', photoID)
  models.comment.all(photoID).then(function (data) {
    console.log('getComments', data)
    app.ports.responseComments.send(data)
  })
})
