module Wave

  class Error < StandardError; end

  class ClientError < Error; end

  class InvalidParameters < ClientError; end

  class NotFound < ClientError; end

end
