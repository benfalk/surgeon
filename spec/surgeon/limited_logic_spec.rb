# frozen_string_literal: true

RSpec.describe Surgeon::LimitedLogic do
  it 'has a limit of one by default' do
    count = 0

    while subject.run { count += 1 } != :limit_exceeded
      raise 'over the limit!' if count > 1
    end

    expect(count).to eq(1)
  end

  context 'with a custom limit' do
    subject { described_class.new(3) }

    it 'runs the code to the limit' do
      count = 0

      while subject.run { count += 1 } != :limit_exceeded
        raise 'over the limit!' if count > 3
      end

      expect(count).to eq(3)
    end
  end
end
