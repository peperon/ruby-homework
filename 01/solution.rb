class Integer
  def prime_divisors
    (2..abs).select do |n|
      (2..Math.sqrt(n)).none? { |d| n % d == 0 } and self % n == 0
    end
  end
end

class Range
  def fizzbuzz
    map do |number|
      result = ""
      result << "fizz" if number % 3 == 0
      result << "buzz" if number % 5 == 0
      result.empty? ? number : result.to_sym
    end
  end
end

class Hash
  def group_values
    result = Hash.new { |hash, key| hash[key] = [] }
    each { |key, value| result[value] << key }
    result
  end
end

class Array
  def densities
    map do |element|
      select { |selected| selected == element }.count
    end
  end
end
