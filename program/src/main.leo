// import credits_test.leo;

// The 'roulette' program.
program cassino_game_test_3.aleo {

    // const casino_owner: address = aleo1v7nuwtqnksjp7x59r936rlk5uew7zrlu0hsvflpagkep5k5qugyqw2xwa9;

    mapping balance: address=>u64;

    mapping winner: address=>bool;

    mapping random_number_map: address=>u32;

    // transition make_odd_even_bet_result(
    //     bet_amount: u64,
    //     bet: u32,
    //     player: address
    // ) -> (Token, Token){

    //     let casino_update: Token = Token {
    //     owner: casino_owner,
    //     amount: Casino.amount,
    //     };

    //     let player_output: Token = Token {
    //     owner: player,
    //     amount: player_balance,
    //     };

    //     return (casino_update, player_output);
    // };


    transition make_odd_even_bet(
        casino_owner: address,
        bet_amount: u64,
        bet: u32,
        player: address
    ){
        assert(bet_amount > 0u64);
        assert(bet == 0u32 || bet == 1u32);

        return then finalize(casino_owner, bet_amount, bet, self.caller);
        
    }

    finalize make_odd_even_bet(
        casino_owner: address,
        bet_amount: u64,
        bet: u32,
        player: address
    ) {
        let random_number: u32 = ChaCha::rand_u32();
        Mapping::set(random_number_map, player, random_number);
        let win: bool = (random_number % 2u32) == bet;
        Mapping::set(winner, player, win);
        let reward: u64 = bet_amount * 2u64;
        let current_player_amount: u64 = Mapping::get_or_use(balance, player, 100u64);
        let casino_balance: u64 = Mapping::get_or_use(balance, casino_owner, 100u64);

        assert(current_player_amount > bet_amount);
    
        if (win) {
            current_player_amount = current_player_amount + reward;
            casino_balance = casino_balance - reward;
            Mapping::set(balance, player, current_player_amount);
            Mapping::set(balance, casino_owner, casino_balance);

        } else {
            current_player_amount = current_player_amount - reward;
            casino_balance = casino_balance + reward;
            Mapping::set(balance, player, current_player_amount);
            Mapping::set(balance, casino_owner, casino_balance);

        }
    }
}