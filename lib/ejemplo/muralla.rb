require_relative './idad'
require_relative './fensor'

class Muralla < Unidad
  include Defensor

  def recuperarse
    super
    # +1 defensa
  end
end