class OdkForm < ActiveRecord::Base
  belongs_to :mapping

  has_many :odk_fields, dependent: :destroy

  accepts_nested_attributes_for :odk_fields

  before_create :populate_fields

  protected

  def populate_fields
    current_user = mapping.user
    odk = OdkAggregate::Connection.new(current_user.odk_url, current_user.odk_username, current_user.odk_password)
    odk_form_fields = odk.find_form(self.name).fields.collect do |f|
      index = f["nodeset"].index("/", 1)
      {
        field_name: f["nodeset"][index..-1],
        field_type: f["type"],
        group: f["group"]
      }
    end

    odk_form_fields.each do |odk_form_field|
      self.odk_fields.build({
        field_name: odk_form_field[:field_name],
        field_type: odk_form_field[:field_type],
        repeat_field: odk_form_field[:group],
        uuidable: odk_form_field[:field_name] == "/meta/instanceID"
      }) unless self.odk_fields.detect{|field| field.field_name.eql?(odk_form_field[:field_name])}
    end
  end
end
