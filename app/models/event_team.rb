class EventTeam < ApplicationRecord
  belongs_to :event

  validates :name, presence: true, length: { maximum: 100 }
end
