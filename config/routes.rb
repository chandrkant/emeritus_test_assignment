Rails.application.routes.draw do
  resources :students
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }
  
  resources :school_admins
  resources :schools
  resources :courses
  resources :batches do 
    collection do 
      get :school_courses
    end
  end
  resources :enrollments do
    member do 
      get :show_class_mates
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
