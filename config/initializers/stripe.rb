Rails.configuration.stripe = {
    :publishable_key => Rails.application.secrets.stripe_publishable_key,
    :secret_key      => Rails.application.secrets.stripe_secret_key,
    :CONNECTED_STRIPE_ACCOUNT_ID => Rails.application.secrets.connected_stripe_account_id
}

Stripe.api_key = Rails.application.secrets.stripe_secret_key