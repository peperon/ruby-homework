describe "Magic" do
  it "Can calculate square" do
    result = Magic.magic_square? [[2, 7, 6], [9, 5, 1], [4, 3, 8]]
    result.should eq true
  end

  it "Fail on not magic square" do
    Magic.magic_square?([[1, 2], [1, 1]]).should eq false
  end

  it "Not fail on one element matrix" do
    Magic.magic_square?([[1]]).should eq true
  end

  it "Not fail on empty matrix" do
    Magic.magic_square?([[]]).should eq true
  end
end
