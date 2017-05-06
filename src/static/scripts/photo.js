// photos.js contains the crud logic for firebase photos resources

class Photo {
  constructor (firebase, userId, dispatcher) {
    this.firebase = firebase
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
  count (photoId) {
    return this.ref.orderByChild('userId').equalTo(this.userId).once('value')
    .then(function (snapshot) {
      return snapshot.numChildren()
    })
  }
  create (photoUrl, displayName, alt) {
    var newRef = this.ref.push()
    var payload = {
      userId: this.userId,
      photoUrl: photoUrl,
      displayName: displayName,
      alt: alt,
      createdAt: new Date().toString(),
      updatedAt: new Date().toString()
    }
    newRef.set(payload)
    this.dispatcher.responsePhotos.send([
      [newRef.key, payload]
    ])
  }
  createMany () {}
  one (photoID) {
    const ref = this.firebase.database().ref('photos/' + photoID)
    return ref.once('value').then(function (snapshot) {
      var result = {
        photoUrl: '',
        userId: '',
        displayName: '',
        alt: '',
        createdAt: '',
        updatedAt: ''
      }
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()
        result[key] = data
      })
      return [photoID, result]
    })
  }
  all () {
    return this.ref.orderByChild('userId').equalTo(this.userId).once('value').then(function (snapshot) {
      var result = []
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()

        var record = {
          photoUrl: data.photoUrl || '',
          userId: data.userId || '',
          displayName: data.displayName || '',
          alt: data.alt || '',
          createdAt: data.createdAt || '',
          updatedAt: data.updatedAt || ''
        }
        result.push([ key, record ])
      })
      return result
    })
  }
  getAll () {
    this.ref.once('value').then(function (snapshot) {
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()
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
  delete (photoID) {
      // firebase.database().ref(photosBaseRef + userId).remove()
    // Delete the photo and the corresponding comments
    const photo = this.firebase.database().ref('photos/' + photoID)// .once('value')
    const comments = this.firebase.database().ref('comments')// .once('value')
    // return photo.remove().then(function (data) {
    //   console.log('photo successfully removed', data)
    //   return comments.once('value')
    // }).then(function (snapshot) {
    //   var updates = {}
    //   snapshot.forEach(function (child) {
    //     updates[child.key] = null
    //   })
    //   return comments.update(updates)
    // })

    // console.log('delete function photoID', photoID)
    // return photo.on('child_added').then(function (snapshot) {
    //   console.log('s1', snapshot)
    //   snapshot.ref.remove()
    //   return comments.on('child_added').then(function (snapshot) {
    //     console.log('s2', snapshot)
    //     return snapshot.ref.remove()
    //   })
    // })
    return photo.remove().then(function (s1) {
      return comments.orderByChild('photoId').equalTo(photoID).once('value').then(function (snapshot) {
        var updates = {}
        snapshot.forEach(function (child) {
          updates[child.key] = null
        })
        return comments.update(updates)
      })
    })
  }

  uploadPhoto (id, displayName, alt) {
    var self = this
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
      self.dispatcher.uploadProgress.send(progress)
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
      self.create(downloadURL, displayName, alt)
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

