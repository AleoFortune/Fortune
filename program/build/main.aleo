program cassino_game_test_6.aleo;

record WAC:
    owner as address.private;
    amount as u64.private;

record winner_private:
    owner as address.private;
    win as boolean.private;
    reward as u64.private;


mapping account:
	key as address.public;
	value as u64.public;


mapping random_number_map:
	key as address.public;
	value as u32.public;


mapping winner:
	key as address.public;
	value as boolean.public;


mapping red_bet:
	key as address.public;
	value as u64.public;


mapping black_bet:
	key as address.public;
	value as u64.public;

function deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    async deposit_public r0 r1 into r2;
    output r2 as cassino_game_test_6.aleo/deposit_public.future;

finalize deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function deposit_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as WAC.record;
    output r2 as WAC.record;


function withdraw_public:
    input r0 as address.public;
    input r1 as u64.public;
    async withdraw_public self.caller r0 r1 into r2;
    output r2 as cassino_game_test_6.aleo/withdraw_public.future;

finalize withdraw_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get.or_use account[r0] 0u64 into r3;
    sub r3 r2 into r4;
    set r4 into account[r0];
    get.or_use account[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into account[r1];


function withdraw_private:
    input r0 as WAC.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as WAC.record;
    cast r1 r2 into r5 as WAC.record;
    output r4 as WAC.record;
    output r5 as WAC.record;


function make_odd_even_bet_private:
    input r0 as WAC.record;
    input r1 as WAC.record;
    input r2 as boolean.private;
    input r3 as u64.private;
    add r1.amount r3 into r4;
    sub r0.amount r3 into r5;
    sub r1.amount r3 into r6;
    add r0.amount r3 into r7;
    ternary r2 r4 r6 into r8;
    ternary r2 r5 r7 into r9;
    cast r1.owner r8 into r10 as WAC.record;
    cast r0.owner r9 into r11 as WAC.record;
    output r10 as WAC.record;
    output r11 as WAC.record;


function make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    gt r1 0u64 into r3;
    assert.eq r3 true;
    is.eq r2 0u32 into r4;
    is.eq r2 1u32 into r5;
    or r4 r5 into r6;
    assert.eq r6 true;
    async make_odd_even_bet_public r0 r1 r2 self.caller into r7;
    output r7 as cassino_game_test_6.aleo/make_odd_even_bet_public.future;

finalize make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    get.or_use random_number_map[r3] 0u32 into r5;
    set r4 into random_number_map[r3];
    rem r5 2u32 into r6;
    is.eq r6 r2 into r7;
    set r7 into winner[r3];
    mul r1 2u64 into r8;
    get.or_use account[r3] 0u64 into r9;
    get.or_use account[r0] 0u64 into r10;
    gt r9 r1 into r11;
    assert.eq r11 true;
    add r9 r8 into r12;
    sub r10 r8 into r13;
    set r12 into account[r3];
    set r13 into account[r0];
    sub r9 r8 into r14;
    add r10 r8 into r15;
    set r14 into account[r3];
    set r15 into account[r0];
    ternary r7 r12 r14 into r16;
    ternary r7 r13 r15 into r17;
