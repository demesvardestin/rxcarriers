# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
ActionMailer::Base.smtp_settings = {

    :address => 'smtp.sendgrid.net',
    
    :port => '587',
    
    :authentication => :plain,
    
    :user_name => "rxcarriers",
    
    :password => "Knowledge1!",
    
    :domain => 'https://udemy-class-demo07.c9users.io',
    
    :enable_starttls_auto => true

}
