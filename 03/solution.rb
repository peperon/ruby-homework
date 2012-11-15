module ExprBase
  def +(other)
    Expr.new Addition.new self.expression, other.expression
  end

  def *(other)
    Expr.new Multiplication.new self.expression, other.expression
  end

  def -@
    Expr.new Negation.new @expression
  end
end

class Expr
  include ExprBase

  attr_reader :expression

  def self.build(expression)
    new ExpressionFactory.build(expression)
  end

  def initialize(expression)
    @expression = expression
  end

  def evaluate(env = {})
    visitor = EvaluateVisitor.new env
    @expression.accept visitor
  end

  def simplify
    visitor = SimplifyVisitor.new
    @expression.accept visitor
  end

  def derive(variable)
    visitor = DeriveVisitor.new variable
    @expression.accept visitor
  end

  def ==(other)
    @expression.to_s == other.to_s
  end

  def exact?
    @expression.exact?
  end

  def to_s
    @expression.to_s
  end
end

class ExpressionFactory
  def self.build(expression)
    case expression.first
      when :variable then Variable.new expression[1]
      when :number   then Number.new expression[1]
      when :-        then Negation.new build(expression[1])
      when :sin      then Sine.new build(expression[1])
      when :cos      then Cosine.new build(expression[1])
      when :+        then Addition.new build(expression[1]), build(expression[2])
      when :*        then Multiplication.new build(expression[1]), build(expression[2])
    end
  end
end

class Expression
  def accept
  end

  def to_s
  end
end

class Binary < Expression
  attr_reader :left_expression, :right_expression

  def initialize left_expression, right_expression
    @left_expression  = left_expression
    @right_expression = right_expression
  end

  def exact?
    as_array.any? { |expr| expr.exact? }
  end

  def as_array
    [@left_expression, @right_expression]
  end

  def not_exact
    as_array.select { |expr| not expr.exact? }
  end
end

class Multiplication < Binary
  def initialize(left_expression, right_expression)
    super left_expression, right_expression
  end

  def accept(visitor)
    visitor.visit_multiplication self
  end

  def to_s
    "(#{@left_expression.to_s} * #{@right_expression.to_s})"
  end
end

class Addition < Binary
  def initialize(left_expression, right_expression)
    super left_expression, right_expression
  end

  def accept(visitor)
    visitor.visit_addition self
  end

  def to_s
    "(#{@left_expression.to_s} + #{@right_expression.to_s})"
  end
end

class Unary < Expression
  attr_reader :inner

  def initialize(expression)
    @inner = expression
  end

  def exact?
    @inner.exact?
  end

  def as_array
    [@inner]
  end
end

class Sine < Unary
  def initialize(expression)
    super expression
  end

  def accept(visitor)
    visitor.visit_sine self
  end

  def to_s
    "sin(#{@inner.to_s})"
  end
end

class Cosine < Unary
  def initialize(expression)
    super expression
  end

  def accept(visitor)
    visitor.visit_cosine self
  end

  def to_s
    "cos(#{@inner.to_s})"
  end
end

class Negation < Unary
  def initialize(expression)
    super expression
  end

  def accept(visitor)
    visitor.visit_negation self
  end

  def to_s
    "(-#{@inner.to_s})"
  end
end

class Number < Unary
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def accept(visitor)
    visitor.visit_number self
  end

  def to_s
    @value.to_s
  end

  def exact?
    false
  end
end

class Variable < Unary
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def accept(visitor)
    visitor.visit_variable self
  end

  def to_s
    @value.to_s
  end

  def exact?
    true
  end
end

module VisitorBase
  private
  def visit(expression, type)
    @expression = expression
    public_send @method_name + "_" + type.to_s
  end

  def visit_instance(expression)
    if @additional_params != nil
      visitor = self.class.new(@additional_params)
    else
      visitor = self.class.new
    end
    expression.accept visitor
  end
end

