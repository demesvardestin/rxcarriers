Rails.application.configure do
  config.serviceworker.routes do
    match "/javascripts/sw.js"
    match "/manifest.json"
  end
end