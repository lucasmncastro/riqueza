class Recorrencia < ActiveRecord::Base 
  has_one :movimento
  
  # Array com os dias da semana se intervalo = semana.
  serialize  :dias_semana
  
  # Array de datas em que a recorrencia vai acontecer.
  serialize  :parcelas  
  
  def initialize(params={})
    params[:tipo] ||= 'para sempre'
    super
  end
  
  # Verifica se pode ocorrer num determinado dia da semana (abreviado).
  def no_dia_da_semana?(dia)
    return false unless intervalo == 'semana'
    dias = self.dias_semana || []
    dias.include? dia
  end
  
  # Verifica se pode ocorrer num determinado diad do mes.
  def no_dia_do_mes?(dia)
    return false unless intervalo == 'mês'
    dia_mes == dia
  end
  
  # Verifica se pode ocorrer no mesmo dia do ano.
  def no_mesmo_dia_do_ano?(data)
    return false unless intervalo == 'ano'
    data_inicial.day == data.day and data_inicial.month == data.month
  end
  
  # Verifica se pode ocorrer todo dia.
  def todo_dia?
    intervalo == 'dia'
  end
  
  # Verifica se a data informada está dentro dos dias (semana, mes ou ano) configurados.
  def dentro_dos_dias?(data)
    case intervalo
      when 'semana':
        no_dia_da_semana?    data.strftime('%a')
      when 'mês':
        no_dia_do_mes?       data.day
      when 'ano':
        no_mesmo_dia_do_ano? data
      else # todo dia
        true
    end    
  end
  
  # Verifica se a data vem depois da data inicial e antes da data final (ou quantidade de vezes).
  def dentro_do_prazo?(data)
    return false unless data > data_inicial
    
    case tipo
      when 'para sempre':
        true
      when 'até':
        data < data_final
      else # tantas vezes
        self.parcelas.include?(data)
    end
  end
  
  def pode_repetir_em?(data)
    dentro_dos_dias? data and dentro_do_prazo? data
  end
  
  def descobre_parcelas
    datas = []
    
    data  = data_inicial    
    cont  = 0
    while cont < repeticoes
      data = data + 1.day
      
      if dentro_dos_dias? data
        cont += 1 
        datas << data
      end
    end
    
    datas
  end
end