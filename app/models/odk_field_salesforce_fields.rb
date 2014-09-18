class OdkFieldSalesforceFields < ActiveRecord::Base
  belongs_to :odk_field
  belongs_to :salesforce_field
end
