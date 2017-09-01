def board_print
  board = []
  board << "00 A00 B00 C00 D00 E00 F00 G00 H00 I00 J00".split(" ")

  i = 1
  while i < 10
      board << "0#{i} A0#{i} B0#{i} C0#{i} D0#{i} E0#{i} F0#{i} G0#{i} H0#{i} I0#{i} J0#{i}".split(" ")
    i += 1
  end
  board << "10 A10 B10 C10 D10 E10 F10 G10 H10 I10 J10".split(" ")
  board
end

def condition_of_ship(array, board)
  board.each_with_index do |row, y|
    row.each_with_index do |ele, x|
      if ele == "XXX"
        array.each_with_index do |coors, i|
          coors.each_with_index do |coor, z|
            if board_print[y][x] == coor
              array[i][z] = "XXX"
            end
          end
        end
      end
    end
  end
end

def start_game(ai_board, human_board, ai_array, human_array, ai_coors)
  system 'clear'
  puts "NEW TURN"
  ai_count = ai_board.flatten.count("XXX")
  human_count = human_board.flatten.count("XXX")
  if (ai_count == 18) || (human_count == 18)
    puts "The AI got #{ai_board.flatten.count("XXX")} hits"
    puts "The human got #{human_board.flatten.count("XXX")} hits"
    if ai_count > human_count
      return puts "SKYNET HAS RISEN"
    else
      return puts "I'll BE BACK FOR YOU HUMANS"
    end
  end

  if ai_array.size < 1
    ai_placement(board_print, []).each {|i| ai_array << i}
  end
  if human_array.size < 1
    gathering = placement(0, [], ["carrier", "battleship", "cruiser", "destroyer",
                         "destroyer", "submarine", "submarine"])
    human_array = convert(gathering, board_print)
  end

  puts "=====================AI Turn"
  coor = ai_guessing(ai_coors, ai_board)
    ai_board.each_with_index do |row, y|
      row.each_with_index do |ele, x|
        if ele == coor
          ai_coors << [y, x]
        end
      end
    end
  puts "Ai attacked #{coor}"

  ai_board = a_turn(human_array, coor, ai_board)
  puts "Below is the human board after the AI has attacked================================="
  ai_board.each {|i| p i}
  puts "=====================Human Turn"
  puts "Below are the coordinates you have chosen"
  puts "#{human_array}"
  puts "Pick a coor to attack"
  coor = gets.chomp
  human_board = a_turn(ai_array, coor, human_board)
  puts "Below is the AI board after the human has attacked================================="
  human_board.each {|i| p i}

  condition_of_ship(ai_array, human_board)
  hit_counter(ai_array, "AI")
  condition_of_ship(human_array, ai_board)
  hit_counter(human_array, "human")

  puts "Please enter to move on"
  input = gets.chomp

  start_game(ai_board, human_board, ai_array, human_array, ai_coors)
end

def ai_guessing(ai_coors, ai_board)
  margins = []

  i = 0
  while i < ai_board.length
    margins << ai_board[i][0]
    margins << ai_board[0][i]
    i += 1
  end

    ai_board.each_with_index do |row,  y|
      row.each_with_index do |ele, x|
        if ele == "XXX" && x + 1 <= 10 && y + 1 <= 10 && x - 1 >= 0 && y - 1 >= 0
          prox_coors = [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]]
          pick = prox_coors.sample
          coor = ai_board[pick[0]][pick[1]]

          if ai_coors.include?(pick) == false && coor != "///" && coor != "XXX" &&
            margins.include?(coor) == false && coor != nil
            return coor
          else
            y = (1..9).to_a.sample
            x = (1..9).to_a.sample
            coor = board_print[y][x]
            if ai_coors.include?([y, x]) == false && coor != nil
              return coor
            end
          end
        end
      end
    end
    y = (1..9).to_a.sample
    x = (1..9).to_a.sample
    coor = board_print[y][x]
    if ai_coors.include?([y, x]) == false && coor != nil
      return coor
    else
      ai_guessing(ai_coors, ai_board)
    end
  end

def a_turn(human_array, coor, board)
  board.map.with_index do |row, i|
    if row.include?(coor)
      index = row.index(coor)
      if human_array.flatten.include?(coor)
        board[i][index] = "XXX"
      else
        index = row.index(coor)
        board[i][index] = "///"
      end
    end
  end
  board
end

def ai_placement(board, ai_collection)
  new_board = board
  new_board.delete_at(0)
  new_board.map{|row| row.delete_at(0)}

  boards = [new_board, new_board.transpose]

  first = (1..5).to_a.sample
  ai_collection << boards.sample[(1..9).to_a.sample][first..first + 4]

  second = (1..6).to_a.sample
  ai_collection << boards.sample[(1..9).to_a.sample][second..second + 3]

  third = (1..7).to_a.sample
  ai_collection << boards.sample[(1..9).to_a.sample][third..third + 2]

  fourth = (1..8).to_a.sample
  ai_collection << boards.sample[(1..9).to_a.sample][fourth..fourth + 1]
  ai_collection << boards.sample[(1..9).to_a.sample][fourth..fourth + 1]

  ai_collection << [boards.sample[(1..9).to_a.sample][(1..9).to_a.sample]]
  ai_collection << [boards.sample[(1..9).to_a.sample][(1..9).to_a.sample]]

  if ai_collection.flatten == ai_collection.flatten.uniq
    return ai_collection
  end

  ai_placement(board_print, [])
