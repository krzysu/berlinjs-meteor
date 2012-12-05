# Step by step guide to simple meteor.js app

by: Kris Urbas, @krzysu  

We will build simple chat client for Facebook users.


## Step 1. New project

You need to have meteor installed. How to do that you will find on [meteor website](http://meteor.com/)
  
    $ curl https://install.meteor.com | sh
   
then create a new project and run it

    $ meteor create meteor-berlinjs
    $ cd meteor-berlinjs
    $ meteor
    
go to browser and open http://localhost:3000/.


## Step 2. Packages we need

You can also add packages from command line with

    $ meteor add <package_name>
      
but I prefer to do it other way. Open the ./meteor-berlinjs/.meteor/packages file and add these lines:

    accounts-ui
    accounts-facebook
    jquery
    coffeescript
    stylus
    bootstrap
    
You don't need to use jquery, coffeescript, stylus or bootstrap, they are here only for faster development, and if you are not familiar with them, and take your profession for serious, you should learn them.

As you can see in the browser, bootstrap styling is already applied, even without reloading the page.

## Step 3. File's structure
  
open the project in your favourite code editor and let's organize our files a bit, we need structure like this:

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
      
we separate server side code from client side, and have shared file for models, that will be used on both client and server side.


## Step 4. Add login with Facebook

This step is quite easy with meteor two packages (we already added them in previous step):

    accounts-ui
    accounts-facebook

Open layout.html and add somewhere

    {{loginButtons}}
    
This will take care of displaying login with Facebook button and displaying user name if loged in.

You need to create a new Facebook app, go here: [developers.facebook.com](https://developers.facebook.com).    
Then open server.coffee and add

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
      
this demo is available [here](http://berlinjs-demo.meteor.com/)