class Visitor
  include VisitorBase

  def visit_number(number)
    visit number, :number
  end

  def visit_variable(variable)
    visit variable, :variable
  end

  def visit_addition(expression)
    visit expression, :addition
  end

  def visit_multiplication(expression)
    visit expression, :multiplication
  end

  def visit_negation(expression)
    visit expression, :negation
  end

  def visit_sine(expression)
    visit expression, :sine
  end

  def visit_cosine(expression)
    visit expression, :cosine
  end
end

class EvaluateVisitor < Visitor
  def initialize(env = {})
    @additional_params = env
    @method_name       = "evaluate"
  end

  def evaluate_number
    @expression.value
  end

  def evaluate_variable
    @additional_params[@expression.value]
  end

  def evaluate_addition
    @expression.as_array.inject(0) { |sum, expr| sum += visit_instance expr }
  end

  def evaluate_multiplication
    @expression.as_array.inject(1) { |prod, expr| prod *= visit_instance expr }
  end

  def evaluate_negation
    value = visit_instance @expression.inner
    -1 * value
  end

  def evaluate_sine
    value = visit_instance @expression.inner
    Math.sin value
  end

  def evaluate_cosine
    value = visit_instance @expression.inner
    Math.cos value
  end
end

class SimplifyVisitor < Visitor
  def initialize
    @method_name = "simplify"
  end

  def simplify_number
    Expr.new @expression
  end

  def simplify_variable
    Expr.new @expression
  end

  def simplify_addition
    simplified = @expression.as_array.map { |expr| visit_instance expr }
    if simplified.none?(&:exact?)
      Expr.new Number.new (simplified.first + simplified.last).evaluate
    elsif simplified.any? { |expr| not expr.exact? and expr.evaluate == 0 }
      simplified.select(&:exact?).first
    elsif not simplified.first.exact? and simplified.last.expression.as_array.any?(&:exact?)
      left = Exp.new(simplified.last.as_array.select(&:exact?).first)
      right = Expr.new(Number.new (simplified.first + Expr.new(simplified.last.expression.as_array.select { |x| not x.exact? }.first)).evaluate)
      left + right
    else
      simplified.first + simplified.last
    end
  end

  def simplify_multiplication
    simplified = @expression.as_array.map { |expr| visit_instance expr }
    if simplified.none?(&:exact?)
      Expr.new Number.new simplified.first.evaluate * simplified.last.evaluate
    elsif simplified.any? { |expr| not expr.exact? and expr.evaluate == 1 }
      simplified.select(&:exact?).first
    elsif simplified.any? { |expr| not expr.exact? and expr.evaluate == 0 }
      Expr.new Number.new 0
    else
      simplified.first * simplified.last
    end
  end

  def simplify_negation
    Expr.new @expression
  end

  def simplify_sine
    simplified = visit_instance @expression.inner
    if simplified.exact?
      Expr.new Sine.new simplified.expression
    else
      Expr.new Math.sin simplified.evaluate
    end
  end

  def simplify_cosine
    simplified = visit_instance @expression.inner
    if simplified.exact?
      Expr.new Cosine.new simplified.expression
    else
      Expr.new Math.cos simplified.evaluate
    end
  end
end

class DeriveVisitor < Visitor
  def initialize variable
    @method_name         = "derive"
    @additional_params   = variable
  end

  def derive_number
    Expr.new Number.new 0
  end

  def derive_variable
    if @additional_params == @expression.value
      Expr.new Number.new 1
    else
      Expr.new Number.new 0
    end
  end

  def derive_addition
    derived = @expression.as_array.map { |expr| visit_instance expr }
    (derived.first + derived.last).simplify
  end

  def derive_multiplication
    derived = @expression.as_array.map { |expr| visit_instance expr }
    left    = derived.first * Expr.new(@expression.right_expression)
    right   = Expr.new(@expression.left_expression) * derived.last
    (left + right).simplify
  end

  def derive_sine
    derived = visit_instance @expression.inner
    cosine  = Expr.new Cosine.new(@expression.inner)
    (derived * cosine).simplify
  end

  def derive_cosine
    derived = visit_instance @expression.inner
    sine    = Expr.new Sine.new(@expression.inner)
    (derived * -sine).simplify
  end
end
