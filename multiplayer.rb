require_relative 'battleship'

def multiplayer(name, collection)
  puts "========================================================================"
  puts "#{name} please place your ships"
  collection << placement(0, [], ["carrier", "battleship", "cruiser", "destroyer",
                                  "destroyer", "submarine", "submarine"])
end

def start_multiplayer_game(player_one_board, player_two_board, player_one_array, player_two_array, first_player, second_player)
  system 'clear'
  puts "NEW TURN"

  player_one_count = player_one_board.flatten.count("XXX")
  player_two_count = player_two_board.flatten.count("XXX")
  if (player_one_count == 2) || (player_two_count == 2)
    puts "#{first_player} got #{player_one_count} hits"
    puts "#{second_player} got #{player_two_count} hits"
    if player_one_count > player_two_count
      return puts "Congrats to #{first_player.upcase}"
    else
      return puts "Congrats to #{second_player.upcase}"
    end
  end

  puts "=====================#{first_player}'s Turn"
  puts "Pick a coor to attack"
  coor = gets.chomp

  player_one_board = a_turn(player_one_array, coor, player_one_board)
  puts "Below is #{second_player}'s' board after #{first_player} has attacked================================="
  player_one_board.each {|i| p i}

  puts "=====================#{second_player}'s Turn"
  puts "Pick a coor to attack"
  coor = gets.chomp
  player_two_board = a_turn(player_two_array, coor, player_two_board)
  puts "Below is #{first_player}'s' board after #{second_player} has attacked================================="
  player_two_board.each {|i| p i}

  condition_of_ship(player_one_array, player_one_board)
  hit_counter(player_one_array, first_player)

  condition_of_ship(player_two_array, player_two_board)
  hit_counter(player_two_array, second_player)

  puts "press enter to move on"
  input = gets.chomp

  start_multiplayer_game(player_one_board, player_two_board, player_one_array, player_two_array, first_player, second_player)
end
