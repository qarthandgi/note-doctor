class CreateNoteFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :note_features do |t|
      t.string :type
      t.string :value
      t.integer :text_idx
      t.references :progress_note, null: false, foreign_key: true

      t.timestamps
    end
  end
end
