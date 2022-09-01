# frozen_string_literal: true

RSpec.describe Surgeon::SimpleReport do
  let(:measurements) do
    Surgeon::MeasurementSet.new.tap do |m|
      m.measurement(:foo).track
      m.measurement(:foo).track
      m.measurement(:bart).track

      # Setting the data of baz to repeatble results
      m.measurement(:baz).instance_variable_get(:@data) << 0.000004
    end
  end

  let(:instance) { described_class.new(measurements) }

  describe '#to_s' do
    subject { instance.to_s }

    it 'generates a nice report' do
      expect(subject).to eq(<<~REPORT.rstrip)
        Surgeon's Report:
           baz: (0001) (0.000004)
           foo: (0002)
          bart: (0001)
      REPORT
    end
  end
end
