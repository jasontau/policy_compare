json.extract! user, :id, :email, :title, :company, :phone, :password, :password_confirmation, :admin, :created_at, :updated_at, :first_name, :last_name
json.url user_url(user, format: :json)
