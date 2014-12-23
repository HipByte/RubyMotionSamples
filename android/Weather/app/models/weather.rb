class Weather
  attr_reader :observations, :temp, :wind_direction, :wind_speed

  def initialize(json)
    @observations = json.getJSONObject("observations")
    @temp = latest_observation.getString("air_temp")
    @wind_speed = latest_observation.getString("wind_spd_kmh")
    @wind_direction = latest_observation.getString("wind_dir")
  end

  private

  def latest_observation
    @latest_observation ||= observations.getJSONArray("data").getJSONObject(0)
  end
end
