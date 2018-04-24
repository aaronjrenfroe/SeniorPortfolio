const moment = require('moment');

let msgGen = (from, text) => {
  return {
      from,
      text,
      createdAt: moment().valueOf()
    }
};

let msgLocGen = (from, coords) => {
  
  return {
      from,
      url: `https://www.google.com/maps?q=${coords.lat},${coords.long}`,
      createdAt: moment().valueOf()
    }
};

module.exports = {msgGen, msgLocGen};