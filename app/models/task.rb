class Task < ApplicationRecord
  belongs_to :user

  enum time_sensitive: [ :schedulable, :not_schedulable ]
end
