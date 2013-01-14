describe "Robot" do
  it "Simple tests" do
    robot { move; move; mark; move; mark; }.should eq [2, 3]
    robot(9) { move; mark; mark; move; move; mark; }.should eq [10, 10, 12]
    robot(1000000) {}.should eq []
    robot(-50) { mark; move; move; mark }.should eq [-50, -48]
    robot(2.13) { mark; move; move; mark; move; }.should eq [2.13, 4.13] 
  end
end
