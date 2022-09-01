# frozen_string_literal: true

module Surgeon
  # Dynamic tagged measurements
  class MeasurementSet
    include Enumerable

    def initialize
      @measurements = Hash.new do |hash, key|
        hash[key] = Measurement.new(key)
      end
    end

    # @param label [Symbol, String]
    # @return [Measurement]
    def measurement(label)
      @measurements[label]
    end

    def each(&block)
      @measurements.each_value(&block)
    end
  end
end
