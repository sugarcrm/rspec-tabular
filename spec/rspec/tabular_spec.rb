# frozen_string_literal: true

require 'spec_helper'

describe Rspec::Tabular do
  let(:test_class) { double }

  before do
    allow(test_class).to receive(:method)
      .with(:value1, :value2)
      .and_return(:result1)
    allow(test_class).to receive(:method)
      .with(:value3, :value4)
      .and_return(:result2)
    allow(test_class).to receive(:method)
      .with(:value5, :value6)
      .and_return(nil)
    allow(test_class).to receive(:method)
      .with(:value7, :value8)
      .and_return(true)
    allow(test_class).to receive(:method)
      .with(:value9, :value10)
      .and_return(false)
  end

  describe '#it_with' do
    subject { test_class.method(input1, input2) }

    inputs  :input1, :input2
    it_with :value1, :value2,  :result1
    it_with :value3, :value4,  :result2
    it_with :value5, :value6,  nil
    it_with :value7, :value8,  true
    it_with :value9, :value10, false
    it_with(:value1, :value2)  { is_expected.to eq(:result1) }
    it_with(:value3, :value4)  { is_expected.to eq(:result2) }
    # rubocop:disable RSpec/ImplicitExpect
    it_with(:value1, :value2)  { should eq(:result1) }
    it_with(:value3, :value4)  { should eq(:result2) }
    it_with(:value1, :value2)  { should_not eq(:result2) }
    it_with(:value3, :value4)  { should_not eq(:result1) }
    # rubocop:enable RSpec/ImplicitExpect
  end

  # NOTE: no spec for 'alias specify_with it_with'

  describe '#side_effects_with' do
    context 'when no exception is raised' do
      subject { test_class.method(input1, input2) }

      inputs            :input1, :input2
      side_effects_with :value1, :value2
      side_effects_with :value3, :value4
    end

    context 'when an exception is raised' do
      subject { test_class.error_method(input1, input2) }

      before do
        allow(test_class).to receive(:error_method)
          .with(:value1, :value2)
          .and_raise('failure 1')
        allow(test_class).to receive(:error_method)
          .with(:value3, :value4)
          .and_raise(Exception)
      end

      inputs            :input1, :input2
      side_effects_with :value1, :value2
      side_effects_with :value3, :value4
    end
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
    raise_error_with :value1, :value2, StandardError, 'failure 1'
    raise_error_with :value3, :value4, StandardError, 'failure 2'
  end

  describe '#its_with' do
    subject { test_class }

    before do
      allow(test_class).to receive(:method1).and_return(:result1)
      allow(test_class).to receive(:method2).and_return(:result2)
    end

    inputs             :input1, :input2
    its_with :method1, :value1, :value2, :result1
    its_with :method2, :value1, :value2, :result2
  end

  context 'with wrapped value' do
    subject { test_class.method(input1, input2) }

    inputs  :input1,                        :input2
    it_with with_context(proc { :value1 }), :value2,                        :result1
    it_with :value3,                        with_context(proc { :value4 }), :result2
  end
end
