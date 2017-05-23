
const Topic = require('../model/topic.js')

module.exports = (firebase, uid, dispatcher) => {
  const topic = new Topic(firebase, uid, dispatcher)

  dispatcher.createTopic.subscribe(data => {
	  console.log('createTopic', data)
  })
}
