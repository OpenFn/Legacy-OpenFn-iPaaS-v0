class ChangeAllNullSlowMigrationsToFalse < ActiveRecord::Migration
  def up
    OdkSfLegacy::Mapping.where(slow: nil).update_all(slow: false)
    OdkSfLegacy::Mapping.where(enabled: nil).update_all(enabled: false)
  end

  def down
  end
end
