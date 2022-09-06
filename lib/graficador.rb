class Graficador
  def initialize
    @clases_graficadas = []
  end

  def graficar(una_clase)
    <<~PLANTUML
      @startuml
        hide empty members
        set namespaceseparator none
        #{diagrama_de(una_clase).join("\n  ")}
      @enduml
    PLANTUML
  end

  def diagrama_de(una_clase)
    return [] if @clases_graficadas.include?(una_clase)

    @clases_graficadas << una_clase

    [ 'class "' + una_clase.name + '" << (C, lightblue) >>' ] +
      diagrama_de_superclase_de(una_clase) +
      diagrama_de_mixines_de(una_clase) +
      diagrama_de_clase_de(una_clase)
  end

  private

  def diagrama_de_clase_de(una_clase)
    diagrama_de(una_clase.class) +
      ['"' + una_clase.class.name + '" <-- "' + una_clase.name + '"']
  end

  def diagrama_de_mixines_de(una_clase)
    if una_clase.superclass.nil?
      modulos_incluidos = una_clase.included_modules
    else
      modulos_incluidos = una_clase.included_modules - una_clase.superclass.included_modules
    end

    modulos_incluidos.flat_map do |modulo|
      ['class "' + modulo.name + '" << (M, orchid) mixin >>',
        '"' + modulo.name + '" <|-.- "' + una_clase.name + '"'] +
        diagrama_de_clase_de(modulo)
    end
  end

  def diagrama_de_superclase_de(una_clase)
    return [] if una_clase.superclass.nil?

    diagrama_de(una_clase.superclass) +
      ['"' + una_clase.superclass.name + '" <|-- "' + una_clase.name + '"']
  end

end