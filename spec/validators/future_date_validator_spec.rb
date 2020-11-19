require 'rails_helper'

class Validatable
    include ActiveModel::Validations
    attr_accessor :date
    validates :date, future_date: true
end

RSpec.describe FutureDateValidator do
  subject { Validatable.new }

  context 'when date is before the current date' do
    before { subject.date = 1.day.ago }

    it 'should be invalid' do
      expect(subject.valid?).to be_falsy
    end

    it 'adds an error on model' do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context 'when date is equal the current date' do
    before { subject.date = Time.zone.now }

    it 'should be invalid' do
      expect(subject.valid?).to be_falsy
    end

    it 'adds an error on model' do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context 'when date is after the current date' do
    before { subject.date = Time.zone.now + 1.day }

    it 'should be valid' do
      expect(subject.valid?).to be_truthy
    end
  end
end