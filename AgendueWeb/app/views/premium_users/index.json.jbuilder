json.array!(@premium_users) do |premium_user|
  json.extract! premium_user, :id, :name, :admin_init
  json.url premium_user_url(premium_user, format: :json)
end
