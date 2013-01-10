# encoding: utf-8

class Caeser
  def initialize(shift, alphabet = 'abcdefghijklmnopqrstuvwxyz')
    @original = alphabet
    @shifted  = @original.chars.to_a.rotate(shift).join
  end

  def encrypt(word)
    word.chars.map { |char| @original.index char }.map { |index| @shifted[index] }.join
  end

  def decrypt(word)
    word.chars.map { |char| @shifted.index char }.map { |index| @original[index] }.join
  end
end

test = Caeser.new 2, "асдасдадд"
