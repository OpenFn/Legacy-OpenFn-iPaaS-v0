class OdkSfLegacy::SalesforceField < ActiveRecord::Base

  belongs_to :salesforce_object

  has_many :odk_field_salesforce_fields, dependent: :destroy
  has_many :odk_fields, through: :odk_field_salesforce_fields

  has_one :salesforce_relationship

  SYSTEM_FIELDS = %w{
    ConnectionReceivedId
    ConnectionSentId
    CreatedById
    Id
    IsDeleted
    LastActivityDate
    LastModifiedDate
    SystemModstamp
  }

  scope :without_excluded, -> { 
    where("((#{table_name}.properties->'autoNumber') IS NULL OR (#{table_name}.properties->>'autoNumber') = 'false')").
    where("((#{table_name}.properties->'calculated') IS NULL OR (#{table_name}.properties->>'calculated') = 'false')").
    where("((#{table_name}.properties->'createable') IS NULL OR (#{table_name}.properties->>'createable') = 'true')").
    where("COALESCE(#{table_name}.properties->>'name',#{table_name}.field_name) NOT IN (?)",SYSTEM_FIELDS)
  }

  default_scope { without_excluded }

  # .properties - JSON object

end
