watch('.\.rb') do
  system 'clear'
  system 'rspec solution5_test.rb --require ./solution5.rb --colour --format documentation'
end
