class Tag < ActiveRecord::Base
  
  attr_accessor :tag_string
  # TODO Add validation for tag_string

  belongs_to :taggable, polymorphic: true
  belongs_to :taggee, polymorphic: true

  validates :tag_string, format: { with: /\A(#[a-z]\w*)|(@\w+)\z/i, message: I18n.t('validation.tag_string_format') }

end
