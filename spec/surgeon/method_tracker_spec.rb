# frozen_string_literal: true

RSpec.describe Surgeon::MethodTracker do
  let(:klass) do
    Class.new do
      def dink_around
        14 * 3
      end
    end
  end

  let(:session) { Surgeon::Session.new }

  let(:label) { :"#{klass.name}#dink_around" }

  let!(:instance) do
    described_class.new(
      klass,
      :dink_around,
      session
    )
  end

  let(:measurement) { session.measurements.measurement(label) }

  let(:object) { klass.new }

  it 'does nothing by default with a method' do
    expect(object.dink_around).to eq(42)
    expect(session.measurements).to be_none
  end

  it 'tracks when attached' do
    instance.attach!
    expect(object.dink_around).to eq(42)
    expect(session.measurements).to be_any
    expect(measurement.count).to eq(1)
  end

  it 'can track attached and then be detached' do
    instance.attach!
    expect(object.dink_around).to eq(42)
    expect(session.measurements).to be_any
    expect(measurement.count).to eq(1)
    expect(object.dink_around).to eq(42)
    instance.detach!
    expect(object.dink_around).to eq(42)
    expect(measurement.count).to eq(2)
  end
end
