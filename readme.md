# Step by step guide to simple meteor.js app

by: Kris Urbas, [@krzysu](https://twitter.com/krzysu)  

**We will build simple chat client for Facebook users.**  

The demo is available [here](http://berlinjs-demo.meteor.com/)


## On a side note

If you want to build something for real using meteor.js, preferable if you are a company or have funding.. you can always contact me.

## Step 1. New project

You need to have meteor installed. Check [meteor website](http://meteor.com/) how to do that or just type in your terminal:
  
    $ curl https://install.meteor.com | sh
   
Then create a new project and run it

    $ meteor create meteor-berlinjs
    $ cd meteor-berlinjs
    $ meteor
    
Go to browser and open `http://localhost:3000/`.


## Step 2. Packages we need

You can also add packages from command line with

    $ meteor add <package_name>
      
but I prefer to do it other way. Open the `meteor-berlinjs/.meteor/packages` file and add these lines:

    accounts-ui
    accounts-facebook
    coffeescript
    stylus
    bootstrap
    
You don't need to use coffeescript or stylus to work with meteor, they are here only for faster development. But if you are not familiar with them, and take your profession for serious, you should learn them. Bootstrap is added only for fast styling, this app is is only a prototype, isn't it.

As you can see in the browser, bootstrap styling is already applied, even without reloading the page.

## Step 3. File's structure
  
Open the project in your favourite code editor and let's organize our files a bit, we need structure like this:

    - meteor-berlinjs
      - client
        - javascripts
            main.coffee
        - stylesheets
            styles.styl
        layout.html
      - public
          empty
      - server
          server.coffee
      models.coffee
      
We separate server side code from client side, and have shared file for models, which will be used on both client and server side.


## Step 4. Add login with Facebook

This step is quite easy with meteor two packages (we already added them in previous step):

    accounts-ui
    accounts-facebook

Open `layout.html` and add somewhere

    {{loginButtons}}
    
This will take care of displaying login with Facebook button and displaying user name if loged in.

You need to create a new Facebook app. How to do that you will find [here](https://developers.facebook.com/docs/technical-guides/opengraph/opengraph-tutorial/#create-app).
We need your facebook app id and secret key. Then open `server.coffee` and add:

    # first, remove configuration entry in case service is already configured
    Accounts.loginServiceConfiguration.remove
      service: "facebook"

    Accounts.loginServiceConfiguration.insert
      service: "facebook"
      appId: "<your_fb_app_id>"
      secret: "<your_fb_app_secret>"
      
In this guide I only tell about important things, in the source code you will find a bit more, like styling, html structure etc.

You can always deploy your app to meteor servers with

    $ meteor deploy <your_app_name>


## Step 5. Display all users

We want to display user name and picture. To get user picture we need to hack a bit creating user accounts. Add this code to `server.cofee` file.

    # during new account creation get user picture from facebook and save in user object
    Accounts.onCreateUser (options, user) ->
      if (options.profile)
        options.profile.picture = getFbPicture( user.services.facebook.accessToken )

        # We still want the default hook's 'profile' behavior.
        user.profile = options.profile;
      return user

    # get user picture from facebook api
    getFbPicture = (accessToken) ->
      result = Meteor.http.get "https://graph.facebook.com/me",
        params:
          access_token: accessToken
          fields: 'picture'

      if(result.error)
        throw result.error

      return result.data.picture.data.url
      
Now we need to add some html to display users. Add this code to `layout.html` file.

    {{#if currentUser}}
      {{> allUsers}}
    {{/if}}
        
    <template name="allUsers">
      <h3>All users:</h3>
      <ul>
      {{#each users}}
        <li>
          <img src="{{profile.picture}}" alt="picture">
          <span>{{profile.name}}</span>
        </li>    
      {{/each}}
      </ul>
      
    </template>
    
And in the end we need to get users data and pass them to the template. Add this code to `main.coffee` file.

    Template.allUsers.users = ->
      Meteor.users.find({})

That's all, try to login to your app from two different browsers with two different facebook accounts.


## Step 6. Add simple chat system

Chating is based on messages. So we need to add Messages model inside `model.coffee` file.

    Messages = new Meteor.Collection('messages')

Yes, that is all we need to create a new collection of data in meteor.js!  

Next we need to add some html for entering messages and displaying them. Add this code to `layout.html` file.

    {{#if currentUser}}
      {{> chatBox}}
    {{/if}}
    
    <template name="chatBox">
      <h3>Let's chat:</h3>
      
      <form id="add-message-form">
        <input type="text" id="message-input" placeholder="Your Message" />
        <button>Send</button>
      </form>
      
      <h3>Messages:</h3>
      <ul>
        {{#each messages}}
          <li>
              <img src="{{author.profile.picture}}" alt="picture">
              <span>{{body}}</span>
          </li>
        {{/each}}
      </ul>
    </template>

Great. The only missing part is logic to save messages sent by form and get them to display on messages list. Let's add function to save messages together with the author of the message. Add this code to `main.coffee` file.

    # add new message
    newMessage = () ->
      input = document.getElementById('message-input')

      if input.value != ''

        Messages.insert
          author: Meteor.user()
          body: input.value
          time: Date.now()

      input.value = ''
      
Now we need to call `newMessage` on user action. Let's add template events in `main.coffee` file.

    # add message events
      Template.chatBox.events =
        'keydown #add-message-form input': (e) ->
          if e.which == 13
            newMessage()

        'click #add-message-form button': (e) ->
          e.preventDefault()
          newMessage()

And at the end we need to get all messages and display them. Add this code to `main.coffee` file.

      # get all messages
      Template.chatBox.messages = ->
        Messages.find( {}, { sort: { time: -1 }} )

And that's all. In source code you will find only a bit more styling. I hope all is clear but if you have questions you can always open an github issue for this project.

* * *
If you like it, consider [following me on twitter](https://twitter.com/krzysu).  

If you want to build something for real using meteor.js, preferable if you are a company or have funding.. you can always contact me.