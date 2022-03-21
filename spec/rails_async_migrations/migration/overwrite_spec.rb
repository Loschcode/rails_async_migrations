# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::Overwrite) do
  let(:instance) { described_class.new(class_instance, method_name) }
  let(:class_instance) { FakeMigration.new }
  let(:method_name) { :change }

  before do
    fake_migration_proxy!
    fake_version!
    config_worker_as :delayed_job
  end

  context "#perform" do
    subject { instance.perform }

    it { is_expected.to(be_instance_of(Delayed::Backend::ActiveRecord::Job)) }

    context "with sidekiq" do
      before { config_worker_as :sidekiq }

      it { is_expected.to(be_instance_of(String)) }
    end
  end
end
