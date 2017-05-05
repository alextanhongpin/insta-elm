// photos.js contains the crud logic for firebase photos resources

class Photo {
  constructor (firebase, userId, dispatcher) {
    this.ref = firebase.database().ref('photos')
    this.storage = firebase.storage().ref()
    this.userId = userId
    this.dispatcher = dispatcher

    // this.ref.on('child_added', function (data) {
    //    console.log('child added')
      // console.log(data.key, data.val())
      // var key = data.key
      // var obj = data.val()

      // // Only add if the user id matches
      // if (obj.userId === this.userId) {

      // }
    // })
  }
  create (photoUrl) {
    var newRef = this.ref.push()
    var payload = { userId: this.userId, photoUrl: photoUrl }
    newRef.set(payload)
    this.dispatcher.responsePhotos.send([
      [newRef.key, payload]
    ])
  }
  createMany () {}
  getOne () {

      // starCountRef.on('value', function(snapshot) {
      //   updateStarCount(postElement, snapshot.val());
      // })
  }
  getByUserId () {
      console.log('getByUserId')
      return this.ref.orderByChild('userId').equalTo(this.userId).once('value').then(function (snapshot) {
        var result = []
        snapshot.forEach(function (child) {
          var key = child.key
          var data = child.val()
          result.push([ key, data ])
        })
        return result
      })
  }
  getAll () {
      this.ref.once('value').then(function (snapshot) {
        snapshot.forEach(function (child) {
          var key = child.key
          var data = child.val()
          console.log(key, data)
        })
      })
  //    var userId = firebase.auth().currentUser.uid;
  // return firebase.database().ref('/users/' + userId).once('value').then(function(snapshot) {
  //   var username = snapshot.val().username;
  //   // ...
  // });
  }
  updateOne () {
      // firebase.database().ref(photosBaseRef + userId).set({
      //   username: name,
      //   email: email,
      //   profile_picture: imageUrl
      // })
  }
  updateAll () {}
  deleteOne () {
      // firebase.database().ref(photosBaseRef + userId).remove()
  }
  deleteAll () {}

  uploadPhoto (id) {
    var self = this
    console.log('id of element to be targetted', id)
    var node = document.getElementById(id)
    if (!node) {
      return
    }
    var file = node.files[0]

  // Upload file and metadata to the object 'images/mountains.jpg'
    var uploadTask = this.storage.child('images/' + file.name).put(file)

  // Listen for state changes, errors, and completion of the upload.
    uploadTask.on(firebase.storage.TaskEvent.STATE_CHANGED, // or 'state_changed'
    function (snapshot) {
      // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
      var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100
      console.log('Upload is ' + progress + '% done')
      switch (snapshot.state) {
        case firebase.storage.TaskState.PAUSED: // or 'paused'
          console.log('Upload is paused')
          break
        case firebase.storage.TaskState.RUNNING: // or 'running'
          console.log('Upload is running')
          break
      }
    }, function (error) {
    // A full list of error codes is available at
    // https://firebase.google.com/docs/storage/web/handle-errors
      switch (error.code) {
        case 'storage/unauthorized':
        // User doesn't have permission to access the object
          break

        case 'storage/canceled':
        // User canceled the upload
          break

        case 'storage/unknown':
        // Unknown error occurred, inspect error.serverResponse
          break
      }
    }, function () {
    // Upload completed successfully, now we can get the download URL
      var downloadURL = uploadTask.snapshot.downloadURL
      console.log('successfully saved file with the following url', downloadURL)
      self.create(downloadURL)
    })
  }
}
  // var commentsRef = firebase.database().ref('post-comments/' + postId);
  // commentsRef.on('child_added', function(data) {
  //   addCommentElement(postElement, data.key, data.val().text, data.val().author);
  // });

  // commentsRef.on('child_changed', function(data) {
  //   setCommentValues(postElement, data.key, data.val().text, data.val().author);
  // });

  // commentsRef.on('child_removed', function(data) {
  //   deleteComment(postElement, data.key);
  // });

  // ref.once('value', function(snapshot) {
  //   snapshot.forEach(function(childSnapshot) {
  //     var childKey = childSnapshot.key;
  //     var childData = childSnapshot.val();
  //     // ...
  //   });
  // });

