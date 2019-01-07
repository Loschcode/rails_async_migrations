RSpec.describe RailsAsyncMigrations::Migration::Take do
  let(:resource_class) { FakeClass }
  let(:resource_instance) { resource_class.new }
  let(:method) { :free_method }
  let(:instance) { described_class.new(resource_class, method) }

  let(:change_to_it_passed) { resource_class.define_method(method, -> { 'it passed' }) }

  before { change_to_it_passed }
  subject { instance.perform }

  context 'method not in the takeable list' do
    it { is_expected.to be(false) }

    context 'does not alter the method' do
      before { subject }
      it { expect(resource_instance.send(method)).to eq('it passed') }
    end
  end

  context 'method in the takeable list' do
    let(:method) { :change }
    it { is_expected.to eq(true) }

    context 'alter the method' do
      before { subject }
      it { expect(resource_instance.send(method)).not_to eq('it passed') }
    end
  end
end

 class FakeClass
  def free_method
    true
  end

  def change
    'it passed'
  end

  def up
    true
  end

  def down
    true
  end
 end