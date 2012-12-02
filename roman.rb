class RomanException < Exception; end

class Roman
  MAX_ROMAN = 4999
  attr_reader :value
  protected :value
  def initialize(value)
    if value <= 0 || value > MAX_ROMAN
      raise RomanException, "Roman values must be > 0 and <= #{MAX_ROMAN}"
    end
    @value = value
  end

  def coerce(other)
    if Integer === other
      [ other, @value ]
    else
      [ Float(other), Float(@value) ]
    end
  end

  def +(other)
    if Roman === other
      other = other.value
    end
    if Fixnum === other && (other + @value) < MAX_ROMAN
      Roman.new(@value + other)
    else
      x, y = other.coerce(@value)
      x + y
    end
  end

  FACTORS = [["M", 1000], ["CM", 900], ["D", 500], ["CD", 400],
             ["C", 100], ["XC", 90], ["L", 50], ["XL", 40],
             ["X", 10], ["IX", 9], ["V", 5], ["IV", 4], ["I", 1]]

  def to_s
    value = @value
    roman = ""
    for code, factor in FACTORS
      count, value = value.divmod(factor)
      roman << (code * count)
    end
    roman
  end
end

=begin
iv = Roman.new(4)
xi = Roman.new(11)
puts iv + 3 # => vii
puts iv + 3 + 4 # => xi
puts iv + 3.14159 # => 7.14159
puts xi + 4900 # => mmmmcmxi
puts xi + 4990 # => 5001
puts Roman.new(7000) + 1
=end
