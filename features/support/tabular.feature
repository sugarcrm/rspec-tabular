# frozen_string_literal: true

Feature: Specify examples as tables of inputs and expectations

Scenario: A passing tabular spec
  Given a file named "example_spec.rb" with:
    """ruby
    class TestModel
      def method(value1, value2)
        "result:#{value1}:#{value2}"
      end
    end
    describe TestModel do
      subject(:test_model) { described_class.new }

      describe '#method' do
        subject { test_model.method(input1, input2) }

        inputs  :input1, :input2
        it_with :value1, :value2, 'result:value1:value2'
        it_with(:value3, :value4) { is_expected.to eq('result:value3:value4') }

      end
    end
    """
  When I run rspec with the documentation option
  Then the output should contain:
    """
    TestModel
      #method
        with {:input1=>:value1, :input2=>:value2}
          is expected to eq "result:value1:value2"
        with {:input1=>:value3, :input2=>:value4}
          is expected to eq "result:value3:value4"
    """

Scenario: A failing tabular spec
  Given a file named "example_spec.rb" with:
    """ruby
    class TestModel
      def method(value1, value2)
        "result:#{value1}:#{value2}"
      end
    end
    describe TestModel do
      subject(:test_model) { described_class.new }

      describe '#method' do
        subject { test_model.method(input1, input2) }

        inputs  :input1, :input2
        it_with :value1, :value2, 'result:value1:foobar'
        it_with(:value3, :value4) { is_expected.to eq('result:value3:deadbeef') }
      end
    end
    """
  When I run rspec with the documentation option
  Then the output should contain:
    """
    Failure/Error: DEFAULT_FAILURE_NOTIFIER = lambda { |failure, _opts| raise failure }xxx
    """
  Then the output should contain:
    """
    Failure/Error: it_with(:value3, :value4) { is_expected.to eq('result:value3:deadbeef') }
    """
