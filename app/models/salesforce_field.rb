class SalesforceField < ActiveRecord::Base

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
    where("((properties->'autoNumber') IS NULL OR (properties->>'autoNumber') = 'false')").
    where("((properties->'calculated') IS NULL OR (properties->>'calculated') = 'false')").
    where("((properties->'createable') IS NULL OR (properties->>'createable') = 'true')").
    where("COALESCE(properties->>'name',field_name) NOT IN (?)",SYSTEM_FIELDS)
  }

  default_scope { without_excluded }

  # .properties - JSON object

end
