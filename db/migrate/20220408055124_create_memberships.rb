class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.string :user_first_name
      t.string :user_last_name
      t.string :user_profile_photo_id
      t.string :user_email
      t.jsonb :role_ids, array: true, default: []

      t.timestamps
    end
  end
end
