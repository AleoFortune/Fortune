program cassino_game_test_3.aleo;



mapping balance:
	key as address.public;
	value as u64.public;


mapping winner:
	key as address.public;
	value as boolean.public;


mapping random_number_map:
	key as address.public;
	value as u32.public;

function make_odd_even_bet:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as u32.private;
    input r3 as address.private;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    is.eq r2 0u32 into r5;
    is.eq r2 1u32 into r6;
    or r5 r6 into r7;
    assert.eq r7 true;
    async make_odd_even_bet r0 r1 r2 self.caller into r8;
    output r8 as cassino_game_test_3.aleo/make_odd_even_bet.future;

finalize make_odd_even_bet:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    set r4 into random_number_map[r3];
    rem r4 2u32 into r5;
    is.eq r5 r2 into r6;
    set r6 into winner[r3];
    mul r1 2u64 into r7;
    get.or_use balance[r3] 100u64 into r8;
    get.or_use balance[r0] 100u64 into r9;
    gt r8 r1 into r10;
    assert.eq r10 true;
    add r8 r7 into r11;
    sub r9 r7 into r12;
    set r11 into balance[r3];
    set r12 into balance[r0];
    sub r8 r7 into r13;
    add r9 r7 into r14;
    set r13 into balance[r3];
    set r14 into balance[r0];
    ternary r6 r11 r13 into r15;
    ternary r6 r12 r14 into r16;
