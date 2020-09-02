module Defensor
  attr_reader :vida
  attr_reader :defensa

  def initialize(defensa:, vida:)
    @defensa = defensa
    @vida = vida
  end

  def recibir_daño(cantidad_de_daño)
    daño_final = cantidad_de_daño - @defensa
    @vida -= daño_final if daño_final > 0
  end

  def recuperarse
    # +2 vida
  end
end
