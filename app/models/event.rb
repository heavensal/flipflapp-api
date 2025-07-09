class Event < ApplicationRecord
  belongs_to :user
  has_many :event_teams, dependent: :destroy
  has_many :event_participants, dependent: :destroy

  validates :title, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :number_of_participants, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :is_private, inclusion: { in: [ true, false ] }

  # Additional validations can be added as needed
end
