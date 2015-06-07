class RippleActions

  def initialize(ripple: nil, param: nil)
    @ripple = ripple
    @param = param 
  end

  def create!
      
    @ripple.save!

  end

end
