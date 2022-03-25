class Player 

    attr_reader :name 

    def initialize(name)
        @name = name 
    end 

    def get_entry
        valid_entry = false 
        while !valid_entry
            print "#{name}, make an entry: "
            user_entry = gets.chomp 
            if valid_user_entry?(user_entry) 
                valid_entry = true 
            else 
                puts "\nInvalid entry. Please make a valid entry."
                puts "Example to reveal tile 0,0: r0,0"
                puts "Example to flag tile 0,0: f0,0"
            end 
        end 
        user_entry
    end 

    def valid_user_entry?(user_entry)
        user_entry.downcase! 
        return false if user_entry[0] != 'r' && user_entry[0] != 'f'
        user_entry = user_entry[1..-1]
        return false if !user_entry.include?(',')
        arr = user_entry.split(',')
        return false if arr.any? { |char| char.length != 1 } 
        if arr.all? { |char| char.ord >= 48 && char.ord <= 56 }
            true 
        else 
            false 
        end 
    end 

end 