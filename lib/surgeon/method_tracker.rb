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

    def attach!
      return if @attached

      # Have to bind these to local variables so they will
      # carry down into the define_method block
      tracker, tag, measured_method = tracker_tag_and_measured_method

      @attached = true
      @klass.alias_method(@measured_method, @method)
      @klass.define_method(@method) do |*args, **opts, &block|
        tracker.track(tag) do
          send(measured_method, *args, **opts, &block)
        end
      end
    end

    def detach!
      return unless @attached

      @attached = false
      @klass.alias_method(@method, @measured_method)
    end

    private

    def tracker_tag_and_measured_method
      [@tracker, @tag, @measured_method]
    end
  end
end
