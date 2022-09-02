# frozen_string_literal: true

module Surgeon
  # Code that runs a certain number of times
  class LimitedLogic
    # @param limit [Numeric]
    def initialize(limit = 1)
      @limit = limit
      @runs = 0
    end

    # Run Logic
    #
    # As long as the limit hasn't been exceeded the
    # logic block provided will be run.  This will
    # return `:limit_exceeded` when past the limit
    # otherwise it will return the value of the
    # provided block
    #
    # @return [:limit_exceeded, Object]
    #
    def run(&logic)
      return :limit_exceeded unless @runs < @limit

      @runs += 1
      logic.call
    end
  end
end
