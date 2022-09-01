# frozen_string_literal: true

module Surgeon
  # Tracks different labeled calls
  class SimpleReport
    Row = Struct.new(:label, :call_count, :total_time) do
      # @param max_label_size [Integer]
      def to_s(max_label_size)
        format(
          format_string,
          label: label.rjust(max_label_size),
          call_count: call_count,
          time: total_time
        )
      end

      def format_string
        return '%<label>s: (%<call_count>04d)' if total_time.zero?

        '%<label>s: (%<call_count>04d) (%<time>0.6f)'
      end
    end

    # @param measurements [MeasurementSet]
    def initialize(measurements)
      @rows = measurements.map do |measurement|
        Row.new(
          measurement.label,
          measurement.count,
          measurement.total_time
        )
      end
    end

    # @return [String]
    def to_s
      @rows
        .sort_by { |row| - row.total_time }
        .inject(["Surgeon's Report:"]) do |report, row|
          report << row.to_s(max_label_size)
        end
        .join("\n")
    end

    private

    def max_label_size
      return 0 if @rows.none?

      @max_label_size ||=
        @rows
        .max { |left, right| left.label.size <=> right.label.size }
        .label
        .size + 2
    end
  end
end
