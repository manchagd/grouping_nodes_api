class CreateJoinTableNodesTags < ActiveRecord::Migration[7.2]
  def change
    create_join_table :nodes, :tags do |t|
      t.index [:node_id, :tag_id], unique: true
      # t.index [:tag_id, :node_id]
    end
  end
end
