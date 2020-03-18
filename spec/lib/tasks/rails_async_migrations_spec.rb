RSpec.describe "rails_async_migrations:check_queue" do
  it { is_expected.to depend_on(:environment) }

  it "performs check_queue job" do
    worker_instance = instance_double(RailsAsyncMigrations::Workers, perform: nil)
    allow(RailsAsyncMigrations::Workers).to receive(:new).and_return(worker_instance)

    task.execute

    expect(RailsAsyncMigrations::Workers).to have_received(:new).with(:check_queue)
    expect(worker_instance).to have_received(:perform)
  end
end
