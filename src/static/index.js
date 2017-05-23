// pull in desired CSS/SASS files
require('./styles/main.scss')
const $ = jQuery = require('../../node_modules/jquery/dist/jquery.js')           // <--- remove if jQuery not needed
require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js')   // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
const Elm = require('../elm/Main')
const app = Elm.Main.embed(document.getElementById('main'))
const config = require('./scripts/config/firebase.js')
const Comment = require('./scripts/comment.js')
const Photo = require('./scripts/photo.js')
// var Topic = require('./scripts/topic.js')
const Topic = require('./scripts/topic.js')
const User = require('./scripts/user.js')

// Holds the firebase context model
const models = {}
firebase.initializeApp(config)

// AUTH

app.ports.authenticate.subscribe(function () {
  firebase.auth().onAuthStateChanged(function (user) {
    if (user) {
      const userRecord = {
        displayName: user.displayName || '',
        email: user.email || '',
        emailVerified: user.emailVerified || false,
        photoURL: user.photoURL || '',
        isAnonymous: user.isAnonymous || false,
        uid: user.uid || ''
      }
      app.ports.onAuthenticateStateChange.send('login')
      app.ports.authenticateSuccess.send(userRecord)
      const providerData = user.providerData

      // Setup models
      models.comment = new Comment(firebase, user.uid, app.ports)
      models.photo = new Photo(firebase, user.uid, app.ports)
      models.topic = new Topic(firebase, user.uid, app.ports)
      models.user = new User(firebase, app.ports)
    } else {
      // Reset
      Object.keys(models).forEach(function (key) {
        models[key] = null
      })
      app.ports.onAuthenticateStateChange.send('logout')
    }
  })
})

app.ports.register.subscribe(function (user) {
  firebase.auth().createUserWithEmailAndPassword(user.email, user.password).catch(function (error) {
    // Handle Errors here.
    const errorCode = error.code
    const errorMessage = error.message
    // app.ports.onRegisterError.send()
    // ...
  }).then(function (data) {
    // Create a user reference
    const ref = firebase.database().ref('users')
    const newRef = ref.push()
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
    const userRecord = {
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
    const errorCode = error.code
    const errorMessage = error.message
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

// PUBLIC PHOTOS

// Equivalent to GET /public_photos
app.ports.requestPublicPhotos.subscribe(function () {
  models.photo.publicAll().then(function (data) {
    console.log('getPublicPhotos', data)
    app.ports.responsePublicPhotos.send(data)
  })
})

// PHOTOS

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

// USERS

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

// COMMENTS

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

// TOPICS

app.ports.createTopic.subscribe(topic => {
  console.log('createTopic', topic)
})
