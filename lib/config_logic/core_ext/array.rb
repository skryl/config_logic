class Array

  def stringify_symbols
    self.map { |val| val.is_a?(Symbol) ? val.to_s : val }
  end

  def symbolize_strings
    self.map { |val| val.is_a?(Symbol) ? val.to_s : val }
  end

  def to_hash
    self.inject({}) { |h, (key, val)| h[key] = val; h }
  end

end
