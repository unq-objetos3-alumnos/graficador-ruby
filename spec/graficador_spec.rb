require 'graficador'

describe 'graficador' do
  # Hacemos esto porque queremos que las constantes que definimos en los tests
  # (por ejemplo, ClaseAGraficar) estén definidas sólo en el contexto del test
  # en el cual fueron definidas, y que no vivan más allá de eso.
  around do |test|
    constantes_ya_definidas = Object.constants

    test.run

    constantes_definidas_por_el_test = Object.constants - constantes_ya_definidas
    constantes_definidas_por_el_test.each do |nombre_constante|
      Object.send(:remove_const, nombre_constante)
    end
  end

  it 'incluye la clase BasicObject en el gráfico' do
    graficador = Graficador.new

    declaraciones_diagrama = graficador.diagrama_de(BasicObject)

    expect(declaraciones_diagrama).
      to include(declaracion_clase("BasicObject"))
  end

  it 'grafica la superclase de la clase a graficar' do
    graficador = Graficador.new

    ClaseAGraficar = Class.new(BasicObject)
    declaraciones_diagrama = graficador.diagrama_de(ClaseAGraficar)

    expect(declaraciones_diagrama).
      to include(
        declaracion_clase("BasicObject"),
        relacion_herencia("BasicObject", "ClaseAGraficar")
      )
  end

  it 'grafica mixines' do
    graficador = Graficador.new

    Mixin1 = Module.new
    Mixin2 = Module.new
    ClaseAGraficar = Class.new(BasicObject) { include Mixin1, Mixin2 }

    declaraciones_diagrama = graficador.diagrama_de(ClaseAGraficar)

    expect(declaraciones_diagrama).
      to include(
        declaracion_mixin("Mixin1"),
        declaracion_mixin("Mixin2"),
        relacion_mixin("Mixin1", "ClaseAGraficar"),
        relacion_mixin("Mixin2", "ClaseAGraficar")
      )
  end

  it 'mixines superclase' do
    graficador = Graficador.new

    Mixin1 = Module.new
    Mixin2 = Module.new
    ClaseConMixines = Class.new(BasicObject) { include Mixin1, Mixin2 }

    ClaseAGraficar = Class.new(ClaseConMixines)

    declaraciones_diagrama = graficador.diagrama_de(ClaseAGraficar)

    expect(declaraciones_diagrama).
      to include(
        declaracion_mixin("Mixin1"),
        declaracion_mixin("Mixin2"),
        relacion_mixin("Mixin1", "ClaseConMixines"),
        relacion_mixin("Mixin2", "ClaseConMixines")
      )
  end

  it 'testeo' do
    graficador = Graficador.new

    MixinBase = Module.new
    MixinConMixin = Module.new { include MixinBase }
    ClaseAGraficar = Class.new(BasicObject) { include MixinConMixin }

    declaraciones_diagrama = graficador.diagrama_de(ClaseAGraficar)

    expect(declaraciones_diagrama).
      to include(
        declaracion_mixin("MixinBase"),
        declaracion_mixin("MixinConMixin"),
        relacion_mixin("MixinBase", "ClaseAGraficar"),
        relacion_mixin("MixinConMixin", "ClaseAGraficar")
      )

    ClaseAGraficar2 = Class.new(BasicObject) { include MixinBase }
    expect(declaraciones_diagrama).
      to include(
        declaracion_mixin("MixinBase"),
      )
  end

  def declaracion_mixin(nombre_modulo)
    "class \"#{nombre_modulo}\" << (M, orchid) mixin >>"
  end

  def relacion_mixin(nombre_modulo, nombre_subclase)
    "\"#{nombre_modulo}\" <|-.- \"#{nombre_subclase}\""
  end

  def relacion_herencia(nombre_superclase, nombre_subclase)
    "\"#{nombre_superclase}\" <|-- \"#{nombre_subclase}\""
  end

  def declaracion_clase(nombre_clase)
    "class \"#{nombre_clase}\" << (C, lightblue) >>"
  end
end
