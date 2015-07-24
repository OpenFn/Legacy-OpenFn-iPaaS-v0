class CreateCaseStudies < ActiveRecord::Migration
  def change
    create_table :case_studies do |t|
    	t.string :title
    	t.string :org_name
    	t.text :body
    	t.string :picture_url
    	t.integer :order
      t.timestamps
    end
  end
end
