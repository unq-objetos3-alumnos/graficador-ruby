require_relative 'lib/graficador'
require_relative 'lib/ejemplo/espadachin'

File.new('diagrama.puml', 'w').write(
  Graficador.new.graficar(Espadachin)
)
