# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { build(:tweet) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(280) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end