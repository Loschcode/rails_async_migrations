RSpec.describe RailsAsyncMigrations::Migration do
  include RailsAsyncMigrations::DefineMethodIn
  
  let(:resource_class) { FakeClass }
  let(:instance) { resource_class.new }
  let(:method) { :free_method }
  let(:change_to_true) { define_method_in(resource_class, method) { true } }
  let(:change_to_false) { define_method_in(resource_class, method) { false } }

  # we reset the class each time
  # as RSpec won't hot-reload it
  before { change_to_true }

  context 'without taker included within a class' do
    it { expect { change_to_false }.to change { instance.send(method) }.from(true).to(false) }
  end

  context 'with taker included within a class' do
    before { resource_class.include described_class }

    context 'method not in the takeable list' do
      it { expect { change_to_false }.to change { instance.send(method) }.from(true).to(false) }
    end

    context 'method in the takeable list' do
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