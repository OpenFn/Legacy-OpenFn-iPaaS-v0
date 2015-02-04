class OdkSfLegacy::Mapping < ActiveRecord::Base
  self.table_name = "odk_sf_legacy_mappings"

  belongs_to :user
  has_many :salesforce_objects, dependent: :destroy

  has_one :odk_form, dependent: :destroy
  has_one :import
  has_many :odk_fields, through: :odk_form

  accepts_nested_attributes_for :odk_form

  validates :name, presence: true
  validates :odk_form, presence: true

  validate do |mapping|
    if mapping.enabled_changed?(to: true)
      mapping.errors[:base] << "You need more credits to enable this mapping. Contact the administrator or disable any currently-enabled mappings to get more." unless MappingLimiter.new(mapping.user).credits_available?
    end
  end

  scope :enabled, -> { where(enabled: true) }

  def can_be_enabled
    enabled || OdkSfLegacy::MappingLimiter.new(user).credits_available?
  end

  # overwrite the default object dup
  def duplicate

    # => clone the mapping using deep_clonable with all the associations
    new_mapping = self.deep_clone(include: [{salesforce_objects: :salesforce_fields} , {odk_form: {odk_fields: {odk_field_salesforce_fields: {salesforce_field: :salesforce_object}}}}], use_dictionary: true)

    # => Change the name of the new mapping
    new_mapping.name = new_mapping.name + "_copy"


    # => The problem is the relationships are not populating properly because they are not linking back to the newly created salesforce object
    # => They are referencing the already existing one
    # => So we have build this relationship ourselves
    new_mapping.salesforce_objects.each do |sf_obj|

      # => get the original object
      original_object = self.salesforce_objects.detect{|obj| obj.name.eql?(sf_obj.name) && obj.order.eql?(sf_obj.order)}

      # => loop through the new objects salesforce fields
      sf_obj.salesforce_fields.each do |sf_field|

        # => get the original field
        original_field = original_object.salesforce_fields.detect{|fld| fld.field_name.eql?(sf_field.field_name)}

        # => if there is a relationship on this field
        if original_field.salesforce_relationship

          # => clone the relationship
          salesforce_relationship = original_field.salesforce_relationship.deep_clone

          # => Set the salesforce_field to the newly created field
          salesforce_relationship.salesforce_field = sf_field

          # => Get the existing object this relationship is referencing
          rel_sf_obj = original_field.salesforce_relationship.salesforce_object

          # => Find the corresponding object in our new_record objects
          new_mapping_rel_obj = new_mapping.salesforce_objects.detect{|obj| obj.name.eql?(rel_sf_obj.name) && obj.order.eql?(rel_sf_obj.order)}

          # => Set the salesforce_object on the new_record relationship
          salesforce_relationship.salesforce_object = new_mapping_rel_obj

          # => Set the relationship on the new_record field
          sf_field.salesforce_relationship = salesforce_relationship

          # => Add the relationship to the new_record salesforce_object
          new_mapping_rel_obj.salesforce_relationships << salesforce_relationship
        end

      end
    end

    new_mapping
  end

end
