Auth::Engine.routes.draw do
  namespace :auth do
    get 'sessions/new'
    get 'sessions/create'
    get 'sessions/destroy'
  end
end
