class MappingLimiter

  def initialize(user)
    @user = user
    @active_mappings = user.mappings.enabled.order('created_at ASC')
  end

  def valid?
    (@user.credits || 0) >= @active_mappings.count
  end

  def credits_available?
    ((@user.credits || 0) - @active_mappings.count) > 0
  end

  def limit!
    unless valid?
      @active_mappings[@user.credits .. -1].each do |mapping|
        mapping.enabled = false
        mapping.save!
      end
    end
  end
end