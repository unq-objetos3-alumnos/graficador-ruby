require_relative './idad'
require_relative './acante'

class Fantasma < Unidad
  include Atacante

  def ataque
    20
  end

  def recuperarse
    # no hacer nada
  end
end
