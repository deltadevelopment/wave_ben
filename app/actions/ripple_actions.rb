class RippleActions

  def initialize(ripple: nil, param: nil)
    @ripple = ripple
    @param = param 
  end

  def create!
    ripple = Ripple.find_or_create_by(trigger: @ripple.trigger, seen_at: nil)  

    ripple.message  = @ripple.message
    ripple.triggee  = @ripple.triggee
    ripple.pushable = @ripple.pushable
    ripple.user     = @ripple.user

    ripple.save!

  end

end
