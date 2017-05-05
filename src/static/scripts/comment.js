// comment.js contains the CRUD logic for comments resources

class Comment {
  constructor (firebase, userId, dispatcher) {
    this.userId = userId
    this.dispatcher = dispatcher

    this.ref = firebase.database().ref('comments')
    this.storage = firebase.storage().ref()
  }

  create ({text, photoId}) {
    var newRef = this.ref.push()
    var key = newRef.key
    var newRecord = {
      userId: this.userId,
      text: text,
      photoId: photoId
    }
    newRef.set(newRecord)
    return Promise.resolve([
      [key, newRecord]
    ])
  }

  // Include pagination, sorting, filtering, etc
  all (photoId) {
    return this.ref.orderByChild('photoId').equalTo(photoId).once('value').then(function (snapshot) {
      console.log('all.commetns', snapshot)
      var result = []
      snapshot.forEach(function (child) {
        var key = child.key
        var data = child.val()
        result.push([ key, data ])
        console.log('result', result)
      })
      console.log('result', result)
      return result
    })
  }
}
