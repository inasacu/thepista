require 'pp'

def tournament (teams)
    teams.reverse!

    # Hash of hashes to keep track of matchups already used.
    played = Hash[ * teams.map { |t| [t, {}] }.flatten ]

    # Initially generate the tournament as a list of games.
    games = []
    return [] unless set_game(0, games, played, teams, nil)

    # Convert the list into tournament rounds.
    rounds = []
    rounds.push games.slice!(0, teams.size / 2) while games.size > 0
    rounds
end

def set_game (i, games, played, teams, rem)
    # Convenience vars: N of teams and total N of games.
    nt  = teams.size
    ng  = (nt - 1) * nt / 2

    # If we are working on the first game of a round,
    # reset rem (the teams remaining to be scheduled in
    # the round) to the full list of teams.
    rem = Array.new(teams) if i % (nt / 2) == 0

    # Remove the top-seeded team from rem.
    top = rem.sort_by { |tt| teams.index(tt) }.pop
    rem.delete(top)

    # Find the opponent for the top-seeded team.
    rem.each_with_index do |opp, j|
        # If top and opp haven't already been paired, schedule the matchup.
        next if played[top][opp]
        games[i] = [ top, opp ]
        played[top][opp] = true

        # Create a new list of remaining teams, removing opp
        # and putting rejected opponents at the end of the list.
        rem_new = [ rem[j + 1 .. rem.size - 1], rem[0, j] ].compact.flatten

        # Method has succeeded if we have scheduled the last game
        # or if all subsequent calls succeed.
        return true if i + 1 == ng
        return true if set_game(i + 1, games, played, teams, rem_new)

        # The matchup leads down a bad path. Unschedule the game
        # and proceed to the next opponent.
        played[top][opp] = false
    end

    return false
end

# pp tournament(ARGV)
# items = ('A'..'H').to_a
items = ['Agustin','Gabriel','Antonio','Rene']
pp tournament(items)


