// fuego branch contracts
// The 'roulette' program.

//? constant declaration import ile yapilabilir?????

program cassino_game_test_6.aleo {

  // Mappings
  mapping account: address => u64;
  mapping random_number_map: address=>u32;
  mapping winner: address=>bool;


  record WAC {
    owner: address, 
    amount: u64,
  }

  record winner_private {
    owner: address,
    win: bool,
    reward: u64
  }

  /* Mint */
  transition deposit_public(public receiver: address, public amount: u64) {
    return then finalize(receiver, amount);
  }

  finalize deposit_public(public receiver: address, public amount: u64) {
    let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
    Mapping::set(account, receiver, receiver_amount + amount);
  }

  transition deposit_private(receiver: address, amount: u64) -> WAC {
    return WAC {
      owner: receiver,
      amount: amount,
    };
  }

  /* Transfer */
  transition withdraw_public(public receiver: address, public amount: u64) {
    return then finalize(self.caller, receiver, amount);
  }

  finalize withdraw_public(public sender: address, public receiver: address, public amount: u64) {
    let sender_amount: u64 = Mapping::get_or_use(account, sender, 0u64);
    Mapping::set(account, sender, sender_amount - amount);

    let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
    Mapping::set(account, receiver, receiver_amount + amount);
  }

  transition withdraw_private(sender: WAC, receiver: address, amount: u64) -> (WAC, WAC) {
    let difference: u64 = sender.amount - amount;

    let remaining: WAC = WAC {
      owner: sender.owner,
      amount: difference,
    };

    let transferred: WAC = WAC {
      owner: receiver,
      amount: amount,
    };

    return (remaining, transferred);
  }

  // Bets

  /* Odd-Even Bet */
  transition make_odd_even_bet_private(casino: WAC, player: WAC, winning: bool, bet_amount: u64,)->(WAC, WAC) {
    let player_balance: u64 = player.amount;
    let casino_balance: u64 = casino.amount;


      if (winning) {
            player_balance += bet_amount;
            casino_balance -= bet_amount;
      }
      else {
            player_balance -= bet_amount;
            casino_balance += bet_amount;
      }

    let updated_player_WAC: WAC = WAC {
      owner: player.owner,
      amount: player_balance
    };

    let updated_casino_WAC: WAC = WAC {
      owner: casino.owner,
      amount: casino_balance
    };
    return (updated_player_WAC, updated_casino_WAC);
  }


  transition make_odd_even_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32
    ){
        assert(bet_amount > 0u64);
        assert(bet == 0u32 || bet == 1u32);

        return then finalize(casino_owner, bet_amount, bet, self.caller);
        
  }

  finalize make_odd_even_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32,
        public player: address
    ) {
        //let spin: u32 = ChaCha::rand_u32();
        let spin: u32 = ChaCha::rand_u32() % 37u32; // 0 to 36
        let random: u32 = Mapping::get_or_use(random_number_map, player, 0u32);
        Mapping::set(random_number_map, player, spin);
        let win: bool = (random % 2u32) == bet;
        Mapping::set(winner, player, win);
        let reward: u64 = bet_amount * 2u64;
        let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
        let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

        assert(current_player_amount > bet_amount);
    
        if (win) {
            current_player_amount = current_player_amount + reward;
            casino_balance = casino_balance - reward;
            Mapping::set(account, player, current_player_amount);
            Mapping::set(account, casino_owner, casino_balance);

        } else {
            current_player_amount = current_player_amount - reward;
            casino_balance = casino_balance + reward;
            Mapping::set(account, player, current_player_amount);
            Mapping::set(account, casino_owner, casino_balance);

        }
    }





  /* Red-Black Bet */

  // Function to check if a number is red
  function is_number_red(number: u32) -> bool {
      return number == 1u32 || number == 3u32 || number == 5u32 || number == 7u32 || number == 9u32
          || number == 12u32 || number == 14u32 || number == 16u32 || number == 18u32
          || number == 19u32 || number == 21u32 || number == 23u32 || number == 25u32
          || number == 27u32 || number == 30u32 || number == 32u32 || number == 34u32 || number == 36u32;
  }

// Transition for red-black bet
transition make_red_black_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_red: bool
){
    assert(bet_amount > 0u64);
    // Perform any necessary preliminary checks here

    return then finalize(casino_owner, bet_amount, bet_on_red, self.caller);
}


// Finalize the red-black bet
finalize make_red_black_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_red: bool,
    public player: address
){
    let spin: u32 = ChaCha::rand_u32() % 37u32; // 0 to 36

    // Inline check for red number
    let is_red: bool = spin == 1u32 || spin == 3u32 || spin == 5u32 || spin == 7u32 || spin == 9u32
        || spin == 12u32 || spin == 14u32 || spin == 16u32 || spin == 18u32
        || spin == 19u32 || spin == 21u32 || spin == 23u32 || spin == 25u32
        || spin == 27u32 || spin == 30u32 || spin == 32u32 || spin == 34u32 || spin == 36u32;

    let win: bool = (bet_on_red && is_red) || (!bet_on_red && !is_red && spin != 0u32);
    Mapping::set(winner, player, win);

    let reward: u64 = bet_amount * 2u64;
    let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
    let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

    assert(current_player_amount >= bet_amount);

    if (win) {
        current_player_amount += reward;
        casino_balance -= bet_amount;
    } else {
        current_player_amount -= bet_amount;
        casino_balance += bet_amount;
    }

    Mapping::set(account, player, current_player_amount);
    Mapping::set(account, casino_owner, casino_balance);
}

}

/*
  transition make_red_black_bet_private(casino: WAC, player: WAC, winning: bool, bet_amount: u64,)->(WAC, WAC) {
    let player_balance: u64 = player.amount;
    let casino_balance: u64 = casino.amount;
 

      if (winning) {
            player_balance += bet_amount;
            casino_balance -= bet_amount;
      }
      else {
            player_balance -= bet_amount;
            casino_balance += bet_amount;
      }

    let updated_player_WAC: WAC = WAC {
      owner: player.owner,
      amount: player_balance
    };

    let updated_casino_WAC: WAC = WAC {
      owner: casino.owner,
      amount: casino_balance
    };
    return (updated_player_WAC, updated_casino_WAC);
  }


  transition make_red_black_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32
    ){
        assert(bet_amount > 0u64);
        //assert(bet == 0u32 || bet == 1u32);
        

        return then finalize(casino_owner, bet_amount, bet, self.caller);
        
  }

  finalize make_red_black_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32,
        public player: address
      
    ) {
        let spin: u32 = ChaCha::rand_u32();
        let random: u32 = Mapping::get_or_use(random_number_map, player, 0u32);
        Mapping::set(random_number_map, player, spin);
        let win: bool = (random % 2u32) == bet;
        Mapping::set(winner, player, win);
        let reward: u64 = bet_amount * 2u64;
        let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
        let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

        assert(current_player_amount > bet_amount);
    
        if (win) {
            current_player_amount = current_player_amount + reward;
            casino_balance = casino_balance - reward;
            Mapping::set(account, player, current_player_amount);
            Mapping::set(account, casino_owner, casino_balance);

        } else {
            current_player_amount = current_player_amount - reward;
            casino_balance = casino_balance + reward;
            Mapping::set(account, player, current_player_amount);
            Mapping::set(account, casino_owner, casino_balance);

        }
    }
}

*/