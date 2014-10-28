class SeedProducts < ActiveRecord::Migration
  def up
    product_hashes = [
      {
        active_source: false,
        active_destination: true,
        name: "Salesforce",
        logo_path: "logos/salesforce-logo.png",
        inactive_logo_path: "logos/salesforce-logo-inactive.png"
      },
      {
        active_source: true,
        active_destination: false,
        name: "OpenDataKit",
        logo_path: "logos/odk-logo.png",
        inactive_logo_path: "logos/odk-logo-inactive.png"
      },
      {
        active_source: false,
        active_destination: false,
        name: "Telerivet",
        logo_path: "logos/telerivet-logo.png",
        inactive_logo_path: "logos/telerivet-logo-inactive.png"
      },
      {
        active_source: false,
        active_destination: false,
        name: "KopoKopo",
        logo_path: "logos/kopokopo-logo.png",
        inactive_logo_path: "logos/kopokopo-logo-inactive.png"
      }
    ]

    Product.transaction do
      product_hashes.each do |product_properties|
        Product.create!(product_properties)
      end
    end
  end

  def down
    Product.destroy_all
  end
end
