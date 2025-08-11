require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# un event a un nombre de participants
# seuls les participants "Sur le Banc" ne sont pas comptés
# le compte des participants ne compte que ceux des équipes et pas ceux "Sur le Banc"
