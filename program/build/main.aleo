program cassino_game_test_13.aleo;

record WAC:
    owner as address.private;
    amount as u64.private;


mapping account:
	key as address.public;
	value as u64.public;


mapping random_number_map:
	key as address.public;
	value as u32.public;


mapping winner:
	key as address.public;
	value as boolean.public;

function deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    async deposit_public r0 r1 into r2;
    output r2 as cassino_game_test_13.aleo/deposit_public.future;

finalize deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function desposit_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as WAC.record;
    output r2 as WAC.record;


function withdraw_public:
    input r0 as address.public;
    input r1 as u64.public;
    async withdraw_public self.caller r0 r1 into r2;
    output r2 as cassino_game_test_13.aleo/withdraw_public.future;

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


function random_number_generate:
    input r0 as address.public;
    async random_number_generate self.caller into r1;
    output r1 as cassino_game_test_13.aleo/random_number_generate.future;

finalize random_number_generate:
    input r0 as address.public;
    rand.chacha into r1 as u32;
    get.or_use random_number_map[r0] 0u32 into r2;
    set r1 into random_number_map[r0];


function make_odd_even_bet_private:
    input r0 as WAC.record;
    input r1 as WAC.record;
    input r2 as u64.private;
    input r3 as u32.public;
    input r4 as u32.public;
    rem r4 2u32 into r5;
    is.eq r5 r3 into r6;
    add r1.amount r2 into r7;
    sub r0.amount r2 into r8;
    sub r1.amount r2 into r9;
    add r0.amount r2 into r10;
    ternary r6 r7 r9 into r11;
    ternary r6 r8 r10 into r12;
    cast r1.owner r11 into r13 as WAC.record;
    cast r0.owner r12 into r14 as WAC.record;
    output r13 as WAC.record;
    output r14 as WAC.record;


function make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    is.eq r2 0u32 into r5;
    is.eq r2 1u32 into r6;
    or r5 r6 into r7;
    assert.eq r7 true;
    async make_odd_even_bet_public r0 r1 r2 r3 self.caller into r8;
    output r8 as cassino_game_test_13.aleo/make_odd_even_bet_public.future;

finalize make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    input r4 as address.public;
    rem r3 2u32 into r5;
    is.eq r5 r2 into r6;
    set r6 into winner[r4];
    get.or_use account[r4] 0u64 into r7;
    get.or_use account[r0] 0u64 into r8;
    gt r7 r1 into r9;
    assert.eq r9 true;
    add r7 r1 into r10;
    sub r8 r1 into r11;
    set r10 into account[r4];
    set r11 into account[r0];
    sub r7 r1 into r12;
    add r8 r1 into r13;
    set r12 into account[r4];
    set r13 into account[r0];
    ternary r6 r10 r12 into r14;
    ternary r6 r11 r13 into r15;
