
class Game < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_and_belongs_to_many :rounds
  def add_player(player)
    self.players.push(player)
  end
end

class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_and_belongs_to_many :rounds
  has_and_belongs_to_many :score_items
end

class Round < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_and_belongs_to_many :games
  has_and_belongs_to_many :score_items
end

class ScoreItem < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_and_belongs_to_many :rounds
  has_and_belongs_to_many :games
  
  def self.find_all_by_round_player(round_id, player_id)
    self.find(:all, :conditions => ['round_id = ? and player_id = ?', round_id.to_s, player_id.to_s])
  end
  
  def self.find_first_by_round_player(round_id, player_id)
    self.find(:first, :conditions => ['round_id = ? and player_id = ?', round_id.to_s, player_id.to_s])
  end
  
  def self.find_all_by_player(player_id)
    self.find(:all, :conditions => ['player_id = ?', player_id.to_s])
  end
  
  def self.find_first_by_player(player_id)
    self.find(:first, :conditions => ['player_id = ?', player_id.to_s])
  end
  
  def self.player_score_for_game(player_id, game_id)
    a = self.find(:all, :conditions => ['player_id = ? and game_id = ?', player_id.to_s, game_id.to_s])
    c = 0
    a.each do |b|
      c += b.score 
    end
    return c  
  end
  
  def self.ranking_for_game(game_id)
    self.find_by_sql("SELECT player_id, sum(score) as 'score' from score_items where game_id = " + game_id.to_s + " GROUP BY player_id ORDER BY sum(score) DESC")
  end
  
  def self.analysis_player_game(player_id, game_id)
    self.find_by_sql("SELECT player_id, count(score) as 'count', score as 'score', sum(score) as 'sum' from score_items where player_id = #{player_id} and game_id = #{game_id} group by score order by score DESC;")
  end
  
  def self.analysis_player_rounds(player_id, game_id)
    self.find_by_sql("SELECT player_id, round_id, score from score_items where player_id = #{player_id} and game_id = #{game_id} order by id ASC;")
  end
  
  def self.round_max_min(round_id)
    self.find_by_sql("SELECT max(score) as 'max', min(score) as 'min' from score_items where round_id = #{round_id.to_s}")
  end
  
  def self.player_score_for_round(player_id, round_id)
    a = self.find(:first, :conditions => ['player_id = ? and round_id = ?', player_id.to_s, round_id.to_s])
    return a.score 
  end
end