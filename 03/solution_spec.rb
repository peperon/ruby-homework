require 'treetop'
Treetop.load 'parser'

describe "Expressions" do
  def parse(input)
    ArithmeticParser.new.parse(input).to_sexp
  end

  def build(string)
    Expr.build parse(string)
  end

  def evaluate(string, env = {})
    build(string).evaluate(env)
  end

  def simplify(string)
    build(string).simplify
  end

  def derive(string)
    build(string).derive(:x)
  end

  it "Supports evaluation" do
    evaluate('2').should eq 2
    evaluate('x', {x: 2}).should eq 2
    evaluate('1 + 2').should eq 3
    evaluate('x + 2', {x: 2}).should eq 4
    evaluate('x + 2 + 3 + y', {x: 1, y: 2}).should eq 8
    evaluate('2 * 3').should eq 6
    evaluate('x * 2', {x: 2}).should eq 4
    evaluate('x * x * x', {x: 2}).should eq 8
    evaluate('-2').should eq(-2)
    evaluate('-x', {x: 2}).should eq(-2)
    evaluate('sin(0)').should eq 0
    evaluate("cos(#{Math::PI / 2})").should be_within(0.0001).of(0)
  end

  it "Supports comparison" do
    build('2').should eq build('2')
    build('2').should_not eq build('3')
    build('1 + 2 * 3').should eq build('1 + 2 * 3')
    build('x + 2').should_not eq build('2 + x')
  end

  it "Supports simplify" do
    build('1').simplify.should eq build('1')
    build('x').simplify.should eq build('x')
    build('1 + 2').simplify.should eq build('3')
    build('x + 1').simplify.should eq build('x + 1')
    build('x + 0').simplify.should eq build('x')
    build('0 + x').simplify.should eq build('x')
    build('x + y').simplify.should eq build('x + y')
    build('x + (x + 0)').simplify.should eq build('x + x')
    build('1 * 2').simplify.should eq build('2')
    build('x * 2').simplify.should eq build('x * 2')
    build('x * 1').simplify.should eq build('x')
    build('1 * x').simplify.should eq build('x')
    build('x * 0').simplify.should eq build('0')
    build('0 * x').simplify.should eq build('0')
    simplify('2 + x + 2').should eq build('x + 4')
    simplify('2 * (x * 0)').should eq build('0')
    simplify('0 + 1 * (3 * 0)').should eq build('0')
    simplify('-2').should eq build('-2')
    simplify('2 + (-2)').should eq build('0')
    simplify('(-x) + 3').should eq build('-x + 3')
    build('x + (x + (2 + -2))').simplify.should eq build('x + x')
    simplify('sin(0)').should eq build('0.0')
    simplify('sin(x)').should eq build('sin(x)')
    simplify('sin(x*0)').should eq build('0.0')
  end

  it "can derive expressions" do
    derive('1').should eq build('0')
    derive('x').should eq build('1')
    derive('y').should eq build('0')
    derive('1 + 2').should eq build('0')
    derive('x + 1').should eq build('1')
    derive('x + x').should eq build('2')
    derive('x + y').should eq build('1')
    derive('1 * 1').should eq build('0')
    derive('x * x').should eq build('x + x')
    derive('x * x * x').should eq build('x * x + x * (x + x)')
    derive('sin(x)').should eq build('cos(x)')
    derive('cos(x)').should eq build('-sin(x)')
  end
end
