json.extract! user, :id, :name, :email, :title, :company, :phone, :password, :password_confirmation, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)