class ErrorRaiser
  class << self
    def a_method
      raise "an unhandled error"
    end 
  end
end
