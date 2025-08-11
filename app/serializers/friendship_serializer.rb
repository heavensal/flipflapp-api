class FriendshipSerializer
  include JSONAPI::Serializer

  set_type :friendship
  set_id :id

  attributes :status

  attributes :sender do |friendship|
    friendship.sender.as_json(only: [:id, :first_name, :last_name, :avatar])
  end

  attributes :receiver do |friendship|
    friendship.receiver.as_json(only: [:id, :first_name, :last_name, :avatar])
  end
end
