require 'odk_client'
class OdkForm < ActiveRecord::Base
  belongs_to :mapping

  has_many :odk_fields, dependent: :destroy

  accepts_nested_attributes_for :odk_fields

  before_create :populate_fields

  protected

  def populate_fields
    current_user = mapping.user
    client = OdkClient.new( current_user.odk_url, username: current_user.odk_username, password: current_user.odk_password )

    client.get_form(self.name).parse.sort_by_grouping.each do |field|
      odk_fields.build({
        field_name: field[:path],
        field_type: field[:type],
        repeat_field: !!field[:repeat],
        uuidable: field[:path] == "/meta/instanceID"
      })
    end

  end
end
