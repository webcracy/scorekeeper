
def create_game
  game = Game.new
  puts '_______'
	puts " Create a new game "
	puts '_______'
	puts "Game name"
	game.title = gets.chomp
	game.save
	puts ''
	puts "-- OK. Game open. Add players to the game. --"
	puts ''
	add_players_to_game(game.id)
end
	
def add_players_to_game(game_id)
  game = Game.find_by_id(game_id)
	puts "Insert player name"
	player_name = gets.chomp
  #create new player
	  player = Player.new
	  player.name = player_name
	  player.save
	  game.players << player
	  puts ''
    puts '  OK, ' + player_name + ' was added to the game.'
    puts ''

  #if game.players.include?(player.id) == false
  #  g = game
  #   g.players << Player.find_by_name(player_name).to_a
  #   puts 'OK, ' + player_name + ' was added to the game.'
  # else
  #   puts 'Hehe, ' + player_name + ' was already in the game.'
  #end
  
  game.save
	puts 'Add another one? y or n'
	a = gets.chomp
	if a == 'y'
	  add_players_to_game(game_id)
  elsif a != 'y'
    in_game_menu(game_id)
  end
end

def game_analysis(game_id)
  game = Game.find(game_id)
  players = game.players
  puts "Score analysis for the game:' " + game.title
  players.each do |p|
    puts '        Player name: ' + p.name
    puts ''
    sco = ScoreItem.analysis_player_game(p.id, game_id)
    sco.each do |sco|
      puts 'Score        Number of rounds     Total points with this score'
      puts '  ' + sco['score'].to_s + '                  ' + sco['count'].to_s + '                      ' + sco['sum'].to_s
    end
    puts ''
    puts '  Total points in this game: ' + ScoreItem.player_score_for_game(p.id, game_id).to_s
    puts ''
    puts 'Press "enter" to continue'
    huhu = gets.chomp
  end
  puts '  Analysis finished. Press "enter" to return to the game menu'
  hey = gets.chomp
  in_game_menu(game_id)
end

def round_analysis(game_id)
  game = Game.find(game_id)
  players = game.players
  puts ''
  puts "____"
  puts "Round-by-round analysis per player"
  puts "----"
  puts ''
  puts '!! Please, tell me who wins: the "top" score, or the "low" score?'
  puts ''
  puts '-> Type "top" or "low", then hit "enter"'
  top_low = gets.chomp
  #if 
  players.each do |p|
    puts ''
    puts '----------------------------------------'
    puts '    Visual analysis for player: '
    puts '          ~   ' + p.name + '  '
    puts '----------------------------------------'
    rounds = ScoreItem.analysis_player_rounds(p.id, game_id)
    puts "________________________________"
    puts "  Rank  |   Score   |   Round id"
    puts "________________________________"
    rounds.each do |r|
      max_min = ScoreItem.round_max_min(r.round_id.to_s)
      max = max_min[0]['max'].to_i
      min = max_min[0]['min'].to_i
      if top_low.to_s == 'top'
        top = max
        low = min
      elsif top_low.to_s == 'low'
        top = min
        low = max
      end
      if r.score.to_i == top.to_i
        puts '  W     |      ' + r.score.to_s + '    |    ' + r.round_id.to_s
      elsif r.score.to_i == low.to_i
        puts '  L     |      ' + r.score.to_s + '    |    ' + r.round_id.to_s
      else
        puts '  -     |      ' + r.score.to_s + '    |    ' + r.round_id.to_s
      end
    end
    puts ''
    puts '  Total points in this game (player ' + p.name + '): ' + ScoreItem.player_score_for_game(p.id, game_id).to_s
    puts ''
    puts "  Press 'enter' to continue" 
    lalou = gets.chomp
  end
  puts ''
  puts " All players have been analysed. Press 'enter' to return to the menu"
  haha = gets.chomp
  in_game_menu(game_id)
end
    
    
def in_game_menu(game_id)
  game = Game.find(game_id)
  puts '-----'
  puts ' Game menu'
  puts '-----'
  puts ''
  puts "-- You're playing: " + game.title + ", started at " + game.created_at.to_s
  puts ''
  puts '1. Start a new round'
  puts '2. Score table'
  puts '3. Round-by-round analysis, per player'
  puts '4. Score analysis, per player'
  puts '5. Quit this game'
  a = gets.chomp
  if a == '1'
    new_round(game_id)
  elsif a == '2'
    show_scores(game_id)
  elsif a == '3'
    round_analysis(game_id)
  elsif a == '4'
    game_analysis(game_id)
  elsif a == '5'
    start
  else
    in_game_menu(game_id)
  end
