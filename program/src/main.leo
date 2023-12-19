// The 'roulette' program.
program cassino_game_test_6.aleo {

    mapping account: address => u64;
    mapping random_number_map: address=>u32;
    mapping winner: address=>bool;

  record WAC {
    owner: address,
    amount: u64,
  }

  transition deposit_public(public receiver: address, public amount: u64) {
    return then finalize(receiver, amount);
  }

  finalize deposit_public(public receiver: address, public amount: u64) {
    let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
    Mapping::set(account, receiver, receiver_amount + amount);
  }

  transition desposit_private(receiver: address, amount: u64) -> WAC {
    return WAC {
      owner: receiver,
      amount: amount,
    };
  }

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

  transition random_number_generate(public player: address){
    return then finalize(self.caller);
  }
  finalize random_number_generate(public player: address) {
    let spin: u32 = ChaCha::rand_u32();
    let random_number: u32 = Mapping::get_or_use(random_number_map, player, 0u32);
    Mapping::set(random_number_map, player, spin);
  }


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
        public random_number: u32
    ){
        assert(bet_amount > 0u64);
        assert(bet == 0u32 || bet == 1u32);

        return then finalize(casino_owner, bet_amount, bet, random_number, self.caller);
        
    }

    finalize make_odd_even_bet_public(
        public casino_owner: address,
        public bet_amount: u64,
        public bet: u32,
        public random_number: u32,
        public player: address
    ) {
        let win: bool = (random_number % 2u32) == bet;
        Mapping::set(winner, player, win); // winner map is for testing purpose, I will remove it when I finish the contract and tests.
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