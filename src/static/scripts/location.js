// scripts/location.js
//
// Geolocation is a function that returns the location of the
// user if success or error messages if fail

const Geolocation = () => {
  // options for the geolocation api
  const options = {
  	enableHighAccuracy: true,
  	maximumAge: 30000,
  	timeout: 27000
  }

  // response is the return object
  const response = (props) => {
  	return Object.assign({
  		lat: 0.0,
  		lng: 0.0,
  		error: ''
  	}, props)
  }

  // returns a promise
  return new Promise((resolve, reject) => {
  	// successCallback returns the position of the user
    const successCallback = (position) => {
      const lat = position.coords.latitude
      const lng = position.coords.longitude

      resolve(response({ lat, lng }))
    }

  	// errorCallback returns error code and message
    const errorCallback = (error) => {
      console.log('error getting location', error.code, error.message)

      reject(response({ error: error.message }))
    }

    if ('geolocation' in navigator) {
	  navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options)
    } else {
  		reject(response({ error: 'Geolocation not available' }))
    }
  })
}

module.exports = Geolocation
