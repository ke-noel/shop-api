Rails.application.routes.draw do
	post 'auth/register', :to => 'users#register'
	post 'auth/login', :to => 'users#login'
	get 'test', :to => 'users#test'

	namespace 'api' do
		namespace 'v1' do
			resources :products, only: [:show, :index] do
				get 'purchase', :to => 'products#purchase'
			end
		end
	end
end