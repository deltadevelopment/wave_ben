require 'rails_helper'

describe Watcher do

  it { should belong_to(:watchable) }

end
