class AsyncSchemaMigration < ActiveRecord::Base
  validates :version, presence: true
  validates :state, inclusion: { in: %w[created pending processing done] }
end
