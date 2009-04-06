class CreateRecorrencias < ActiveRecord::Migration
  def self.up
    create_table :recorrencias do |t|
      t.date    :data_inicial  # Data inicial considerada para os calculos (= data do movimento).
      t.string  :tipo          # por, até, para sempre
      t.string  :intervalo     # dia, mes, semana, ano
      t.string  :dias_semana   # dias da semana se intervalo = semana
      t.integer :dia_mes       # dia do mes     se intervalo = mes
      t.integer :repeticoes, :default => 0    # quantidade de vezes se tipo = por
      t.date    :data_final    # se tipo = até

      t.text    :parcelas      # Array de datas em q a ocorrencia vai se repetir em caso de tipo por
      
      t.timestamps
    end
  end

  def self.down
    drop_table :recorrencias
  end
end
