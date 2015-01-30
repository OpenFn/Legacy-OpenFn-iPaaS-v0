namespace :db do 
  namespace :fixtures do 

    desc 'Create YAML test fixtures from data in an existing database. 
    Defaults to development database. Set RAILS_ENV to override.' 

    def to_file(table_name,data)
      File.open(Rails.root.to_s + "/spec/fixtures/#{table_name}.yml", 'w') do |file| 
        i = "000" 

        file.write data.inject({}) { |hash, record| 
          hash["#{table_name}_#{i.succ!}"] = record 
          hash 
        }.to_yaml 

      end 
    end

    def execute_query(query)
      ActiveRecord::Base.connection.select_all(query) 
    end

    OBJECTS = {
      users:  ->(id) {
        User.joins(:mappings).where(mappings: {id: id}).to_sql
      },
      mappings: ->(id) {
        Mapping.where(id: id).to_sql
      },
      salesforce_objects: ->(id) {
        SalesforceObject.where(mapping_id: id).to_sql
      },
      odk_field_salesforce_fields: ->(id) {
        OdkFieldSalesforceField.joins(salesforce_field: :salesforce_object).where(salesforce_objects: {mapping_id: id}).to_sql
      },
      salesforce_fields: ->(id) {
        SalesforceField.unscoped.joins(:salesforce_object).where(salesforce_objects: {mapping_id: id}).to_sql
      },
      odk_fields: ->(id) {
        OdkField.joins(:odk_form).where(odk_forms: {mapping_id: id}).to_sql
      },
      salesforce_relationships: ->(id) {
        SalesforceRelationship.joins(:salesforce_object).where(salesforce_objects: {mapping_id: id}).to_sql 
      },
      imports: ->(id) {
        Import.where(mapping_id: id).to_sql
      },
      submissions: ->(id) {
        Submission.joins(:import).where(imports: {mapping_id: id}).to_sql
      }
    }

    task :dump, [:mapping_id] => [:environment] do |t,args|
      unless args[:mapping_id]
        puts "Please provide a mapping id - e.g. rake db:fixtures:dump[1]" 
        exit 1
      end

      mapping_id = args[:mapping_id].to_i
      ActiveRecord::Base.establish_connection(:development) 

      OBJECTS.each { |table_name,query|
        to_file table_name, execute_query(query[mapping_id])
      }
    end 
  end 
end 
