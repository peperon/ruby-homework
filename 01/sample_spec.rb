describe "Integer#prime_divisors" do
  it "can partition a simple number" do
    10.prime_divisors.should eq [2, 5]
  end
end

describe "Integer#prime_divisors" do
  it "can partition a negative number" do
    -10.prime_divisors.should eq [2, 5]
  end
end

describe "Integer#prime_divisors" do
  it "can't partition a 0, 1" do
    1.prime_divisors.should eq []
  end
end

describe "Integer#prime_divisors" do
  it "can partition some more numbers" do
    42.prime_divisors.should eq [2, 3, 7]
    36.prime_divisors.should eq [2, 3]
    42.prime_divisors.should eq [2, 3, 7]
    17.prime_divisors.should eq [17]
  end
end

describe "Range#fizzbuzz" do
  it "works with the example in assignment" do
    (1..6).fizzbuzz.should eq [1, 2, :fizz, 4, :buzz, :fizz]
    (1..15).fizzbuzz.should eq [1, 2, :fizz, 4, :buzz, :fizz, 7, 8, :fizz, :buzz, 11, :fizz, 13, 14, :fizzbuzz]
    (1...15).fizzbuzz.should eq [1, 2, :fizz, 4, :buzz, :fizz, 7, 8, :fizz, :buzz, 11, :fizz, 13, 14]
    (-5...4).fizzbuzz.should eq [:buzz, -4, :fizz, -2, -1, :fizzbuzz, 1, 2, :fizz]
  end
end

describe "Hash#group_values" do
  it "maps each value to an array of keys" do
    {a: 1}.group_values.should eq 1 => [:a]
    {a: 1, b: 2, c: 1}.group_values.should eq 1 => [:a, :c], 2 => [:b]
  end
end

describe "Array#densities" do
  it "maps each element to the number of occurences in the original array" do
    [].densities.should eq []
    [:a, :b, :c].densities.should eq [1, 1, 1]
    [:a, :b, :a].densities.should eq [2, 1, 2]
    [:a, :a, :a].densities.should eq [3, 3, 3]
  end
end
