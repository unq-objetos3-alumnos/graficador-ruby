require_relative './guerrero'

class Espadachin < Guerrero
  def initialize(coeficiente_espada:, **args)
    super(**args)
    @coeficiente_espada = coeficiente_espada
  end

  def ataque
    super * @coeficiente_espada
  end
end
