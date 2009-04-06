class CreateMovimentos < ActiveRecord::Migration
  def self.up
    create_table :movimentos do |t|
      t.string     :titulo
      t.text       :nota
      t.date       :data
      t.date       :data_prevista
      t.float      :valor
      t.string     :tipo
      t.references :recorrencia
      t.integer    :pai_id # Movimento q origiou esse (sem recorrencia)
      
      t.timestamps
    end
  end

  def self.down
    drop_table :movimentos
  end
end
