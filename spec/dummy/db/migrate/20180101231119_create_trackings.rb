class CreateTrackings < ActiveRecord::Migration[5.1]
  def change
    create_table :trackings do |t|
      t.references :trackable, polymorphic: true, index: true
      t.string :event
      t.datetime :happened_at

      t.references :actorable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
