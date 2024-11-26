# frozen_string_literal: true

class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :first_name
      t.string :last_name
      t.string :bio
      t.string :website
      t.date :birthdate, null: false, default: '01/01/1980'
    end
  end
end
