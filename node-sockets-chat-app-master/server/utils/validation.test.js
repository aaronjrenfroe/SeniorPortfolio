const expect = require('expect');
const { isRealString } = require('./validation');


describe('checkingNonStrings', () => {
  it('should reject non stirng values', () => {
    let res = isRealString(12);
    let res2 = isRealString(()=>{
    });
    expect(res).toBe(false);
    expect(res2).toBe(false);
  });

  it('should reject strings with only spaces and empty strings', () => {
    let res = isRealString('     ');
    let res2 = isRealString('');
    
    expect(res).toBe(false);
    expect(res2).toBe(false);
  });

  it('should Allow vailid input', () => {
    let res = isRealString(' Cow Patty     ');
    let res2 = isRealString(' Fanny Pack');
    expect(res).toBe(true);
    expect(res2).toBe(true);
  });
});
