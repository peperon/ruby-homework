class Bitmap
  def initialize(bytes, row_length = bytes.length)
    @bytes      = bytes.map { |byte| byte.to_s(2).rjust(8, '0') }.join
    @row_length = row_length * 8
  end

  def to_s
    @bytes.gsub('0', '.').gsub('1', '#').scan(Regexp.new '.' * @row_length).join "\n"
  end
end
