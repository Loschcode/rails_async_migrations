igrRSpec.describe RailsAsyncMigrations::Migration do
  let(:resource_class) { FakeClass }
  let(:instance) { resource_class.new }
  let(:method) { :free_method }
  let(:change_to_true) { resource_class.define_method(method, -> { true }) }
  let(:change_to_false) { resource_class.define_method(method, -> { false }) }

  # we reset the class each time
  # as RSpec won't hot-reload it
  before { change_to_true }

  context 'without locker included within a class' do
    it { expect { change_to_false }.to change { instance.send(method) }.from(true).to(false) }
  end

  context 'with locker included within a class' do
    before { resource_class.include described_class }

    context 'method not in the lockable list' do
      it { expect { change_to_false }.to change { instance.send(method) }.from(true).to(false) }
    end

    context 'method in the lockable list' do
      let(:method) { :change }
      it { expect { change_to_false }.not_to change { instance.send(method) } }
    end
  end
end

 class FakeClass
  def free_method
    true
  end

  def change
    true
  end

  def up
    true
  end

  def down
    true
  end
 end