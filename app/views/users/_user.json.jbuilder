json.extract! user, :id, :uid, :provider, :name, :email, :created_at, :updated_at
json.url user_url(user, format: :json)