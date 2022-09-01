# frozen_string_literal: true

RSpec.describe Surgeon::MeasurementSet do
  let(:instance) { described_class.new }
  let(:foo_measurement) { instance.measurement(:foo) }

  it 'can dynamically provide measurements' do
    expect(foo_measurement).to be_a(Surgeon::Measurement)
  end

  it 'keeps a reference to the measurement' do
    expect(instance.measurement(:foo)).to be(foo_measurement)
  end

  it 'sets the label of the measurement' do
    expect(foo_measurement.label).to eq('foo')
  end

  it 'can determine if there are any measurements' do
    expect(instance.any?).to be(false)
    foo_measurement
    expect(instance.any?).to be(true)
  end
end
