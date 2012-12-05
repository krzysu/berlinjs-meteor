
# get all users
Template.allUsers.users = ->
  Meteor.users.find({})

