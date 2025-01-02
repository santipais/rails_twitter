# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:tweet) { build(:tweet) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(280) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).counter_cache(true) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:likers).through(:likes).source(:user) }
    it { is_expected.to have_many_attached(:images) }
    it { is_expected.to validate_content_type_of(:images).allowing('image/png', 'image/gif', 'image/jpeg') }
    it { is_expected.to validate_size_of(:images).less_than(1.megabyte) }
  end
end
