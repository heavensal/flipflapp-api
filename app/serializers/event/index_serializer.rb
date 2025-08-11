class Event::IndexSerializer
  include JSONAPI::Serializer

  set_type :event
  set_id :id

  # ✅ Données brutes pour le formatage côté client
  attributes :id, :title, :description, :location, :start_time, :number_of_participants, :price, :is_private
  # ✅ Logique métier côté serveur
  attribute :participants_count do |event|
    event.participants_count
  end

  attribute :is_full do |event|
    event.participants_count >= event.number_of_participants
  end

  # ✅ Statut calculé côté serveur (logique métier)
  attribute :status do |event|
    if event.start_time < Time.current
      'past'
    elsif event.participants_count >= event.number_of_participants
      'full'
    elsif event.start_time < 24.hours.from_now
      'soon'
    else
      'open'
    end
  end

  attribute :author do |event|
    {
      id: event.user.id,
      first_name: event.user.first_name
    }
  end

  # cet attribut ne doit s'afficher que dans la show et jamais dans l'index
end
