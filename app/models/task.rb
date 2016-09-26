class Task < ApplicationRecord
  belongs_to :user
  validates :title, :description, :estimated_duration, presence: true
  validates :estimated_duration, numericality: { only_integer: true, greater_than: 0 }

  enum time_sensitive: [ :schedulable, :not_schedulable ]
end
