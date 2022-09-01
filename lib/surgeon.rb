# frozen_string_literal: true

require 'benchmark'
require 'forwardable'
require_relative 'surgeon/version'
require_relative 'surgeon/measurement'
require_relative 'surgeon/measurement_set'
require_relative 'surgeon/session'
require_relative 'surgeon/simple_report'

# A singleton debugger aid
module Surgeon
  class Error < StandardError; end

  class << self
    # Sets up a fresh session to which metrics are saved for reporting
    #
    # @return [nil]
    def prepare_for_surgery!
      @session = Session.new

      nil
    end

    # Track Call Counts and Time Profiles
    #
    # Returns the value of the provided block if one is provided;
    # otherwise it returns nil
    #
    # @param label [Symbol]
    def track(label, &block)
      session.track(label, &block)
    end

    # @return [String]
    def report
      SimpleReport.new(session.measurements).to_s
    end

    private

    # @return [Session]
    def session
      @session ||= Session.new
    end
  end
end
