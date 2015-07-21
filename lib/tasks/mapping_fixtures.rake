require 'fileutils'

namespace :db do 
  namespace :fixtures do 

    desc 'Create YAML test fixtures from data in an existing database. 
    Defaults to development database. Set RAILS_ENV to override.' 

    def to_file(mapping_name,table_name,data)
        
      path = Rails.root.to_s + "/spec/fixtures/#{mapping_name}"
      FileUtils::mkdir_p path

      File.open("#{path}/#{table_name}.yml", 'w') do |file| 
        i = "000" 

        file.write data.inject({}) { |hash, record| 
          hash["#{table_name}_#{i.succ!}"] = record 
          hash 
        }.to_yaml 

        puts "Found #{i} records for #{table_name}"

      end 
    end

    def execute_query(query)
      ActiveRecord::Base.connection.select_all(query) 
    end

    OBJECTS = {
      users:  ->(id) {
        User.joins(:mappings).where(odk_sf_legacy_mappings: {id: id}).to_sql
      },
      odk_sf_legacy_mappings: ->(id) {
        OdkSfLegacy::Mapping.where(id: id).to_sql
      },
      legacy_odk_field_salesforce_fields: ->(id) {
        OdkSfLegacy::OdkFieldSalesforceField.joins(salesforce_field: :salesforce_object).where(odk_sf_legacy_salesforce_objects: {mapping_id: id}).to_sql
      },
      legacy_salesforce_relationships: ->(id) {
        OdkSfLegacy::SalesforceRelationship.joins(:salesforce_object).where(odk_sf_legacy_salesforce_objects: {mapping_id: id}).to_sql 
      },
      odk_sf_legacy_salesforce_objects: ->(id) {
        OdkSfLegacy::SalesforceObject.where(mapping_id: id).to_sql
      },
      odk_sf_legacy_salesforce_fields: ->(id) {
        OdkSfLegacy::SalesforceField.unscoped.joins(:salesforce_object).where(odk_sf_legacy_salesforce_objects: {mapping_id: id}).to_sql
      },
      odk_sf_legacy_odk_fields: ->(id) {
        OdkSfLegacy::OdkField.joins(:odk_form).where(odk_sf_legacy_odk_forms: {mapping_id: id}).to_sql
      },
      odk_sf_legacy_imports: ->(id) {
        OdkSfLegacy::Import.where(mapping_id: id).to_sql
      },
      odk_sf_legacy_submissions: ->(id) {
        OdkSfLegacy::Submission.joins(:import).where(odk_sf_legacy_imports: {mapping_id: id}).to_sql
      }
    }

    task :dump, [:mapping_id] => [:environment] do |t,args|
      unless args[:mapping_id]
        puts "Please provide a mapping id - e.g. rake db:fixtures:dump[1]" 
        exit 1
      end

      mapping_id = args[:mapping_id]

      mapping = OdkSfLegacy::Mapping.find(mapping_id)
      ActiveRecord::Base.establish_connection(:development) 

      OBJECTS.each { |table_name,query|
        to_file mapping.name.gsub(/ /,"_").underscore, table_name, execute_query(query[mapping_id])
      }
    end 
  end 
end 
