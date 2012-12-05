# add new message
newMessage = () ->
  input = document.getElementById('message-input')

  if input.value != ''

    Messages.insert
      author: Meteor.user()
      body: input.value
      time: Date.now()

  input.value = ''

# get all users
Template.allUsers.users = ->
  Meteor.users.find({})

# add message events
Template.chatBox.events =
  'keydown #add-message-form input': (e) ->
    if e.which == 13
      newMessage()

  'click #add-message-form button': (e) ->
    e.preventDefault()
    newMessage()

# get all messages
Template.chatBox.messages = ->
  Messages.find( {}, { sort: { time: -1 }} )