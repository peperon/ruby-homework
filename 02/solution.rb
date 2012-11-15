class Song
  attr_reader :name, :artist, :album

  def initialize(name, artist, album)
    @name, @artist, @album = name, artist, album
  end

  def meets_criteria?
    yield self
  end
end

class Criteria
  attr_reader :proc

  def initialize(&block)
    @proc = Proc.new &block
  end

  def self.name(text)
    Criteria.new { |song| song.name == text }
  end

  def self.artist(text)
    Criteria.new { |song| song.artist == text }
  end

  def self.album
    Criteria.new { |song| song.album == text }
  end

  def |(criteria)
    Criteria.new do |song|
      @proc.call(song) or criteria.proc.call(song)
    end
  end

  def &(criteria)
    Criteria.new do |song|
      @proc.call(song) and criteria.proc.call(song)
    end
  end

  def !
    Criteria.new { |song| not @proc.call(song) }
  end
end

class Collection
  include Enumerable

  attr_reader :songs

  def initialize(songs)
    @songs = songs
  end

  def self.parse(text)
    songs = []
    text.lines.each_slice(4) do |sliced|
      songs << Song.new(*sliced[0, 3].map(&:strip))
    end
    Collection.new(songs)
  end

  def each(&block)
    @songs.each(&block)
  end

  def names
    attribute_values(:name)
  end

  def artists
    attribute_values(:artist)
  end

  def albums
    attribute_values(:album)
  end

  def filter(criteria)
    filtered = select { |song| song.meets_criteria?(&criteria.proc) }
    Collection.new filtered
  end

  def adjoin(collection)
    Collection.new (@songs + collection.songs).uniq
  end

  private

  def attribute_values(attribute)
    map { |song| song.public_send(attribute) }.uniq
  end
end
