[{
  id: String,
  name: String,
  room: String
}]

// addUser(id, name, room)
// removeUser(id)
// getUser(id)
// getUserList(room)


class Users {

  constructor(){
    this.users = [];
    this.rooms = [];
  }

  addUser(id, name, room){
    var user = {id, name: name.toLowerCase(), room: room.toLowerCase()};
    this.users.push(user);
    if(!this.rooms.includes(user.room)){
      this.rooms.push(user.room);
    }
  }
  removeUser(id){
    // return user that was removed
    let removed;
    this.users = this.users.filter((user) => {
      if (user.id === id) {
        removed = user;
      }
      return user.id !== id
    });
    if(removed){

      let usersInSameRoom = this.users.filter((user) => { return user.room == removed.room;});
      if(usersInSameRoom.length < 1){
        this.rooms = this.rooms.filter(room => {
          return room != removed.room;
        })
      }
    }
    return removed;
  }

  getUser(id){
    let user = this.users.filter((user) => user.id === id);
    return user[0];
  }


  getUserList(room){
    room = room.toLowerCase();
    let users = this.users.filter((user) => user.room === room );
    let names = users.map((user) => user.name);
    return names;
  }

  isUnique(name, room){
    name = name.toLowerCase();
    room = room.toLowerCase();
    let users = this.users.filter((user) => user.room === room && user.name === name );
    return users.length == 0;
  }

  getRoomList(){
    return this.rooms;
  }
}

module.exports = { Users };