# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::FireMigration) do
  let(:migration) do
    AsyncSchemaMigration.create!(
      version: "2110010101010",
      state: "created",
      direction: "up"
    )
  end
  let(:instance) { described_class.new(migration.id) }

  context "#perform" do
    subject { instance.perform }

    let(:notifier) { instance_double(RailsAsyncMigrations::Notifier, verbose: nil, done: nil) }

    before do
      allow(instance).to(receive(:process!).and_call_original)
      allow(instance).to(receive(:run_migration))
      allow(instance).to(receive(:done!).and_call_original)
      allow(instance).to(receive(:check_queue).and_call_original)
      allow(RailsAsyncMigrations::Notifier).to(receive(:new).and_return(notifier))
      allow(notifier).to(receive(:post))
    end

    context "when the migration does not exists" do
      before { allow(instance).to(receive(:run_migration).and_call_original) }

      it { expect { subject }.to(raise_error(RailsAsyncMigrations::Error)) }
    end

    context "when the migration has been already performed" do
      it "returns" do
        allow(instance).to(receive(:done?).and_return(true))

        subject

        expect(instance).to(have_received(:done?))
        expect(instance).not_to(have_received(:run_migration))
        expect(instance).not_to(have_received(:done!))
        expect(instance).not_to(have_received(:check_queue))
      end
    end

    context "when the migration has not been performed" do
      before { allow(instance).to(receive(:done?).and_return(false)) }

      it "runs the migration" do
        subject

        expect(instance).to(have_received(:run_migration))
      end

      it "updates the status to `processing`" do
        allow(instance).to(receive(:done!))

        expect do
          subject
          migration.reload
        end.to(change { migration.state }.from("created").to("processing"))

        expect(instance).to(have_received(:process!))
      end

      context "when the migration has been performed" do
        it "updates the status to `done`" do
          expect do
            subject
            migration.reload
          end.to(change { migration.state }.from("created").to("done"))

          expect(instance).to(have_received(:done!))
        end
      end

      it "checks the queue to trigger the next async migrations" do
        subject

        expect(instance).to(have_received(:check_queue))
      end
    end
  end
end
