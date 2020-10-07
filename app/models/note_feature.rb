class NoteFeature < ApplicationRecord
  belongs_to :progress_note

  validates :feature_type, :value, :text_idx, presence: true
end
