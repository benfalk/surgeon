# frozen_string_literal: true

module Surgeon
  # Keeps track of calls
  class Measurement
    # @retrun [nil, String]
    attr_reader :label

    # @param label [#to_s] optional label
    def initialize(label = nil)
      @label = label&.to_s
      @tracking = false
      @data = []
    end

    # Track a call or block
    #
    # this can function as a simple call counter or also keep track
    # of total running time of a provided block as well
    #
    def track(&block)
      return increment_count unless block_given?
      return increment_track(&block) if @tracking

      start_track(&block)
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

    private

    def increment_count
      @data << 0
      nil
    end

    def increment_track(&block)
      @data << 0
      block.call
    end

    def start_track(&block)
      @tracking = true
      result = nil
      time = Benchmark.measure { result = block.call }
      @data << time.real
      @tracking = false
      result
    end
  end
end
