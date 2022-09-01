# frozen_string_literal: true

module Surgeon
  # Used to track methods w/o needing to
  # wire up a measurement for the whole body
  class MethodTracker
    # @param klass [Class]
    # @param method [Symbol]
    # @param tracker [#track]
    def initialize(klass, method, tracker)
      @klass = klass
      @method = method
      @tag = :"#{klass.name}##{method}"
      @tracker = tracker
      @measured_method = :"__before_measurement_#{method}"
      @attached = false
    end

    # Attach Tracking
    #
    # By default a method tracker doesn't attach to and track
    # calls.  This method attaches tracking to the calls and
    # returns true if it attached or false it was already attached
    #
    # @return [Boolean]
    #
    def attach!
      return false if @attached

      # Have to bind these to local variables so they will
      # carry down into the define_method block
      tracker, tag, measured_method = tracker_tag_and_measured_method

      @klass.alias_method(@measured_method, @method)
      @klass.define_method(@method) do |*args, **opts, &block|
        tracker.track(tag) do
          send(measured_method, *args, **opts, &block)
        end
      end

      @attached = true
    end

    # Detach Tracking
    #
    # If you are dynamically attaching trackers and need to remove
    # some `detach!` will remove tracking to it's assigned function.
    # Returns true if it was attached or false otherwise.
    #
    # @return [Boolean]
    #
    def detach!
      return false unless @attached

      @attached = false
      @klass.alias_method(@method, @measured_method)

      true
    end

    private

    def tracker_tag_and_measured_method
      [@tracker, @tag, @measured_method]
    end
  end
end
