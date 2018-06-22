## RxCarriers

 RxCarriers is a pharmacy-to-patients web-based communication platform built to
 help pharmacists better serve their customers through task automation.
 
 The live app can be found at https://rxcarriers.com
 
#### APIs & 3rd Parties

 - Rails 4
 - Bootstrap 4
 - Stripe
 - Twilio
 - Checkr
 - Zendesk
 - Sendgrid
 - Pusher
 - DNSimple

#### Installation

 To clone:
 
 1. Click on the 'Clone or Download' icon in the top right
 2. Copy the cloning link
 3. Head to Git Bash (or any other git tool you prefer)
 4. CD to location where you want directory to be cloned in
 5. Type:
 
 ```
 git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
 ```
 
 where YOUR-USERNAME is your Github username, and YOUR-REPOSITORY is the name of
 the repository.
 
 Following download, run bundler to install all gems and dependencies:
 
 ```
 bundle install
 ```
 Then run the migration:
 
 ```
 rake db:migrate
 ```
 Then run the server:
 
 ```
 rails s -p $PORT -b $IP
 ```
 
 Make sure that you have a recent version of Rails and/or Ruby installed as well.

#### Thoughts/Feedback

 I'm happy to hear your thoughts! Please reach out at hello@rxcarriers.com