# frozen_string_literal: true

module Surgeon
  # Keeps track of calls
  class Measurement
    # @retrun [nil, String]
    attr_reader :label

    # @param label [#to_s] optional label
    def initialize(label = nil)
      @label = label&.to_s
      @data = []
    end

    # Track a call or block
    #
    # this can function as a simple call counter or also keep track
    # of total running time of a provided block as well
    #
    def track
      if block_given?
        result = nil
        time = Benchmark.measure { result = yield }
        @data << time.real
        result
      else
        @data << 0
        nil
      end
    end

    # Number of times track has been called
    #
    # @return [Integer]
    #
    def count
      @data.count
    end

    # Total real time in seconds taken if measuring blocks
    #
    # @return [Float]
    #
    def total_time
      @data.sum
    end
  end
end
