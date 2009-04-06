class Tag < ActiveRecord::Base
  has_and_belongs_to_many :movimentos

  def self.find_tag_cloud  
    find_by_sql "select t.name, (count(*) / (select count(*) from tags) + 1.0) as score
                 from tags t, movimentos_tags m 
                 where m.tag_id = t.id
                 group by t.name
                 order by t.name"
  end
end
