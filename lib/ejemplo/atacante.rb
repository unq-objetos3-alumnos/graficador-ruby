module Atacante
  def atacar_a(defensor)
    defensor.recibir_daño(ataque)
  end

  def ataque
    raise 'subclass responsibility'
  end

  def recuperarse
    # +2 daño
  end
end