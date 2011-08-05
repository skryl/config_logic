class Array

  def stringify_symbols!
    self.map! { |val| val.to_s if val.is_a? Symbol }
  end

  def symbolize_strings!
    self.map! { |val| val.to_s if val.is_a? Symbol }
  end

  def to_hash
    self.inject({}) { |h, (key, val)| h[key] = val; h }
  end

end
