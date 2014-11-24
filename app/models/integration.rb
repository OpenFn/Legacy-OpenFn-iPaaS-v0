#designsketch

class Integration < ActiveRecord::Base
  belongs_to :user

  has_one :source_credential # polymorphism! Could be our generated api key or a 3rd party credential
  has_one :destination_credential # polymorphism! Could be our generated api key or a 3rd party credential

  #schema:
  # create_table :integrations do |t|
  #   t.integer :user_id
  #   t.string :name
  # end
end