module SpackleErrorFixture
  def spackle_error_fixture
    Spackle::Error.new "CATASTROPHE: the milk was spilled! Begin crying? [Y/n]" do |e|
      e.add_error "/clutzy/child/waving/arms", 1
      e.add_error "/cupboard/shelf/glass", 350
      e.add_error "/fridge/shelf/jug/milk", 4
    end
  end
end

