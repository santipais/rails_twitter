# frozen_string_literal: true

class AddFollowsCountToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.integer :follows_count, null: false, default: 0
      t.integer :followers_count, null: false, default: 0
    end
  end
end
