require_relative 'multiplayer'
require_relative 'ai_vs_ai'

def start_program
  puts "pick a game setting from the following"
  puts "single player"
  puts "multiplayer"
  puts "watch AI vs AI"
  response = gets.chomp

  if response == "single player"
    start_game(board_print, board_print, [], [], [])
  elsif response == 'multiplayer'
    puts "Please enter the name of the first player"
    first_player = gets.chomp
    puts "Please enter the name of the second player"
    second_player = gets.chomp
    player_one = multiplayer(first_player, [])[0]
    player_two = multiplayer(second_player, [])[0]
    player_two_board = board_print
    player_one_board = board_print
    start_multiplayer_game(player_one_board, player_two_board, convert(player_one, board_print), convert(player_two, board_print), first_player, second_player)
  elsif response == "watch AI vs AI"
    ai_vs_ai
  else
    puts "Please enter a proper choice"
    start_program
  end
end
