# frozen_string_literal: true

RSpec.describe Surgeon::TaggedObjects do
  context 'with a provided class' do
    subject { described_class.new(String) }

    it 'produces the expected objects by key' do
      expect(subject).to be_none
      expect(subject[:ben]).to be_a(String)
      subject[:ben] << 'sup dawg'
      expect(subject[:ben]).to eq('sup dawg')
      expect(subject).to be_any
    end
  end

  context 'with a provided factory block' do
    subject { described_class.new { 'hello'.dup } }

    it 'produces the expected objects by key' do
      expect(subject).to be_none
      expect(subject[:greeting]).to eq('hello')
      subject[:greeting] << ' world!'
      expect(subject[:greeting]).to eq('hello world!')
      expect(subject).to be_any
    end
  end
end
