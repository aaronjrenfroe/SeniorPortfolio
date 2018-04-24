
let socket = io();



socket.on('connect', () => {
  
  let params = jQuery.deparam(window.location.search)
  params.name = params.name.toLowerCase();
  params.room = params.room.toLowerCase();
  let title = jQuery('#room-name');
  title.text(jQuery.deparam(window.location.search).room);

  socket.emit('join', params, (error) => {
    if(error){
      alert(error);
      window.location.href = '/';
    }else{
      console.log("No Error");
    }
  });
});

socket.on('disconnect', () => {
  console.log('Disconnected from Server')
})

socket.on('updateUserList', (usersList) => {
  console.log(usersList);
  var list = jQuery('<ul></ul>');
  usersList.forEach((user) => {
    list.append(jQuery('<li></li>').text(user));
  })
  jQuery('#users').html(list);

});

// MESSAGES Listeners
socket.on('newMessage', (message) => {
  console.log(message);

  let formattedTime = moment(message.createdAt).format('h:mm a');

  let template = jQuery('#message-template').html();
  let html = Mustache.render(template,{
    from: message.from,
    text: message.text,
    createdAt: formattedTime
  });

  jQuery('#messages').append(html); 
  scrollToBottom();
});

socket.on('newLocationMessage', (message) => {
  let formattedTime = moment(message.createdAt).format('h:mm a');

  let template = jQuery('#location-message-template').html();
  let html = Mustache.render(template,{
    from: message.from,
    url: message.url,
    createdAt: formattedTime
  });
  console.log(message);
  
  jQuery('#messages').append(html);
  scrollToBottom();

});

// MESSAGE Senders
jQuery('#message-form').on('submit', (event) => {
  event.preventDefault();
  let element = jQuery('[name=message]');
 
    socket.emit('createMessage', {
      text: element.val()
    }, () => {
      // Clearing input field
      element.val('');
    });
  
});

let locationbutton = jQuery('#sendLocation');

locationbutton.on('click', () => {
  // Submitting form
  if(!navigator.geolocation){
    return alert('Geolaction not supported by your browser');
  }
  let originalButtonText = locationbutton.text();
  locationbutton.text('Getting Location');
  locationbutton.attr('disabled', 'disabled');

  navigator.geolocation.getCurrentPosition((pos) =>{
    locationbutton.text('Sending Location');
    socket.emit('createLocationMessage', {
      lat: pos.coords.latitude,
      long: pos.coords.longitude
    });
    locationbutton.removeAttr('disabled');
    locationbutton.text(originalButtonText); 
  }, (error) => {
    locationbutton.removeAttr('disabled');
    locationbutton.text(originalButtonText);
    alert('Unable to get location');
  });

});

let scrollToBottom = ()=>{
  // Selectors
  let messages = jQuery('#messages');
  let newMessage = messages.children('li:last-child');
  // Heights
  let clientHeight = messages.prop('clientHeight');
  let scrollTop = messages.prop('scrollTop');
  let scrollHeight = messages.prop('scrollHeight');
  let newMsgHeight = newMessage.innerHeight();
  let lastMsgHeight = newMessage.prev().innerHeight();
  // set a var for debugging
  let calc = clientHeight + scrollTop + newMsgHeight + lastMsgHeight + 100;
  
  if (calc >= scrollHeight){
    
    messages.scrollTop(scrollHeight);
  }
};

let shareLink = jQuery('#share');
let params = jQuery.deparam(window.location.search);
let url = window.location.origin + '/?room=' + params.room;
shareLink.text(url);

let copyToClipboard = (event) => {
  let $temp = $("<input>");
  $("body").append($temp);
  $temp.val($('#share').text()).select();
  document.execCommand("copy");
  $temp.remove();
}

let shareBtn = $('#share-button');
shareBtn.on('click',copyToClipboard);