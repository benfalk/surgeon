# frozen_string_literal: true

module Surgeon
  # Tracks different labeled calls
  class Session
    # @return [MeasurementSet]
    attr_reader :measurements

    def initialize
      @measurements = MeasurementSet.new
    end

    # tracks similar measurements under the same label
    #
    # @param label [Symbol]
    def track(label, &block)
      @measurements.measurement(label).track(&block)
    end
  end
end