end

def load_game(game_id)
  in_game_menu(game_id)
end

def show_scores(game_id)
  game = Game.find(game_id)

  puts '______'
  puts 'Scores for game ' + game.title.to_s
  puts '------'
  ranking = ScoreItem.ranking_for_game(game_id)
   ranking.each do |p|
     player = Player.find(p.player_id)
     puts player.name.to_s + ': ' + p.score.to_s
   end
  puts ''
  puts 'Press "enter" to return to the game menu.'
  he = gets.chomp 
  in_game_menu(game_id) 
end

def start
  puts '----'
  puts 'Scorekeeper v0.3'
  puts '----'
  puts ' Welcome to Scorekeeper. What do you want to do?'
  puts ''
  games = Game.find(:all, :limit => 5, :order => "created_at DESC")
  puts '  0. Start a new game'
  if !games.empty?
    puts '  1. Load ' + games[0].title if games[0]
    puts '  2. Load ' + games[1].title if games[1]
    puts '  3. Load ' + games[2].title if games[2]
    puts '  4. Load ' + games[3].title if games[3]
    puts '  5. Load ' + games[4].title if games[4]
  end
  puts ''
  puts 'Press "q" to quit Scorekeeper'
  answer = gets.chomp
  if answer == '0'
    create_game
  elsif answer == '1'
    load_game(games[0].id)
  elsif answer == '2'
    load_game(games[1].id)
  elsif answer == '3'
    load_game(games[2].id)
  elsif answer == '4'
    load_game(games[3].id)
  elsif answer == '5'
    load_game(games[4].id)
  else
    puts "Bye bye. Thank you for Scorekeeping."
    exit
  end
end

def new_round(game_id)
  game = Game.find(game_id)
  round = Round.new
  round.game_id = game.id
  round.save
#  round.players << game.players
  puts '-----'
  puts '!!! New round !!!'
  puts '-----'
  game.players.each do |p|
    score = ScoreItem.new
    puts 'Enter ' + p.name + "'s score:"
    score.score = gets.chomp
    score.player_id = p.id
    score.game_id = game.id
    score.round_id = round.id
    score.save
  end
  puts '_______'  
  puts 'Scores for this round:'
  puts '-------'
  game.players.each do |p|
    round_score = ScoreItem.player_score_for_round(p.id, round.id)
    #score = (:first, :conditions => ['user_login = ?', login.to_s])
    puts p.name + ': ' + round_score.to_s
  end
  puts '_______'
  puts 'Scores so far in ' + game.title.to_s + " (game started #{didwhen(game.created_at.to_time)})"
  puts '-------'
  ranking = ScoreItem.ranking_for_game(game.id)
  ranking.each do |p|
    player = Player.find(p.player_id)
    puts player.name.to_s + ': ' + p.score.to_s
  end
#  game.players.each do |p|
#    score = ScoreItem.player_score_for_game(p.id, game.id)
#    puts p.name + ': ' + score.to_s
#  end
  puts ''
  puts '  Scores for this round were saved.'
  puts ''
  puts 'Press "enter" to start next round or "p" to pause the game.'
  lala = gets.chomp
  if lala == ''
    new_round(game_id)
  else
  in_game_menu(game_id)
  end
end

# helper method
def didwhen(old_time) # stolen from http://snippets.dzone.com/posts/show/5715
 val = Time.now - old_time
  if val < 10 then
    result = 'just a moment ago'
  elsif val < 40  then
    result = 'less than ' + (val * 1.5).to_i.to_s.slice(0,1) + '0 seconds ago'
  elsif val < 60 then
    result = 'less than a minute ago'
  elsif val < 60 * 1.3  then
    result = "1 minute ago"
  elsif val < 60 * 50  then
    result = "#{(val / 60).to_i} minutes ago"
  elsif val < 60  * 60  * 1.4 then
    result = 'about 1 hour ago'
  elsif val < 60  * 60 * (24 / 1.02) then
    result = "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
  else
    result = old_time.strftime("%H:%M %p %B %d, %Y")
  end
 return "#{result}"
end # self.didwhen