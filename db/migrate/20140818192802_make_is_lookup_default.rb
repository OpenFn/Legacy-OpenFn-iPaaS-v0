class MakeIsLookupDefault < ActiveRecord::Migration
  def change
    change_column :salesforce_fields, :is_lookup, :boolean, default: false
  end
end
