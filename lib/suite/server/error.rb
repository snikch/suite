module Suite
  module ServerError
    def not_found
      [404, {}, "Resource not found"]
    end
  end
end
