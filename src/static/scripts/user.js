
class User {
  constructor (firebase, dispatcher) {
    this.user = firebase.auth().currentUser
    this.storage = firebase.storage().ref()
    this.url = 'users/'
    this.dispatcher = dispatcher
  }

  profilePhoto (id) {
    var self = this
    console.log('id of element to be targetted', id)
    var node = document.getElementById(id)
    if (!node) {
      return
    }
    var file = node.files[0]

  // Upload file and metadata to the object 'images/mountains.jpg'
    var uploadTask = this.storage.child(this.url + file.name).put(file)

  // Listen for state changes, errors, and completion of the upload.
    uploadTask.on(firebase.storage.TaskEvent.STATE_CHANGED, // or 'state_changed'
    function (snapshot) {
      // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
      var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100
      console.log('Upload is ' + progress + '% done')
      self.dispatcher.progress.send(progress)
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

      self.user.updateProfile({
        photoURL: downloadURL
      }).then(function () {
      // successful
        self.dispatcher.profilePhotoSuccess.send(downloadURL)
      }, function (error) {
        console.log('error uploading photo')
      })
    })
  }

  displayName (name) {
    console.log('set:', name)
    return this.user.updateProfile({
      displayName: name
    })
  }
}

module.exports = User

