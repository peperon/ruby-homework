describe "Crypto" do
  it "Can do simple encryption" do
    encrypter = Caeser.new 4
    encrypter.encrypt('hello').should eq 'lipps'
  end

  it "Can do simple decryption" do
    encrypter = Caeser.new 4
    encrypter.decrypt('lipps').should eq 'hello'
  end

  it "Can encrypt with custom alphabet" do
    encrypter =  Caeser.new 3, 'ACTG'
    encrypter.encrypt('ACCTGA').should eq 'GAACTG'
  end

  it "Can encrypt with large shift" do
    encrypter = Caeser.new 30
    encrypter.encrypt('hello').should eq 'lipps'
  end
end
