# frozen_string_literal: true

module RSpec
  module Tabular
    # This class is a wrapper around a proc that will indicate
    # to tabular that the provided proc should be run against
    # a spec's context such that variables defined with let and
    # helper methods like instance_double are available.
    #
    # This class should not be called directly. Instead use the
    # helper function `with_context`
    class Wrapped
      def initialize(proc, pretty_val = nil)
        @proc       = proc
        @pretty_val = pretty_val
      end

      attr_reader :proc

      def to_s
        @pretty_val || 'wrapped_value'
      end

      alias inspect to_s
    end
  end
end
