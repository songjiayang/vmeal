Vmeal::Application.routes.draw do

  root :to => "home#index"

  get "test/index"

  get "qingans/index"

  get "qingan/index"

  resources :score_histories, :only=>[:index,:new,:create]
  resources :activities, :only=>[:index,:show]
  namespace :admins do
    resources :stores, :store_users, :orders, :emails,:notices,:phone_lists,:schools
    resources :users do
      collection do
        post "query" => "users#query"
        get "export" => "users#export", :as=>"export"
        post "do_export"=>"users#do_export"
      end
      get "history/(:id)" => "users#history" ,:as=>"history"
      get "is_locked/(:id)" => "users#is_locked" ,:as=>"is_locked"
    end
    resources :ads do
      collection do
        post "query" => "ads#query"
      end
      get "is_locked" => "ads#is_locked" ,:as=>"is_locked"
    end
    resources :station_mails do
      collection do
        get "send_mail"
        get "new_user"
      end
    end

    resources :messages do
      collection do
        get "is_locked/(:type)/(:id)" =>"messages#is_locked"
        post "query" => "messages#query"
      end
    end
    resources :vmails do
        collection do
            get "sent_now"=>"vmails#sent_now"
        end
     end
    resources :activities do
        collection do
            get "kaijiang/(:id)" =>"activities#kaijiang"
        end
    end

  end

  resources :admins  do
    collection do
      get "finance"
      get "login"=>"admins#login"
      get "logout"=>"admins#logout"
    end
  end

  resources :station_mails do
    collection do
      get 'send_mail'
    end
  end

  get "notices/:id"=>"notices#show"


  resources :integral_consumer_records do
    collection do
      get "change_status"
    end
  end

  resources :logistics do
    collection do
      get "center"
      get "orderinfo"
      get "login"
      get "history"
      post "islogin"
      get "changeorder"
      get "filedorder"
    end
  end

  resources :order_manager do
    collection do
      get "midify_status"
      get "set_be_watered"
      post "search"
      get "set_user_is_ok"
      get "destroy1"
      get 'has_order'
      get 'has_store_order'
    end
  end

  resources :qingans

  get 'pc/i_want'

  resources :applications do
    collection do
      get "list_all_my_applications"
      get "sh"
      get 'succuss'
      get 'failure'
    end
  end

  resources :fs_manager do
    collection do
      get "change_status"
      get "destroy1"
    end
  end

  get "season_foods/:id/show" =>"season_foods#show"

  resources :super_market do
    member do
      get 'show'
    end
  end

  post "/complaints/do_complaint" =>"complaints#do_complaint"

  resources :messages

  resources :send_addresses

  resources :home ,:only =>[:index] do
    collection do
      get "show_stores"
      get 'qingan' => "home#qingan", :as => :qingan
      post 'signup'
    end
  end
  get "/sina" => "home#sina"

  get "about_us/(:type)" => "about_us#about_link", :as => :about_us

  resources :season_foods

  resources :sto_categories
  resources :send_addresses

  devise_for :users, :controllers => {
    :registrations => "registrations",
    :sessions => "sessions"
  }

  devise_scope :users do
    get 'logout' => 'devise/sessions#destroy'
  end

  resources :users do
    collection do
      get 'qqlogin'
      get 'sina_login'
      get 'get_user_qq_info'
      get 'center'
      get 'destory_favorite_food'
      get 'destory_favorite_store'
      get 'destory_user_address'
      get 'left'
      get 'person_center'
      get 'person_center_avatar'
      get 'person_center_order_history'
      get 'person_center_order_uncomment'
      get 'person_center_fav_food'
      get 'person_center_integral'
      get 'person_center_comment'
      get 'person_center_message'
      get 'person_center_fav_store'
      get 'person_center_address'
      get 'person_center_address_new'
      get 'person_center_password'
      get 'destory_favorite_food'
      get 'destory_favorite_store'
      get 'destory_address/:address_id'=>"users#destory_address",:as=>:destory_address
      get 'register_email'
      get 'set_default_address'
      get 'person_center_info'
      get 'bill'
      get 'user_complaints'
      get 'do_complaint'
      get 'do_one_complaint'
      get 'send_addresses_new'
      get 'do_com' =>'users#do_one_order_comment'
      get 'change_line_item_quantity'
      post 'create_user_weibo'
      post 'is_login_in_uid'
      post 'save_com' =>'users#save_order_comment'
      get 'eat_one'
      get 'resend_email'
      get 'send_email'
      get 'bill_empty'
      get 'integral_bill'
      get 'create_exchange_good'
      get 'change_exchange_good_number'
      get 'integral_bill_empty'
      get 'person_center_integral_history'
      get 'home'=>"users#personal_basic"
      get 'address'=>"users#personal_address"
      get 'collects'=>"users#personal_collect",:as=>:collects
      get 'mails/:status'=>"users#personal_mail",:as=>:mails
      get 'orders/:status'=>"users#personal_order",:as=>:orders
      get 'account'=>"users#personal_account"
      get 'create_message'
      get 'read_mail'
      get 'delete_mail'
      get 'stores_manage'
      get 'drop_order'
      get 'score_histories/(:type)'=>"users#score_histories",:as=>:score_histories,:constraints => { :type => /add|sub|/ }
      get 'welfare/(:type)'=>"users#welfare"
      post 'welfare/address_create' =>"users#good_address_create"
      get "qiandao"=>"users#qiandao"
    end
  end

  resources :orders ,:only=>[:new,:create,:destroy,:show]

  resources :line_items ,:only=>:create do
    collection do
      post 'modify/:task'=>"line_items#modify",:as=>:modify
    end
  end

  resources :orders do
    collection do
      get 'apply_fail_order'
      get 'do_fail_order'
      get 'recover_order'
    end
  end

  resources :foods do
    collection do
      get "add_favorite_foods"
      get "search"
      get 'add_recomment'
    end
  end

  resources :categories do
    resources :foods
  end

  resources :stores  ,:only=>[:show] do
    collection do
      get "add_fav_store"
      get 'cancel_fav_store'
      get 'edit/(:type)'=>"stores#edit",:as=>:edit
      get 'open'
      get 'close'
      get 'delete_food'
      get 'login'
      get 'logout'
      get 'order_details'
      get 'delete_category'
      get 'cancel_ad'
      get 'order_success'
      get 'has_new_order/(:store_id)/(:max_order_id)'=>"stores#has_new_order"
    end
  end

  resources :reply, :only=>[:show,:create]

  get "stores/:id/delete"=>"stores#destroy"

  post "serarch"=>"foods#serarch"

  post "otherlogin" => "users#otherlogin"

  get "stores/:id/delete"=>"stores#destroy"

  post "carts/action/:type" => "carts#action"

  get 'cj/:type', to: "activities#index", constraints: { type:  /coming|history/ }
  get 'cj/:id', to: "activities#show", constraints: { :id => /\d+/ }
  resources :score_histories
  get 'cj/confirm_order'=>"score_histories#new"
  get 'cj/error'=>"score_histories#error"
  get 'faq/jf_rule' => "faq#jf_rule"
  get 'locate' => 'home#location'
  get 'choose/(:id)' => 'home#set_location'
end
