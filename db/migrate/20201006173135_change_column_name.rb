class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :note_features, :type, :feature_type
  end
end
