class OdkSfLegacy::MappingLimiter

  def initialize(user)
    @user = user
    @active_mappings = user.mappings.enabled.order('created_at ASC')
  end

  def valid?
    (@user.plan.map_limit || 0) >= @active_mappings.count
  end

  def credits_available?
    ((@user.plan.map_limit || 0) - @active_mappings.count) > 0
  end

  def limit!
    unless valid?
      @active_mappings[@user.plan.map_limit .. -1].each do |mapping|
        mapping.enabled = false
        mapping.save!
      end
    end
  end
end