describe "BinaryMobile" do
  it "Can calculate simple BinaryMobile weight" do
    b1 = Branch.new 10, 3
    b2 = Branch.new 8, 4.2
    b3 = Branch.new 10, BinaryMobile.new(Branch.new(1, 0), Branch.new(8, 4.2))

    bm = BinaryMobile.new b1, b3
    bm.weight.should eq 7.2
  end

  it "Can balance structure" do
    b1 = Branch.new 10, 3
    b2 = Branch.new 8, 4.2

    bm = BinaryMobile.new b1, b2
    bm.balanced?.should eq false
    
    bm = BinaryMobile.new Branch.new(1, 2), Branch.new(2, 1)
    bm.balanced?.should eq true
  end

  it "Can balance structure with sub BinaryMobile's" do
    bm1 = BinaryMobile.new Branch.new(1, 2), Branch.new(2, 1)
    bm  = BinaryMobile.new Branch.new(1, 3), Branch.new(1, bm1)
    bm.balanced?.should eq true
  end

  it "Fails with unbalanced sub BinaryMobile" do
    bm1 = BinaryMobile.new Branch.new(2, 2), Branch.new(2, 1)
    bm  = BinaryMobile.new Branch.new(1, 3), Branch.new(1, bm1)
    bm.balanced?.should eq false
  end
end
