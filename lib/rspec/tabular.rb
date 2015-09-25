require 'rspec/tabular/version'

# This module will allow examples to be specified in a more clean tabular
# manner.
#
# The same tests can be executed using standard lets, context and examples
# but this will streamline how they are expressed. An example of this is:
#
# @example
# describe 'a thing' do
#   context { let(:input1) { 'value1' } ; let(:input2) { 'value2' } ; let(:input3) { 'value3' } ; it { should be false } }
#   context { let(:input1) { 'value4' } ; let(:input2) { 'value5' } ; let(:input3) { 'value6' } ; it { should be true } }
#   context { let(:input1) { 'value7' } ; let(:input2) { 'value8' } ; let(:input3) { 'value9' } ; it { should eq('foobar') } }
#   context { let(:input1) { 'value4' } ; let(:input2) { 'value5' } ; let(:input3) { 'value6' } ; its(:method) { should eq('something') } }
#   context { let(:input1) { 'bad1' }   ; let(:input2) { 'bad2' }   ; let(:input3) { 'bad3' }   ; specify { expect { subject }.to raise_error('error') }
#   context { let(:input1) { 'bad4' }   ; let(:input2) { 'bad5' }   ; let(:input3) { 'bad6' }   ; specify { expect { subject }.to raise_error(TestException) }
#   context { let(:input1) { 'value4' } ; let(:input2) { 'value5' } ; let(:input3) { 'value6' } ; specify { helper_method.should eq('expected') } }
#   context { let(:input1) { 'value4' } ; let(:input2) { 'value5' } ; let(:input3) { 'value6' } ; specify { subject } }
# end
#
# Which works but is not very DRY, and has a great deal of boiler plate code.
# This module can improve that with the following helper methods:
#
# * inputs - defines the list of values for the example
# * it_with
# * its_with
# * raise_error_with
# * specify_with
# * side_effects_with - like specify_with but assumes a block of '{ subject }'
#
# Limitations:
# - inputs can only be simple types, and cannot use values defined by let
#
# @example
#   describe 'a thing with explicit blocks' do
#     subject { subject.thing(input1, input2) }
#     before ( stub_model(ThingyModel, name: input3) }
#
#     inputs(           :input1,  :input2,  :input3)
#     it_with(          'value1', 'value2', 'value3') { should be false }
#     it_with(          'value4', 'value5', 'value6') { should be true }
#     it_with(          'value4', 'value5', 'value6') { should eq('foobar') }
#
#     its_with(:method, 'value4', 'value5', 'value6') { should eq('something') }
#
#     specify(          'value1', 'value2', 'value3' ) { helper_method.should eq('expected')
#   end
#
#   describe 'a thing with implicit shoulds' do
#     subject { subject.thing(input1, input2) }
#     before ( stub_model(ThingyModel, name: input3) }
#
#     inputs            :input1,  :input2,  :input3
#     it_with           'value1', 'value2', 'value3', nil
#     it_with           'value4', 'value5', 'value6', true
#     it_with           'value7', 'value8', 'value9', 'foobar'
#
#     its_with :method, 'value1', 'value2', 'value3', 'something'
#
#     raise_error_with  'bad1',   'bad2',   'bad3',   'error'
#     raise_error_with  'bad4',   'bad5',   'bad6',   TestException
#
#     side_effects_with 'value4', 'value5', 'value6'
#   end
#
# Inputs can also be specified as block arguments. I am not sure if this is
# really useful, it might be deprecated in the future.
#
# @example
#   describe 'a thing', :inputs => [:input1, :input2, :input3] do
#     subject { subject.thing(input1, input2) }
#     before ( stub_model(ThingyModel, name: input3) }
#
#     it_with('value1', 'value2', 'value3') { should be false }
#   end
module Rspec
  module Tabular
    def inputs(*args)
      metadata[:inputs] ||= args
    end

    # Alias for it_with
    def specify_with(*args, &block)
      it_with(*args, &block)
    end

    # Example with an implicit subject execution
    def side_effects_with(*args)
      it_with(*args) { subject }
    end

    def raise_error_with(*args, expected_exception)
      it_with(*args) { expect { subject }.to raise_error(expected_exception) }
    end

    def it_with(*input_values, &block)
      if block.nil? && (metadata[:inputs].size == input_values.size - 1)
        expected_value = input_values.pop
        block =
          if expected_value.nil?
            proc { should be_nil }
          elsif expected_value.is_a?(TrueClass) || expected_value.is_a?(FalseClass)
            proc { is_expected.to be expected_value }
          else
            proc { should eq(expected_value) }
          end
      end

      context("with #{Hash[metadata[:inputs].zip input_values]}") do
        def should(matcher = nil, message = nil)
          RSpec::Expectations::PositiveExpectationHandler.handle_matcher(subject, matcher, message)
        end

        def should_not(matcher = nil, message = nil)
          RSpec::Expectations::NegativeExpectationHandler.handle_matcher(subject, matcher, message)
        end

        metadata[:inputs].each_index do |i|
          key   = metadata[:inputs][i]
          let(key) { input_values[i] }
        end

        example(nil, { input_values: input_values }, &block)
      end
    end

    def its_with(attribute, *input_values, &block)
      if block.nil? && (metadata[:inputs].size == input_values.size - 1)
        expected_value = input_values.pop
        block = proc { should eq(expected_value) }
      end

      describe("#{attribute} with #{input_values.join(', ')}") do
        if attribute.is_a?(Array)
          let(:__its_subject) { subject[*attribute] }
        else
          let(:__its_subject) do
            attribute_chain = attribute.to_s.split('.')
            attribute_chain.inject(subject) do |inner_subject, attr|
              inner_subject.send(attr)
            end
          end
        end

        def should(matcher = nil, message = nil)
          RSpec::Expectations::PositiveExpectationHandler.handle_matcher(__its_subject, matcher, message)
        end

        def should_not(matcher = nil, message = nil)
          RSpec::Expectations::NegativeExpectationHandler.handle_matcher(__its_subject, matcher, message)
        end

        metadata[:inputs].each_index do |i|
          key   = metadata[:inputs][i]
          let(key) { input_values[i] }
        end

        example(nil, { input_values: input_values }, &block)
      end
    end

    # TODO: it_behaves_like_with(example_name, inputs)
  end
end

RSpec.configure do |config|
  config.extend(Rspec::Tabular)
end
