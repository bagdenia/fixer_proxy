require 'rails_helper'

RSpec.describe GetRates do
  subject { described_class.new(params).call }
  let(:params) do
    {
      'base' => 'EUR',
      'other' => 'USD',
      'date' => date
    }
  end
  let(:date) { '2020-03-02' }
  let(:expected_body) do
    {
      success: true,
      timestamp: 1_581_811_199,
      historical: true,
      base: 'EUR',
      date: date,
      rates: {
        USD: 1.083085
      }
    }
  end

  before do
    stub_request(:get, /.*fixer.*/)
      .to_return(status: 200, body: expected_body.to_json, headers: {})
  end

  context 'no rates entries for given params' do
    it do
      expect { subject }.to change(Rate, :count).by(1)
    end

    it do
      expect(subject.success).to be true
    end
  end

  context 'entry for given params exist' do
    before do
      create(:rate, rate: 1, **params.transform_keys(&:to_sym))
    end

    it do
      expect { subject }.not_to change(Rate, :count)
    end

    it do
      expect(subject.success).to be true
    end
  end

  context 'not valid flow' do
    let(:date) { 'invalid_date' }

    let(:expected_body) do
      {
        "success": false,
        "error": {
          "code": 302,
          "type": 'invalid_date',
          "info": 'You have entered an invalid date. [Required format: date=YYYY-MM-DD]'
        }
      }
    end

    before do
      stub_request(:get, /.*fixer.*/)
        .to_return(status: 200, body: expected_body.to_json, headers: {})
    end

    it do
      expect { subject }.not_to change(Rate, :count)
    end

    it do
      expect(subject.success).to be false
    end
  end
end
