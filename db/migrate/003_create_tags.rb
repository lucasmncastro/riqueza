class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end

    create_table :movimentos_tags, :id => false do |t|
      t.references :movimento, :tag
    end
  end

  def self.down
    drop_table :tags
    drop_table :movimentos_tags
  end
end
