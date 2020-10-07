class ProgressNote < ApplicationRecord
    has_many :note_features, dependent: :destroy
end
