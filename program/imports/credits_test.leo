program credits_test.aleo {

    mapping balance: address=>u64;


    record Token {
        owner: address,
        amount: u64
    }
    
    /* Mint casino token to test contarct after all functions are correct. Credits.aleo will be used */
    transition mint_public(public receiver: address, public amount: u64) {
    // Only OWNER_ADDRESS can mint -- think of this as JPOWELL and Money printer priveleges
    // Removing assertion for demo at ZK Summit for iOS
    // assert_eq(self.caller, OWNER_ADDRESS);
    return then finalize(receiver, amount);
    }

    finalize mint_public(public receiver: address, public amount: u64) {
    let receiver_amount: u64 = Mapping::get_or_use(balance, receiver, 0u64);
    Mapping::set(balance, receiver, receiver_amount + amount);
    }
}