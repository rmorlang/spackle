class MissingEnd
  class << self
    def a_method
      true
    # end <-- this is missing
  end
end
