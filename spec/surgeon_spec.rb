# frozen_string_literal: true

RSpec.describe Surgeon do
  it 'has a version number' do
    expect(Surgeon::VERSION).not_to be nil
  end

  it 'can track events' do
    expect(Surgeon.prepare_for_surgery!).to be_nil
    expect(Surgeon.track(:smack)).to be_nil
    expect(Surgeon.track(:troll) { 'troll' }).to eq('troll')
    expect(Surgeon.report).to be_a(String)
  end
end
