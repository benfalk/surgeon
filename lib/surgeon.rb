# frozen_string_literal: true

require 'benchmark'
require 'forwardable'
require_relative 'surgeon/version'
require_relative 'surgeon/limited_logic'
require_relative 'surgeon/measurement'
require_relative 'surgeon/measurement_set'
require_relative 'surgeon/method_tracker'
require_relative 'surgeon/session'
require_relative 'surgeon/simple_report'
require_relative 'surgeon/tagged_objects'

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
    # @return [Object, nil]
    #
    def track(label, &block)
      session.track(label, &block)
    end

    # Track Method
    #
    # This is the preferred way to measure a whole method call
    # if you want to measure the whole thing w/o wanting to
    # modify the source to do so.
    #
    # @param klass [Class]
    # @param method [Symbol]
    # @return [Symbol]
    #
    def track_method!(klass, method)
      MethodTracker.new(klass, method, self).attach!
      method
    end

    # Track Initialize
    #
    # @param klass [Class]
    # @return [nil]
    #
    def track_init!(klass)
      MethodTracker.new(klass, :initialize, self).attach!
      nil
    end

    # Run Once
    #
    # Sometimes you want to run a block of code in a loop
    # just once to have an understanding of some state or
    # to make a slight modificaiton to it to observe.  This
    # allows for labeled sets of code to only run once.
    #
    # @param label [Symbol]
    # @return [:limit_exceeded, Object]
    #
    def run_once(label = :global_surgeons_label, &block)
      session.run_once(label, &block)
    end

    # Simple Report
    #
    # @return [String]
    #
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
