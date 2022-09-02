# frozen_string_literal: true

module Surgeon
  # Tracks different labeled calls
  class Session
    # @return [MeasurementSet]
    attr_reader :measurements

    def initialize
      @measurements = MeasurementSet.new
      @limited_logics = TaggedObjects.new(LimitedLogic)
    end

    # tracks similar measurements under the same label
    #
    # @param label [Symbol]
    def track(label, &block)
      @measurements.measurement(label).track(&block)
    end

    # Run Once
    #
    # @param label [Symbol]
    # @return [:limit_exceeded, Object]
    #
    def run_once(label = :global_surgeons_label, &block)
      @limited_logics[label].run(&block)
    end
  end
end
