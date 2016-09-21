class Task < ApplicationRecord
  belongs_to :user
  validates :title, :description, :estimated_duration, presence: true

  enum time_sensitive: [ :schedulable, :not_schedulable ]
end
