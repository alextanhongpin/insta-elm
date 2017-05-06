// pull in desired CSS/SASS files
require('./styles/main.scss')
var $ = jQuery = require('../../node_modules/jquery/dist/jquery.js')           // <--- remove if jQuery not needed
require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js')   // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'))

// Holds the firebase context model
var models = {}

var config = {
    // Place firebase config here
  apiKey: 'AIzaSyCVDboPN9FMcAaFf3teK4wxhAgf0VePCm8',
  authDomain: 'instaelm-9f923.firebaseapp.com',
  databaseURL: 'https://instaelm-9f923.firebaseio.com',
  projectId: 'instaelm-9f923',
  storageBucket: 'instaelm-9f923.appspot.com',
  messagingSenderId: '838973904562'
}
firebase.initializeApp(config)

app.ports.authenticate.subscribe(function () {
  firebase.auth().onAuthStateChanged(function (user) {
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

      // Setup models
      models.photo = new Photo(firebase, user.uid, app.ports)
      models.comment = new Comment(firebase, user.uid, app.ports)
      models.user = new User(firebase, app.ports)
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
    // Create a user reference
    var ref = firebase.database().ref('users')
    var newRef = ref.push()
    newRef.set({
      email: user.email,
      createdAt: new Date().toString(),
      updatedAt: new Date().toString()
    })
    app.ports.onRegistered.send('success')
  })
})

app.ports.login.subscribe(function (user) {
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
    app.ports.loginError.send(errorMessage)
  })
})

app.ports.signOut.subscribe(function () {
  firebase.auth().signOut().then(function () {
    // Sign-out successful.
    app.ports.logoutSuccess.send('')
  }).catch(function (error) {
    // An error happened.
  })
})

// Equivalent to POST /photos
app.ports.uploadFile.subscribe(function ([id, photo]) {
  models.photo.uploadPhoto(id, photo.displayName, photo.alt)
})

// Equivalent to GET /photos/counts
app.ports.photoCount.subscribe(function () {
      // models.photo.create()
  models.photo.count().then(function (count) {
    app.ports.photoCountSuccess.send(count)
  })
})
// Equivalent to GET /photos
app.ports.requestPhotos.subscribe(function () {
      // models.photo.create()
  models.photo.all().then(function (data) {
    app.ports.responsePhotos.send(data)
  })
})

// Equivalent to GET /photos/:photoID
app.ports.requestPhoto.subscribe(function (photoID) {
  models.photo.one(photoID).then(function (data) {
    app.ports.responsePhoto.send(data)
  })
})

// Equivalent to DELETE /photos/:photoID
app.ports.deletePhoto.subscribe(function (photoID) {
  models.photo.delete(photoID).then(function (data) {
    app.ports.deletePhotoSuccess.send(photoID)
  })
})

// Equivalent to POST /users/profile_photos
app.ports.profilePhoto.subscribe(function (id) {
  models.user.profilePhoto(id)
})

// Equivalent to POST /users/display_name
app.ports.setDisplayName.subscribe(function (displayName) {
  models.user.displayName(displayName).then(function () {
    app.ports.setDisplayNameSuccess.send(displayName)
  })
})

// Equivalent to POST /comments
app.ports.createComment.subscribe(function (comment) {
  models.comment.create(comment).then(function (newComment) {
    app.ports.responseComments.send(newComment)
  })
})

// Equivalent to GET /comments
app.ports.requestComments.subscribe(function (photoID) {
  models.comment.all(photoID).then(function (data) {
    app.ports.responseComments.send(data)
  })
})

// Equivalent to DELETE /comments
app.ports.deleteComment.subscribe(function ([commentId, comment]) {
  models.comment.delete(commentId, comment).then(function () {
    app.ports.deleteCommentSuccess.send(commentId)
  })
})

// Equivalent to UPDATE /comments
app.ports.updateComment.subscribe(function ([commentId, comment]) {
  models.comment.update(commentId, comment).then(function (error) {
    app.ports.updateCommentSuccess.send([commentId, comment])
  })
})
