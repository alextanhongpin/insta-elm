// Topic.js contains the crud logic for firebase topic resources

// Returns an empty topic model

function TopicModel (props) {
  // Returns
  return Object.assign({
    userId: '',
    photoUrl: '',
    displayName: '',
    title: '',
    content: '',
    commentCount: 0,
    upvoteCount: 0,
    downvoteCount: 0,
    topic: '',
    createdAt: '',
    updatedAt: ''
  }, props)
}

class Topic {
  constructor (firebase, userId, dispatcher) {
    this.firebase = firebase
    this.url = 'topics'
    this.ref = firebase.database().ref(this.url)
    this.storage = firebase.storage().ref()
    this.userId = userId
    this.dispatcher = dispatcher
  }
  count (photoId) {
    return this.ref.orderByChild('userId').equalTo(this.userId).once('value')
    .then(function (snapshot) {
      return snapshot.numChildren()
    })
  }
  create ({ photoUrl, displayName, title, topic, content }) {
    const newRef = this.ref.push()
    const payload = TopicModel({
      userId: this.userId,
      photoUrl: photoUrl,
      displayName: displayName,
      title: title,
      content: content,
      commentCount: 0,
      upvoteCount: 0,
      downvoteCount: 0,
      topic: topic,
      createdAt: new Date().toString(),
      updatedAt: new Date().toString()
    })

    newRef.set(payload)

    return Promise.resolve([ newRef.key, payload ])
  }

  one (id) {
    const ref = this.firebase.database().ref(this.url + '/' + id)

    return ref.once('value').then(function (snapshot) {
      const result = TopicModel()

      snapshot.forEach(function (child) {
        const key = child.key
        const data = child.val()
        result[key] = data
      })
      return [id, result]
    })
  }
  // Get all public photos
  // TODO: Add pagination
  publicAll () {
    return this.ref
    .once('value')
    .then(function (snapshot) {
      var result = []
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()

        var record = {
          photoUrl: data.photoUrl || '',
          content: data.content || '',
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
  // GET all topics, paginated
  // TODO: Add pagination
  all () {
    return this.ref
    .orderByChild('userId')
    .equalTo(this.userId)
    .once('value')
    .then(function (snapshot) {
      var result = []
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()

        var record = {
          photoUrl: data.photoUrl || '',
          userId: data.userId || '',
          content: data.content || '',
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

  delete (id) {
    throw new Error('Delete topic not implemented')
    // const topic
    // const photo = this.firebase.database().ref(this.url + '/' + id)
    // this.storage.child(this.url + '/' + file.name)
    // const comments = this.firebase.database().ref('comments')
    // return photo.remove().then(function (s1) {
    //   return comments.orderByChild('photoId').equalTo(id).once('value').then(function (snapshot) {
    //     var updates = {}
    //     snapshot.forEach(function (child) {
    //       updates[child.key] = null
    //     })
    //     return comments.update(updates)
    //   })
    // })
  }

  uploadPhoto (id, displayName, alt, content) {
    var self = this
    var node = document.getElementById(id)
    if (!node) {
      return
    }
    var file = node.files[0]

  // Upload file and metadata to the object 'images/mountains.jpg'
    var uploadTask = this.storage.child(this.url + '/' + file.name).put(file)

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
      self.create(downloadURL, displayName, alt, content)
    })
  }
}

module.exports = Topic

