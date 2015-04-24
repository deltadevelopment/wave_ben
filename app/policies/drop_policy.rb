class DropPolicy < ApplicationPolicy

  def generate_upload_url?
    is_logged_in?    
  end

end
