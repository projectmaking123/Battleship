require_relative 'multiplayer'

def ai_vs_ai
  ai_one = []
  ai_placement(board_print, []).each {|i| ai_one << i}
  ai_two = []
  ai_placement(board_print, []).each {|i| ai_two << i}

  ai_one.each {|i| p i}
  puts "======================================================="
  ai_two.each {|i| p i}

  start_ai_game(board_print, board_print, ai_one, ai_two, [], [], "Zordon", "R2D2")
end

def multiplayer(name, collection)
  puts "========================================================================"
  puts "#{name} please place your ships"
  collection << placement(0, [], ["carrier", "battleship", "cruiser", "destroyer",
                                  "destroyer", "submarine", "submarine"])
end

def start_ai_game(player_one_board, player_two_board, player_one_array, player_two_array, player_one_coors, player_two_coors, first_player, second_player)
  system 'clear'
  puts "NEW TURN"

  player_one_count = player_one_board.flatten.count("XXX")
  player_two_count = player_two_board.flatten.count("XXX")
  if (player_one_count == 18) || (player_two_count == 18)
    puts "#{first_player} got #{player_one_count} hits"
    puts "#{second_player} got #{player_two_count} hits"
    if player_one_count > player_two_count
      return puts "Congrats to #{first_player.upcase}"
    else
      return puts "Congrats to #{second_player.upcase}"
    end
  end

  puts "=====================#{first_player}'s Turn"
  puts "#{first_player} is picking a coor to attack"
  coor = ai_guessing(player_one_coors, player_one_board)
    player_one_board.each_with_index do |row, y|
      row.each_with_index do |ele, x|
        if ele == coor
          player_one_coors << [y, x]
        end
      end
    end
    puts "#{first_player} attacked #{coor}"

  player_one_board = a_turn(player_one_array, coor, player_one_board)
  puts "Below is #{second_player}'s' board after #{first_player} has attacked================================="
  player_one_board.each {|i| p i}

  puts "=====================#{second_player}'s Turn"
  puts "#{second_player} is picking a coor to attack"

  coor = ai_guessing(player_two_coors, player_two_board)
    player_two_board.each_with_index do |row, y|
      row.each_with_index do |ele, x|
        if ele == coor
          player_two_coors << [y, x]
        end
      end
    end
    puts "#{second_player} attacked #{coor}"

  player_two_board = a_turn(player_two_array, coor, player_two_board)
  puts "Below is #{first_player}'s' board after #{second_player} has attacked================================="
  player_two_board.each {|i| p i}

  condition_of_ship(player_one_array, player_two_board)
  hit_counter(player_one_array, first_player)

  condition_of_ship(player_two_array, player_one_board)
  hit_counter(player_two_array, second_player)

  puts "press enter to move on"
  input = gets.chomp
  start_ai_game(player_one_board, player_two_board, player_one_array, player_two_array, player_one_coors, player_two_coors, first_player, second_player)
end
