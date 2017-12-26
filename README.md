## MedX (Medicine Express)

 MedX is a logistics platform built on rails, to facilitate same-day prescriptions
 delivery for pharmacies. To run the site, clone or download this repo.
 
### Technologies Used

 - Rails
 - Ruby
 - Bootstrap
 - Ajax
 - Stripe API
 - Twilio API
 - Checkr API
 - SQLite3
 - PostgreSQL

### Installation
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
