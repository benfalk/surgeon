# frozen_string_literal: true

RSpec.describe Surgeon::Measurement do
  context 'tracking without a block' do
    before do
      subject.track
    end

    it 'has a count of one' do
      expect(subject.count).to eq(1)
    end

    it 'has a total time of zero' do
      expect(subject.total_time).to eq(0)
    end

    it 'returns nil when called' do
      expect(subject.track).to be_nil
    end
  end

  context 'tracking with a block' do
    let!(:value) do
      subject.track do
        sleep(0.001)
        :foobar
      end
    end

    it 'returns the yield result' do
      expect(value).to be(:foobar)
    end

    it 'has a count of one' do
      expect(subject.count).to eq(1)
    end

    it 'has a total_time greater than zero' do
      expect(subject.total_time).to be > 0
    end
  end

  context 'recursive calls of itself' do
    let(:klass) do
      Class.new do
        attr_reader :measurement

        def initialize
          @measurement = Surgeon::Measurement.new
        end

        def rolling_sum(number, total = 0)
          @measurement.track do
            return total if number.zero?

            rolling_sum(number - 1, total + number)
          end
        end
      end
    end

    let(:counter) { klass.new }
    let(:measurement) { counter.measurement }
    let(:data) { measurement.instance_variable_get(:@data) }

    it 'correctly counts the calls and records outer time' do
      expect(counter.rolling_sum(3)).to eq(6)
      expect(measurement.count).to eq(4)
      expect(measurement.total_time).to be > 0

      # Peeking into data to make sure only the outer most call
      # has time recorded for it
      expect(data.last).to be > 0
      expect(data[0..2]).to all(be_zero)
    end
  end
end
