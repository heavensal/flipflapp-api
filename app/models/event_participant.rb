class EventParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :event_team
end
