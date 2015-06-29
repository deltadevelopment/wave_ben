require 'rails_helper'

describe Ripple do

  it { should belong_to(:interaction) }
  it { should belong_to(:user) }


end
