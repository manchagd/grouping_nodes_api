class CreateJoinTableNodesTags < ActiveRecord::Migration[7.2]
  def change
    create_join_table :nodes, :tags do |t|
      t.index [:node_id, :tag_id], unique: true
    end
  end
end
