
const expect = require('expect');
const {msgGen, msgLocGen} = require('./message');

describe('generateMessage', () => {
  it('should generate the correct message object', () => {
    let from = 'Aaron';
    let text = 'This is some text';
    let message = msgGen(from, text);

    expect(message.createdAt).toBeDefined();
    expect(message).toMatchObject({from,text});
  });
});

describe('generateLocationMessage', () => {
  it('should generate the correct location object', () => {
    let from = 'Aaron';
    let coords = {lat: 123, long: 321};
    let expectedUrl = 'https://www.google.com/maps?q=123,321'
    let locMesg = msgLocGen(from, coords);

    expect(locMesg.createdAt).toBeDefined();
    expect(locMesg).toMatchObject({from, url: expectedUrl});
  });
});