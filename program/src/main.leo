// The 'roulette' program.
program fortune.aleo {
    
    mapping balance: address=>u64;

    mapping random_number_map: address=>u32;

    record Token {
        owner: address,
        amount: u64
    }

    transition make_odd_even_bet(
        Casino: Token,
        bet_amount: u64,
        bet: u32,
        player: address
    ) -> (Token, Token){
        assert(bet_amount > 0u64);
        assert(bet == 0u32 || bet == 1u32);

        return then finalize(Casino, bet_amount, bet, self.caller);
        
    }
    finalize make_odd_even_bet(
        Casino: Token,
        bet_amount: u64,
        bet: u32,
        player: address
    ) {
        let random_number: u32 = ChaCha::rand_u32();
        Mapping::set(random_number_map, player, random_number);
        let win: bool = (random_number%2) == bet;
        let reward: u64 = bet_amount * 2u64;
        let current_player_amount: u64 = Mapping::get(balance, player);
        let casino_balance: u64 = Casino.amount;

        assert(current_player_amount > bet_amount);

        if (win) {
            current_player_amount = current_player_amount + reward;
            casino_balance = casino_balance - reward;
            Mapping::set(balance, player, current_player_amount);

        } else {
            current_player_amount = current_player_amount - reward;
            casino_balance = casino_balance + reward;
            Mapping::set(balance, player, current_player_amount);

        }
        let update_casino: Token = Token {
            owner: Casino.owner,
            amount: casino_balance
        };
    }
}