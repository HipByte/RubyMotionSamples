class Application < MG::Application
  def start
    director = MG::Director.shared
    director.show_stats = true
    director.run(MainScene.new)
  end
end
