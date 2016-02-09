defmodule Physics.Rocketry do
  import Calcs
  import Physics.Laws

  def escape_velocity(:earth) do
    Planets.earth
      |> escape_velocity
  end

  def escape_velocity(:moon) do
    Planets.moon
      |> escape_velocity
  end

  def escape_velocity(:mars) do
    Planets.mars
      |> escape_velocity
  end

  def escape_velocity(planet) when is_map(planet) do
    planet
      |> calculate_velocity
      |> to_km
      |> to_nearest_tenth
  end

  def orbital_speed(height), do: orbital_speed(Planets.earth, height)
  def orbital_speed(planet, height) do
    (newtons_gravitational_constant * planet.mass) / orbital_radius(planet.radius, height)
      |> square_root
  end

  def orbital_acceleration(height), do: orbital_acceleration(Planets.earth, height)
  def orbital_acceleration(:earth, height), do: orbital_acceleration(Planets.earth, height)
  def orbital_acceleration(:mars, height), do: orbital_acceleration(Planets.mars, height)
  def orbital_acceleration(:moon, height), do: orbital_acceleration(Planets.moon, height)
  def orbital_acceleration(planet, height) do
    (orbital_speed(planet, height) |> squared) / orbital_radius(planet.radius, height)
      |> to_nearest_hundredth
  end

  def orbital_term(height), do: orbital_term(Planets.earth, height)
  def orbital_term(:earth, height), do: orbital_term(Planets.earth, height)
  def orbital_term(:mars, height), do: orbital_term(Planets.mars, height)
  def orbital_term(:moon, height), do: orbital_term(Planets.moon, height)
  def orbital_term(planet, height) do
    (4 * (:math.pi |> squared) * (orbital_radius(planet.radius, height) |> cubed)) /
      (newtons_gravitational_constant * planet.mass)
      |> square_root
      |> seconds_to_hours
  end

  def height_for_orbital_term(hours), do: height_for_orbital_term(Planets.earth, hours)
  def height_for_orbital_term(:earth, hours), do: height_for_orbital_term(Planets.earth, hours)
  def height_for_orbital_term(:mars, hours), do: height_for_orbital_term(Planets.mars, hours)
  def height_for_orbital_term(:moon, hours), do: height_for_orbital_term(Planets.moon, hours)
  def height_for_orbital_term(planet, hours) do
    radius_in_meters = (newtons_gravitational_constant * planet.mass * (hours |> hours_to_seconds |> squared)) / (4 * (:math.pi |> squared))
      |> cube_root

    subtract_planet(radius_in_meters, planet.radius)
      |> to_km
  end

  defp calculate_velocity(%{mass: mass, radius: radius}) do
    (2 * newtons_gravitational_constant * mass ) / radius
      |> square_root
  end

  defp orbital_radius(radius_in_m, height_in_km) do
    radius_in_m + (height_in_km |> to_m)
  end

  defp subtract_planet(total_radius, planet_radius), do: total_radius - planet_radius
end
