Rails.configuration.stripe = {
    :publishable_key => 'pk_test_hX4NI6giYh5tnHPaDXWxIUoM',
    :secret_key      => 'sk_test_8E4bNFO9QwSuaY77whC13QUg'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]