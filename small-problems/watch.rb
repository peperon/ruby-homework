watch('.\.rb') do
  system 'clear'
  system 'rspec solution6_test.rb --require ./solution6.rb --colour --format documentation'
end
