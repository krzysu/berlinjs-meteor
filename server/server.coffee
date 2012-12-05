
# first, remove configuration entry in case service is already configured
Accounts.loginServiceConfiguration.remove
  service: "facebook"

Accounts.loginServiceConfiguration.insert
  service: "facebook"
  appId: config.facebook.appId # put your facebook app id here
  secret: config.facebook.secret # put your facebook app secret here
