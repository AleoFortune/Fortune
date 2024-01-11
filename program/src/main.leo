program fortune_newlogic.aleo {

    /* test inputs

    choice:
    [1u32, 2u32, 3u32, 4u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32, 0u32]
    
    */


   // Mappings
   mapping account: address => u64;
   mapping random_number_map: address=>u32;
   mapping choice_map: address => [u32; 32];
   const casino_address: address = aleo1l8lyps4rm43lklhnt0yaupvtz758d3dx2wzfr6uqwwg4tk4lev9qvguw09;


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




   // Simplified transition for placing a bet
   transition place_bet_public(
       public bet_amount: u64,
       public choice: [u32; 32], // Array of chosen numbers (e.g., [0, 2, 4, ..., 36] for even)
       public multiplier: u64
   ) {  

       // Calculate the result
       return then finalize(casino_address, self.caller, bet_amount, choice, multiplier);
   }


   // Finalize the bet and handle payouts
   finalize place_bet_public(
       public casino_owner: address,
       public player: address,
       public bet_amount: u64,
       public choice: [u32; 32],
       public multiplier: u64,
   ) {


       Mapping::set(choice_map, player, choice);


       let random_number: u32 = ChaCha::rand_u32();
       let random_number_mod37: u32 = random_number % 37u32; // 0 to 36     
       Mapping::set(random_number_map, player, random_number_mod37);


       let win: bool = false;




       // Check if the random number is in the user's choices
       for i: u32 in 0u32..32u32 {
           let d: u32 = choice[i];


           if !win && random_number_mod37 == choice[i] {
               win = true;
           }
       }
      



        
       let payout: u64 = bet_amount * (multiplier-1u64);


       let current_player_amount: u64 = Mapping::get_or_use(account, player, 0u64);
       let current_casino_balance: u64 = Mapping::get_or_use(account, casino_owner, 0u64);




       assert(current_player_amount > bet_amount);




       if (win) {
           current_player_amount += payout;
           current_casino_balance -= payout;
       } else {
           current_player_amount -= bet_amount;
           current_casino_balance += bet_amount;
       }


       Mapping::set(account, player, current_player_amount);
       Mapping::set(account, casino_owner, current_casino_balance);
   }


  
}
