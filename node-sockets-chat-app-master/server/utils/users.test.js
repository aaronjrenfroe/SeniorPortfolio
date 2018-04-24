const expect = require('expect');
const {Users} = require('./users');



describe('testingUsers', () => {

  var users;
  beforeEach(() => {
    users = new Users();
    users.users = [
      {id: '12', name: 'Aaron', room: 'Rockets'},
      {id: '11', name: 'Steve', room: 'Cameras'},
      {id: '1', name: 'Bob', room: 'Cars'},
      {id: '2', name: 'Mike', room: 'Rockets'},
      {id: '13', name: 'Robert', room: 'Pigs'}
    ];
  });

  it('shouldAddUSer', () => {
    let users = new Users();
    let user = {id: '15', name: 'James', room: 'Rockets'}
    users.addUser(user.id,user.name, user.room);

    expect(users.users.length).toBe(1);
    expect(users.users).toEqual([user]);

  });

  it('should find user with id', () => {
   let user = users.users[0];
   let retreaved_user = users.getUser(user.id);
   expect(retreaved_user).toBe(user);
   
  });

  it('should not find user with id', () => {

    let retreaved_user = users.getUser('12341234');
    expect(retreaved_user).toBeUndefined();
    
   });

  it('should Remove User', () => {
    let user = users.users[0];
    let removed_user = users.removeUser(user.id);
    let undfUser = users.getUser(user.id);

    expect(removed_user).toBe(user);
    expect(undfUser).toBeUndefined();
    
  });
  
  it('should Return Users In Rockets Room', () => {
    let usersInRoom = users.getUserList('Rockets');
    expect(usersInRoom).toEqual(['Aaron', 'Mike']);

  });

  it('should Return Users In Cars Room', () => {
    let usersInRoom = users.getUserList('Cars');
    expect(usersInRoom).toEqual(['Bob']);

  });

});