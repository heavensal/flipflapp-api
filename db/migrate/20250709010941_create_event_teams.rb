class CreateEventTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :event_teams do |t|
      t.string :name, null: false
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
