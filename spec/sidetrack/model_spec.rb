require 'spec_helper'

RSpec.describe 'event methods' do
  let(:apple) { Fruit.create(name: 'Apple') }
  let(:tracking) { apple.trackings.first }
  describe '#{event}!' do
    context 'default with no time set' do
      before { apple.harvested! }

      it 'sets a timestamp for the event to now by default' do
        expect(tracking.happened_at).to be_within(1.second).of(Time.now)
      end

      it 'sets the event type' do
        expect(tracking.event).to eq('harvested')
      end

    end

    context 'with timestamp set' do
      it 'sets the timestamp to when the event happened' do
        harvested_at = Time.now.ago(1.week)
        apple.harvested!(harvested_at)
        expect(tracking.happened_at).to eq(harvested_at)
      end

      it 'updates the tracking if no history kept' do
        apple.harvested!(1.week.ago)
        apple.harvested!
        expect(apple.trackings.count).to eq(1)
        expect(tracking.happened_at).to be_within(1.second).of(Time.now)
      end
    end
  end

  describe '#{event}_at' do
    before { apple.harvested! }
    it 'returns the timestamp for the event' do
      expect(apple.harvested_at).to be_within(1.second).of(Time.now)
    end
  end

  describe '#{event}?' do
    it 'returns false if event has not happened' do
      expect(apple.harvested?).to eq(false)
    end

    it 'returns true if event has happened' do
      apple.harvested!
      expect(apple.harvested?).to eq(true)
    end
  end

  context 'with history' do
    let(:carrot) { Vegetable.create(name: 'carrot') }

    it 'keeps a historical track of when event happened' do
      now = Time.now
      last_week = now.ago(1.week)
      last_month = now.ago(1.month)
      [last_week, now, last_month].each do |at|
        carrot.harvested!(at)
      end
      expect(carrot.harvested_history).to eq([now, last_week, last_month])
    end

  end

  context 'with actor' do
    let(:wheat) { Grain.create(name: 'wheat') }
    let(:frank) { Farmer.create(name: 'Frank') }
    let(:greg) { Gardener.create(name: 'Greg') }

    describe '#{event}_by' do
      fit 'tracks the actor for the event' do
        last_month = Time.now.ago(1.month)
        wheat.sown!(last_month, actor: frank)
        wheat.weeded!(actor: greg)
        expect(wheat.sown_by).to eq(frank)
        expect(wheat.sown_at).to eq(last_month)
        expect(wheat.weeded_by).to eq(greg)
      end
    end
  end

end
