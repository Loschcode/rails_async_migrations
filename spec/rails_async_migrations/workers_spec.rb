# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Workers) do
  let(:called_worker) { :check_queue }
  let(:instance) { described_class.new(called_worker) }
  let(:args) { [] }
  let(:async_schema_migration) do
    AsyncSchemaMigration.create!(
      version: '2110010101010',
      direction: 'up',
      state: 'created'
    )
  end

  describe '.perform' do
    subject { instance.perform(args) }

    context 'through delayed_job' do
      before do
        config_worker_as :delayed_job
      end

      context 'with :check_queue' do
        it { is_expected.to(be_truthy) }
      end

      context 'with :fire_migration' do
        let(:called_worker) { :fire_migration }
        let(:args) { [async_schema_migration.id] }

        it { expect { subject }.to(raise_error(RailsAsyncMigrations::Error)) }
      end
    end

    context 'through sidekiq' do
      before { config_worker_as :sidekiq }

      context 'with :check_queue' do
        let(:called_worker) { :check_queue }
        let(:worker) { RailsAsyncMigrations::Workers::Sidekiq::CheckQueueWorker }

        it 'enqueue CheckQueueWorker' do
          expect { subject }.to(change(worker.jobs, :size).by(1))
        end

        context 'when a custom queue is defined' do
          before { config_queue_as :custom }

          it 'performs the job in the custom queue' do
            allow(worker).to(receive(:set).and_call_original)

            subject

            expect(worker).to(have_received(:set).with(queue: :custom))
          end
        end
      end

      context 'with :fire_migration' do
        let(:called_worker) { :fire_migration }
        let(:args) { [async_schema_migration.id] }
        let(:worker) { RailsAsyncMigrations::Workers::Sidekiq::FireMigrationWorker }

        it 'enqueue FireMigrationWorker' do
          expect { subject }.to(change(worker.jobs, :size).by(1))
        end

        context 'when a custom queue is defined' do
          before { config_queue_as :custom }

          it 'performs the job in the custom queue' do
            allow(worker).to(receive(:set).and_call_original)

            subject

            expect(worker).to(have_received(:set).with(queue: :custom))
          end
        end
      end
    end
  end
end
