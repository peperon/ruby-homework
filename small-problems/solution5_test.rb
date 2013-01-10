describe "Abomination" do
  it "Can answer of the undefined methods, defined in the inner objects" do
    a = Abomination.new 5, 'foo', [1, 2], :bar
    a.abs.should eq 5
    a.gsub('o', 'a').should eq 'faa'
    a.join(',').should eq "1,2"
  end

  it "Fails when the called method is undefined in the inner objecs" do
    a = Abomination.new :test
    lambda { a.foo }.should raise_error(NoMethodError)
  end

  it "Can indentify itself with the inner objects" do
    a = Abomination.new 5, 'foo', [1, 2], :bar
    a.is_a?(Fixnum).should eq true
    a.is_a?(String).should eq true
    a.is_a?(Symbol).should eq true
    a.is_a?(Float).should eq false
    a.is_a?(Abomination).should eq true
  end
end
