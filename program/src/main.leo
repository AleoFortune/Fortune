// fuego branch contracts
// The 'roulette' program.
program cassino_game_test_15.aleo {

  // Mappings
  mapping account: address => u64;
  mapping random_number_map: address=>u32;
  mapping winner: address=>bool;


  record WAC {
    owner: address, 
    amount: u64,
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


  // random number transition 
  
  /*
  transition random_number_generate(public player: address){
    return then finalize(self.caller);
  }
  finalize random_number_generate(public player: address) {
    let random_number: u32 = ChaCha::rand_u32();
    let random_number_mod37: u32 = random_number % 37u32; // 0 to 36
    Mapping::set(random_number_map, player, random_number_mod37);
  }
 */


  transition make_odd_even_bet_private(casino: WAC, player: WAC, bet_amount: u64, public bet: u32, public random_number: u32)->(WAC, WAC) {
          let win: bool = (random_number % 2u32) == bet;
          let player_balance: u64 = player.amount;
          let casino_balance: u64 = casino.amount;


          if (win) {
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
        public bet: u32,
        public random_number: u32,
    ){
        assert(bet_amount > 0u64);
        assert(bet == 0u32 || bet == 1u32);

        return then finalize(casino_owner, bet_amount, bet, random_number, self.caller);
        
    }

    finalize make_odd_even_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32,
        public random_number: u32, //from frontend
        public player: address
    ) {
        let win: bool = (random_number % 2u32) == bet;
        Mapping::set(winner, player, win); // winner map is for testing purpose, I will remove it when I finish the contract and tests.
        let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
        let current_casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

        assert(current_player_amount > bet_amount);
    
        if (win) {
            current_player_amount += bet_amount;
            current_casino_balance -= bet_amount;
        } else {
            current_player_amount -= bet_amount;
            current_casino_balance += bet_amount;
        }            
        Mapping::set(account, player, current_player_amount);
        Mapping::set(account, casino_owner, current_casino_balance);


    }

    transition make_straightup_bet_public(
      public casino_owner: address,
      public bet_amount: u64,
      public bet: u32,
      public random_number: u32,){

        return then finalize(casino_owner, bet_amount, bet, random_number, self.caller);
      }

    finalize make_straightup_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32,
        public random_number: u32,
        public player: address
    ) {
        let win: bool = random_number == bet;
        Mapping::set(winner, player, win); // winner map is for testing purpose, I will remove it when I finish the contract and tests.
        let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
        let current_casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

        // assert(current_player_amount > bet_amount);
    
        if (win) {
          current_player_amount += 35u64*bet_amount;
          current_casino_balance -= 35u64*bet_amount;
        } else {
          current_player_amount -= bet_amount;
          current_casino_balance += bet_amount;
        }            
        Mapping::set(account, player, current_player_amount);
        Mapping::set(account, casino_owner, current_casino_balance);

    }


    /* Red-Black Bets */

  transition make_red_black_bet_private(
      casino: WAC,
      player: WAC,
      bet_amount: u64,
      private bet_on_red: bool,
      private random_number: u32
  ) -> (WAC, WAC) {
      // Game logic

      // Check if the number is red 
    let is_red: bool = (random_number == 1u32) || (random_number == 3u32) || (random_number == 5u32) || (random_number == 7u32) || (random_number == 9u32)
        || (random_number == 12u32) || (random_number == 14u32) ||   (random_number == 16u32) || (random_number == 18u32)
        || (random_number == 19u32) || (random_number == 21u32) || (random_number == 23u32) || (random_number == 25u32)
        || (random_number == 27u32) || (random_number == 30u32) || (random_number == 32u32) || (random_number == 34u32) || (random_number == 36u32);

    // Determine if the player wins
    let win: bool = (bet_on_red && is_red) || (!bet_on_red && !is_red && random_number != 0u32);
    let player_balance: u64 = player.amount;
    let casino_balance: u64 = casino.amount;
    // Calculate new balances
    if (win) {
        player_balance += bet_amount;
        casino_balance -= bet_amount;
    } else {
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
    // Return the updated WAC records for the player and casino
    return (updated_player_WAC, updated_casino_WAC);
  }


  transition make_red_black_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_red: bool,
    public random_number: u32,

){
    assert(bet_amount > 0u64);


    return then finalize(casino_owner, bet_amount, bet_on_red, random_number, self.caller);
}


// Finalize the red-black bet
finalize make_red_black_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_red: bool,
    public random_number: u32,
    public player: address
){
    // Inline check for red number
    let is_red: bool = (random_number == 1u32) || (random_number == 3u32) || (random_number == 5u32) || (random_number == 7u32) || (random_number == 9u32)
        || (random_number == 12u32) || (random_number == 14u32) ||   (random_number == 16u32) || (random_number == 18u32)
        || (random_number == 19u32) || (random_number == 21u32) || (random_number == 23u32) || (random_number == 25u32)
        || (random_number == 27u32) || (random_number == 30u32) || (random_number == 32u32) || (random_number == 34u32) || (random_number == 36u32);

    let win: bool = (bet_on_red && is_red) || (!bet_on_red && !is_red && random_number != 0u32);
    Mapping::set(winner, player, win);

    //let reward: u64 = bet_amount * 2u64;
    let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
    let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

    assert(current_player_amount >= bet_amount);

    if (win) {
        current_player_amount += bet_amount;
        casino_balance -= bet_amount;
    } else {
        current_player_amount -= bet_amount;
        casino_balance += bet_amount;
    }

    Mapping::set(account, player, current_player_amount);
    Mapping::set(account, casino_owner, casino_balance);
}


  /* Dozen Bet */
  
