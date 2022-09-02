# frozen_string_literal: true

RSpec.describe Surgeon::Session do
  it 'can track without a block' do
    expect(subject.track(:foo)).to be_nil
    expect(subject.measurements.measurement(:foo).count).to eq(1)
  end

  it 'can track with a block' do
    expect(subject.track(:foo) { :bar }).to eq(:bar)
    expect(subject.measurements.measurement(:foo).count).to eq(1)
  end

  it 'can run a block of code once' do
    count = 0
    subject.run_once { count += 1 }
    subject.run_once { count += 1 }
    expect(count).to eq(1)
  end

  it 'can run a block of code once under a label' do
    count = 0
    subject.run_once(:inc) { count += 1 }
    subject.run_once(:inc) { count += 1 }
    subject.run_once(:dec) { count -= 1 }
    subject.run_once(:dec) { count -= 1 }
    subject.run_once(:dec) { count -= 1 }
    expect(count).to eq(0)
  end
end
