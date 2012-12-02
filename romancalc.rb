require_relative "./roman.rb"

# def pass; end

class Calc

  A_NUM, R_NUM, MATH = /^[0-9]$/, /^[ivxlcm]$/i, /^[\+\-\(\)]$/
  ROMAN = /^M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/i
  A_TYPE, R_TYPE, MATH_TYPE = 0, 1, 2
  ROMANS = {
    'M'  => 1000,
    'CM' => 900,
    'D'  => 500,
    'CD' => 400,
    'C'  => 100,
    'XC' => 90,
    'L'  => 50,
    'XL' => 40,
    'X'  => 10,
    'IX' => 9,
    'V'  => 5,
    'IV' => 4,
    'I'  => 1,
  }

  def calculate(str)
    begin
      res = eval(tokenize(str).map {|i|
        case i[0]
        when MATH_TYPE
          i[1]
        when A_TYPE
          "#{i[1]}"
        when R_TYPE
          "#{i[2]}"
        end
      }.join)
    rescue SyntaxError
      "Syntax error"
    rescue Exception => e 
       e.message 
    else
      roman = ""
      begin
        roman = "#{Roman.new(res)}"
      rescue RomanException
        # pass
      end
      if roman != ""
        "#{roman} #{res}"
      else
        "#{res}"
      end
    end 
  end

  private

  def roman2decimal(roman)
    res = 0
    ROMANS.each do |k, v|
      while roman.index(k) === 0
        res += v
        roman = roman[k.size, roman.size]
      end
    end
    res
  end

  def tokenize(str)
    i = 0
    tokens = []
    while i < str.size

      case str[i]
      when /\s/
        i+=1
      when MATH
        tokens << [MATH_TYPE, str[i]]
        i+=1
      when A_NUM
        t = ''
        begin
          t += str[i]; i += 1
        end while A_NUM.match(str[i]) and i < str.size
        tokens << [A_TYPE, t.to_i]
      when R_NUM
        t = ''
        begin
          t += str[i]; i += 1
        end while R_NUM.match(str[i]) and i < str.size
        if t !~ ROMAN
          msg = "#{str}\n"
          msg += ' '*(i-1) + "^ Incorrect roman number #{t} at position #{i}"
          raise msg
        end
        tokens << [R_TYPE, t, roman2decimal(t.upcase)]
      else
        msg = "#{str}\n"
        msg += ' '*i + "^ Unacceptable symbol #{str[i]} at position #{i}"
        raise msg
      end
    end
    tokens
  end

end
