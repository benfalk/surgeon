# frozen_string_literal: true

RSpec.describe Surgeon do
  let(:klass) do
    Class.new do
      def dink
        7 * 11
      end
    end
  end

  let(:test_obj) { klass.new }

  it 'has a version number' do
    expect(Surgeon::VERSION).not_to be nil
  end

  it 'can track events' do
    expect(Surgeon.prepare_for_surgery!).to be_nil
    expect(Surgeon.track(:smack)).to be_nil
    expect(Surgeon.track(:troll) { 'troll' }).to eq('troll')
    expect(Surgeon.report).to be_a(String)
  end

  it 'can track method calls it attaches to' do
    Surgeon.track_method!(klass, :dink)
    expect(Surgeon.prepare_for_surgery!).to be_nil
    expect(test_obj.dink).to eq(77)
    expect(Surgeon.report).to be =~ /  #dink: \(0001\) \(0\.\d{6}\)/
  end
end
