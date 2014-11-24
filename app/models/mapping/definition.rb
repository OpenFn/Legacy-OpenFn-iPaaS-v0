#designsketch

class Mapping::Definition < ActiveRecord::Base
  belongs_to :integration

  # schema:
  # create_table :mapping_definitions do |t|
  #   t.integer :integration_id
  #   t.string :source_field
  #   t.string :destination_field
  #   # metadata?????
  # end
end