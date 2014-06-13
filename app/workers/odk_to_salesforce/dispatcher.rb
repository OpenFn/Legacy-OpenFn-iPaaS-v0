module OdkToSalesforce
  class Dispatcher

    @queue = :importer

    def self.perform(mapping_id, only = nil)
      mapping = Mapping.find mapping_id
      new.perform(mapping, only)
    end

    def perform(mapping, only)
      # Load the log of the import for this ODK form
      import = Import.find_or_create_by(odk_formid: mapping.odk_formid)

      # => Load the ODK information
      odk = OdkToSalesforce::Odk.new(mapping.odk_formid, import)

      # => Get the submissions from the ODK object
      # => The submissions only come back as IDs
      only = odk.submissions.length if only.nil?
      submissions = odk.submissions[0...only]

      # => If there are submissions to process
      if submissions.size > 0

        # => Create a converter object from our mapping
        converter = OdkToSalesforce::Converter.new(mapping)

        # => Load the Salesforce information
        salesforce = OdkToSalesforce::Salesforce.new

        # => Create a runner object that will do the processing
        runner = OdkToSalesforce::Runner.new(salesforce.relationships)

        # => Go through each submission to be processed
        submissions.each_with_index do |submission, i|

          # => Get the ODK Data for this submission from the ID
          odk_data = odk.fetch_submission(submission)

          # => Use the converter to take the mapping and ODK data and create a SF Import Data object
          sf_data = converter.convert(odk_data)

          # => Create a list of ImportObjects
          bottom_objects = []

          # => Go through each branch of the SF object tree
          salesforce.leaf_nodes.each_with_index do |k, ii|
            puts "\n\n-> dispatching submission #{i + 1} of #{submissions.length} on leaf node #{ii + 1} of #{salesforce.leaf_nodes.size} (#{k})".yellow

            # => We have the bottom object with all it's parent relationships
            # => Add it to the array of bottom objects
            bottom_objects << runner.run(k.to_sym, sf_data) if sf_data.has_key?(k.to_sym)
          end

          # => Process all the ImportObjects
          process_bottom_objects(bottom_objects)

          import.update(last_uuid: submission)
        end
      end
    end

    # => This function will traverse all the bottom objects and merge them into 1 tree
    # => and return the top most object which will then be created with all it's children
    def process_bottom_objects(bottom_objects)
      other_bottom_objects = []

      # => Loop through all bottom objects
      bottom_objects.each do |bo|
        # => If the bottom object is stand-alone, create it
        if bo.parent.nil?
          bo.save!
        else
          # => This object has parents, put it in an array and process them later
          other_bottom_objects << bo
        end
      end

      # => Combine all bottom objects to get a complete heirarchy
      # => This will give you a bottom object that has a parent
      # => This parent can have a parent
      # => It will have children
      obj = other_bottom_objects.reduce(:+)

      while obj.parent
        obj = obj.parent
      end

      # => Save the top most object
      obj.save!
    end
  end
end
