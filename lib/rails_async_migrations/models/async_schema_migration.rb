class AsyncSchemaMigration < ActiveRecord::Base
  validates :version, presence: true
  validates :state, inclusion: { in: %w[created pending processing done failed] }
  validates :direction, inclusion: { in: %w[up down] }
end
