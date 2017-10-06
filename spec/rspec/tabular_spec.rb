require 'rspec/tabular'

describe Rspec::Tabular do
  let(:test_class) { double }
  before do
    allow(test_class).to receive(:method)
      .with(:value1, :value2)
      .and_return(:result1)
    allow(test_class).to receive(:method)
      .with(:value3, :value4)
      .and_return(:result2)
  end

  describe '#it_with' do
    subject { test_class.method(input1, input2) }

    inputs  :input1, :input2
    it_with :value1, :value2, :result1
    it_with :value3, :value4, :result2
    it_with(:value1, :value2) { is_expected.to eq(:result1) }
    it_with(:value3, :value4) { is_expected.to eq(:result2) }
  end

  describe '#its_with' do
    subject { test_class }
    before do
      allow(test_class).to receive(:method1).and_return(:result1)
      allow(test_class).to receive(:method2).and_return(:result2)
    end

    inputs             :input1, :input2
    its_with :method1, :value1, :value2, :result1
    its_with :method2, :value3, :value4, :result2
  end

  describe '#raise_error_with' do
    subject { test_class.error_method(input1, input2) }
    before do
      allow(test_class).to receive(:error_method)
        .with(:value1, :value2)
        .and_raise('failure 1')
      allow(test_class).to receive(:error_method)
        .with(:value3, :value4)
        .and_raise('failure 2')
      allow(test_class).to receive(:error_method)
        .with(:value5, :value6)
        .and_raise(StandardError.new)
    end

    inputs           :input1, :input2
    raise_error_with :value1, :value2, 'failure 1'
    raise_error_with :value3, :value4, 'failure 2'
    raise_error_with :value5, :value6, StandardError
  end

  describe '#specify_with' do
    subject { test_class.method(input1, input2) }

    inputs       :input1, :input2
    specify_with :value1, :value2, :result1
    specify_with :value3, :value4, :result2
    specify_with(:value1, :value2) { expect(subject).to eq(:result1) }
    specify_with(:value3, :value4) { expect(subject).to eq(:result2) }
  end

  describe '#side_effects_with' do
    subject { test_class.method(input1, input2) }

    inputs            :input1, :input2
    side_effects_with :value1, :value2
    side_effects_with :value3, :value4
  end
end
