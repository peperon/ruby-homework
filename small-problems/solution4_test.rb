describe "Bitmap" do
  it "Can create bitmap" do
    bitmap = Bitmap.new [1, 10, 100], 3
    bitmap.to_s.should eq ".......#....#.#..##..#.."
  end

  it 'Work without second parameter' do
    bitmap = Bitmap.new [1, 10, 100]
    bitmap.to_s.should eq ".......#....#.#..##..#.."
  end

  it "Can create multiline bitmaps" do
    bitmap = Bitmap.new [1, 10, 100], 1
    bitmap.to_s.should eq ".......#\n....#.#.\n.##..#.."
  end
end
