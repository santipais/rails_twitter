# frozen_string_literal: true

class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false
      t.string :bio
      t.string :website
      t.date :birthdate, null: false
    end
  end
end
