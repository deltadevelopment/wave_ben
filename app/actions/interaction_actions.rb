class InteractionActions
  
  def initialize(interaction: nil, param: nil)
    @interaction = interaction
    @param = param
  end

  def create!
    if @interaction.save!
      GenerateRippleJob.perform_later(@interaction, @param)
    end

    @interaction
  end

end
