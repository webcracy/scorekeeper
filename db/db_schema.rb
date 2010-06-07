ActiveRecord::Migration.verbose = false

def create_db_schema
  
  ActiveRecord::Schema.define do
  
   create_table :games do |table|
       table.column :title, :string
       table.column :description, :text
       table.column :created_at, :timestamp
   end
   
   create_table :players do |table|
       table.column :name, :string
       table.column :email, :string
       table.column :created_at, :timestamp
   end
   
   create_table :rounds do |table|
       table.column :game_id, :int
       table.column :created_at, :timestamp
   end
   
   create_table :games_players, :id => false do |table|
     table.column :game_id, :int
     table.column :player_id, :int
   end 

   create_table :players_rounds, :id => false do |table|
     table.column :round_id, :int
     table.column :player_id, :int
   end
   
   create_table :rounds_games do |table| 
     table.column :round_id, :int
     table.column :game_id, :int
     table.column :created_at, :timestamp
   end
   
   create_table :score_items do |table|
     table.column :player_id, :int
     table.column :round_id, :int
     table.column :game_id, :int
     table.column :score, :int
     table.column :created_at, :timestamp
   end
   
   create_table :cards do |table|
     #belongs_to_many => :hands
     table.column :value, :string
     table.column :colour, :string
     table.column :name, :string
   end
   
   create_table :hands do |table|
     #has_many => :cards
     table.column :player_id, :int
     table.column :round_id, :int
   end
   
  end #Schema define do
end #def create_db_schema