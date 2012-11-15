class Magic
  def self.magic_square? square
    return true if square[0].empty?
    constant =  (0...square.size).map { |i| square[i][i] }.inject(&:+)
    magic    =  constant == (0...square.size).map { |i| square.reverse[i][i] }.inject(&:+)
    magic    &= square.all? { |row| row.inject(&:+) == constant }
    magic    &= square.transpose.all? { |column| column.inject(&:+) == constant }
  end
end
