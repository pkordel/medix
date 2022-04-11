class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :title
      t.string :identifier
      t.boolean :approved
      t.jsonb :specializations, default: []
      t.jsonb :additional_expertise, default: []

      t.timestamps
    end
  end
end
