# frozen_string_literal: true
class AsyncSchemaMigration < ActiveRecord::Base
  validates :version, presence: true
  validates :state, inclusion: { in: %w[created pending processing done failed] }
  validates :direction, inclusion: { in: %w[up down] }

  after_commit :notify, on: :create

  scope :created, -> { where(state: 'created').by_version }
  scope :pending, -> { where(state: 'pending').by_version }
  scope :processing, -> { where(state: 'processing').by_version }
  scope :done, -> { where(state: 'done').by_version }
  scope :failed, -> { where(state: 'failed').by_version }
  scope :by_version, -> { order(version: :asc) }

  def notify
    RailsAsyncMigrations::Notifier.new.verbose("Asynchronous migration `#{id}` is now `#{state}`")
  end
end