// Transition for dozen bet (1st 12 - 2nd 12 - 3rd 12)
transition make_dozen_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_dozen: u32,
    public random_number: u32,

){
    assert(bet_amount > 0u64);
    assert(bet_dozen >= 1u32 && bet_dozen <= 3u32);

    return then finalize(casino_owner, bet_amount, bet_dozen, random_number, self.caller);
}


  // Finalize the dozen bet
  finalize make_dozen_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_dozen: u32,
    public random_number: u32,
    public player: address
  ){

    let win: bool = false;
    if (bet_dozen == 1u32) {
        win = (random_number >= 1u32 && random_number <= 12u32);
    } else if (bet_dozen == 2u32) {
        win = (random_number >= 13u32 && random_number <= 24u32);
    } else if (bet_dozen == 3u32) {
        win = (random_number >= 25u32 && random_number <= 36u32);
    }

    Mapping::set(winner, player, win);

    let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
    let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

    assert(current_player_amount >= bet_amount);

    if (win) {
        current_player_amount += bet_amount * 2u64; // Double the bet amount as reward
        casino_balance -= bet_amount * 2u64;
    } else {
        current_player_amount -= bet_amount;
        casino_balance += bet_amount;
    }

    Mapping::set(account, player, current_player_amount);
    Mapping::set(account, casino_owner, casino_balance);
  }


  /* Low-High Bet */

  // Transition for low/high bet
  transition make_low_high_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_low: bool,
    public random_number: u32,
  ){
    assert(bet_amount > 0u64);

    return then finalize(casino_owner, bet_amount, bet_on_low, random_number, self.caller);
  }


  // Finalize the low/high bet
  finalize make_low_high_bet_public(
    public casino_owner: address,
    public bet_amount: u64,
    public bet_on_low: bool,
    public random_number: u32,
    public player: address
  ){
    let win: bool = false;
    if (bet_on_low) {
        win = (random_number >= 1u32 && random_number <= 18u32);
    } else {
        win = (random_number >= 19u32 && random_number <= 36u32);
    }

    Mapping::set(winner, player, win);

    let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
    let casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);

    assert(current_player_amount >= bet_amount);

    if (win) {
        current_player_amount += bet_amount; // Equal the bet amount as reward
        casino_balance -= bet_amount;
    } else {
        current_player_amount -= bet_amount;
        casino_balance += bet_amount;
    }

    Mapping::set(account, player, current_player_amount);
    Mapping::set(account, casino_owner, casino_balance);
  }
  
}