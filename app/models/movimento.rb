class Movimento < ActiveRecord::Base
  belongs_to :recorrencia
  has_many   :filhos, 
             :foreign_key => 'pai_id', 
             :class_name  => 'Movimento',
             :dependent   => :destroy
           
  belongs_to :pai, :foreign_key => 'pai_id', :class_name => 'Movimento'
  has_and_belongs_to_many :tags
  
  attr_accessor :recorrente
  
  validates_presence_of :titulo, :data, :valor
  
  before_save :preenche_parcelas_recorrencia
  before_save :atualiza_recorrencia

  protected 
  
  def atualiza_recorrencia
    if self.recorrente.blank?
      self.recorrencia.destroy rescue nil
      self.recorrencia = nil
    else
      self.recorrencia.data_inicial = data
      self.recorrencia.save!
    end
  end

  # Preenche o campo de parcelas.
  def preenche_parcelas_recorrencia
    return unless recorrencia
    
    if recorrencia.tipo == 'por'
      recorrencia.data_inicial = data
      recorrencia.parcelas = recorrencia.descobre_parcelas
    else
      recorrencia.parcelas = nil
    end
  end

  
  public
  
  def recorrencia_attributes=(attrs)
    if recorrencia
      self.recorrencia.attributes = attrs
    else
      self.build_recorrencia attrs
    end
  end
  
  def recorrente
    return @recorrente unless @recorrente.nil?
    not recorrencia.nil?
  end
  
  def pode_repetir_em?(data)
    return false unless recorrente
    recorrencia.pode_repetir_em?(data)
  end
  
  def recorrencia_attributes
    self.recorrencia || {}
  end
  
  def receita?
    not despesa?
  end
  
  def despesa?
    tipo == 'Despesa'
  end
  
  def gera_filho(data)
    filho = self.clone
    
    filho.pai = self
    filho.data = data
    filho.data_prevista = data
    filho.recorrente = false
    filho.tags = self.tags
    
    filho
  end
  
  def eh_meu_filho?(suposto_filho)
    filhos.include? suposto_filho
  end
  
  # Verifica se nesse array de movimentos tem algum que é filho.
  def tem_um_filho?(array)
    filhos_encontrados = array.select {|m| self.eh_meu_filho?(m) }

    filhos_encontrados.size != 0
  end
  
  def tags_list
    self.tags.collect {|t| t.name }.join(', ')
  end
  
  def tags_list=(string)
    self.tags = string.split(',').collect {|s| Tag.find_or_create_by_name(s.strip) }
  end
  
  class << self
    def saldo(movimentos)
      saldo = 0
      movimentos.each do |m| 
        valor = m.valor
        
        if m.despesa?
          saldo -= valor
        else
          saldo += valor
        end
      end

      saldo
    end
    
    def saldo_do_dia(data)
      movimentos = Movimento.find_all_by_data data
      saldo(movimentos)
    end
    
    def find_by_tag(tag)
      Movimento.find :all, :include => 'tags', :conditions => ["tags.name = ?", tag]
    end
 
    # TODO Renomear para find_all_by_mes    
    def find_by_mes(data)
      Movimento.find :all, :conditions => ["month(data) = ? and year(data) = ? ", data.month, data.year]
    end
    
    def find_all_agendados_by_data(data)
      movimentos = find :all, :conditions => ['data < ? ', data]
      movimentos.select {|m| m.pode_repetir_em?(data) }
    end
    
    def find_all_agendados_by_mes(data)
      movimentos = find :all, :conditions => ['data < ? ', data]
      movimentos.select {|m| m.pode_repetir_em?(data) }
    end

    def saldo_do_mes(data)
      saldo(find_by_mes(data))
    end
  end 

end
