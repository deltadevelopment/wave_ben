require 'rails_helper'

describe InteractionActions do
  let(:interaction) { FactoryGirl.build(:interaction) }

  it "saves the record" do
    expect{
      InteractionActions.new(interaction: interaction).create!
    }.to change(Interaction, :count).by(1)
  end

end
