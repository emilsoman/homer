module Homer
  class Error < StandardError; end
  class AddressParseError < Error; end
  class HomerfileNotFound < Error; end
  class HomerfileEmpty < Error; end
  class HomerfileCorrupt < Error; end
  class HomerAlreadyInitialized < Error; end
  class HomerNotInitialized < Error; end
end
