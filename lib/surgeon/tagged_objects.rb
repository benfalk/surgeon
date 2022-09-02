# frozen_string_literal: true

module Surgeon
  # Dynamic Object Collection
  class TaggedObjects
    include Enumerable

    def initialize(klass = nil, &block)
      factory = klass&.method(:new) || block

      @objects = Hash.new do |hash, key|
        hash[key] = factory.call
      end
    end

    def [](key)
      @objects[key]
    end

    def each(&block)
      @objects.each_value(&block)
    end
  end
end
