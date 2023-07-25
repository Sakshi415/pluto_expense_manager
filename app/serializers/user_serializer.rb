class UserSerializer < JSONAPI::Serializable::Resource
  type 'users'

  attributes :id, :name, :email, :created_at

  attribute :created_date do |user|
    user.created_at&.strftime('%m%d%y')
  end
end