end

def convert(cache, board)
  cache.map do |ships|
    ships.map do |coor|
      board[coor[0]][coor[1]]
    end
  end
end

def placement(count, collection_of_ships, ships)

  if count == 7
    return collection_of_ships
  end

  puts "Which ship would you like to place? carrier, battleship, cruiser, destroyer, submarine"
  ship = gets.chomp.downcase
  if ship == "carrier" && ships.include?("carrier")
    ship_index = ships.index("carrier")
    ships.delete_at(ship_index)
    collection_of_ships << coor_collect([], 5)
    if collection_validate(collection_of_ships)
      puts "Please place next ship"
      return placement(count+=1, collection_of_ships, ships)
    else
      puts "There are a conflict of coordinates, re-enter new carrier coordinates"
      ships << "carrier"
      return placement(count, collection_of_ships, ships)
    end
  end

  if ship == "battleship" && ships.include?("battleship")
    ship_index = ships.index("battleship")
    ships.delete_at(ship_index)
    collection_of_ships << coor_collect([], 4)
    if collection_validate(collection_of_ships)
      puts "Please place next ship"
      return placement(count+=1, collection_of_ships, ships)
    else
      puts "There are a conflict of coordinates, re-enter new battleship coordinates"
      ships << "battleship"
      return placement(count, collection_of_ships, ships)
    end
  end

  if ship == "cruiser" && ships.include?("cruiser")
    ship_index = ships.index("cruiser")
    ships.delete_at(ship_index)
    collection_of_ships << coor_collect([], 3)
    if collection_validate(collection_of_ships)
      puts "Please place next ship"
      return placement(count+=1, collection_of_ships, ships)
    else
      puts "There are a conflict of coordinates, re-enter new cruiser coordinates"
      ships << "cruiser"
      return placement(count, collection_of_ships, ships)
    end
  end

  if ship == "destroyer" && ships.include?("destroyer")
    ship_index = ships.index("destroyer")
    ships.delete_at(ship_index)
    collection_of_ships << coor_collect([], 2)
    if collection_validate(collection_of_ships)
      puts "Please place next ship"
      return placement(count+=1, collection_of_ships, ships)
    else
      puts "There are a conflict of coordinates, re-enter new destroyer coordinates"
      ships << "destroyer"
      return placement(count, collection_of_ships, ships)
    end
  end

  if ship == "submarine" && ships.include?("submarine")
    ship_index = ships.index("submarine")
    ships.delete_at(ship_index)
    collection_of_ships << coor_collect([], 1)
    if collection_validate(collection_of_ships)
      puts "Please place next ship"
      return placement(count+=1, collection_of_ships, ships)
    else
      puts "There are a conflict of coordinates, re-enter new submarine coordinates"
      ships << "submarine"
      return placement(count, collection_of_ships, ships)
    end
  end

  if ship == "stop"
    return puts "Thanks for playing"
  elsif ships.include?(ship) == false
    puts "Please enter a vaild ship"
    puts "========================="
    placement(count, collection_of_ships, ships)
  end
end

def ship_validate(coordinates)
  y = []
  x = []

  coordinates.each_with_index do |coor, i|
    y << coor[0]
    x << coor[1]
  end

  if ('123456789'.match(y.join("")) || '987654321'.match(y.join(""))) && /#{x[0]}{1,5}/.match(x.join(""))
    return true
  elsif ('123456789'.match(x.join("")) || '987654321'.match(x.join(""))) && /#{y[0]}{1,5}/.match(y.join(""))
    return true
  else
    false
  end
end

def collection_validate(coordinates)
  all_coors = []
  coordinates.each do |ship_array|
    ship_array.each do |coors|
      all_coors << coors
    end
  end

  if all_coors == all_coors.uniq
    true
  else
    false
  end
end

def coor_collect(coordinates, length)
  if coordinates.length == length && ship_validate(coordinates)
    return coordinates
  end

  puts "Where would you like to place your ship? please enter a coor"
  coor = gets.chomp

  board_print.each_with_index do |row, y|
    row.each_with_index do |ele, x|
      if coor == ele
        coordinates << [y, x]
      end
    end
  end

  if coordinates.length > 1 && ship_validate(coordinates) == false
    puts "you entered a invalid coordinate, please re-enter all coordinates"
    coordinates.clear
    return coor_collect(coordinates, length)
  end

  if board_print.any? {|row| row.any? {|ele| (coor == ele)}} == false
    puts "you entered a invalid coordinate, please re-enter all coordinates"
    coordinates.clear
    return coor_collect(coordinates, length)
  elsif coordinates != coordinates.uniq
    puts "you entered a invalid coordinate, please re-enter all coordinates"
    coordinates.clear
    return coor_collect(coordinates, length)
  else
     coor_collect(coordinates, length)
  end
end

def hit_counter(array, name)
  array.each do |coors|
    if coors.count("XXX") == 5 && coors.length == 5
      puts "#{name}'s Carrier has been sunk"
    elsif coors.count("XXX") == 4 && coors.length == 4
      puts "#{name}'s Battleship has been sunk"
    elsif coors.count("XXX") == 3 && coors.length == 3
      puts "#{name}'s Cruiser has been sunk"
    elsif coors.count("XXX") == 2 && coors.length == 2
      puts "#{name}'s Destroyer has been sunk"
    elsif coors.count("XXX") == 1 && coors.length == 1
      puts "#{name}'s Submarine has been sunk"
    end
  end
end
