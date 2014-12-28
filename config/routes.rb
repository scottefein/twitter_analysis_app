Rails.application.routes.draw do
  get '/oauth/connect' => 'instagram#instagram_connect'
  get '/oauth/callback' => 'instagram#instagram_callback'
  resources :people
end
