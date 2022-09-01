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
end
