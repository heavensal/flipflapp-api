class AddUidAndProviderToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''
    add_index :users, [ :uid, :provider ], unique: true
  end
end
