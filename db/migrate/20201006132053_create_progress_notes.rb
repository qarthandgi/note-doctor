class CreateProgressNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :progress_notes do |t|
      t.string :note, null: false

      t.timestamps
    end
  end
end
