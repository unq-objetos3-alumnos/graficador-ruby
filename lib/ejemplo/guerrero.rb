require_relative './unidad'
require_relative './defensor'
require_relative './atacante'

class Guerrero < Unidad
  include Defensor
  include Atacante

  def initialize(fuerza:, defensa:, vida:)
    @fuerza = fuerza
    @defensa = defensa
    @vida = vida
  end

  def ataque
    @fuerza
  end
end
