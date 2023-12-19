program cassino_game_test_6.aleo;

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

function mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    async mint_public r0 r1 into r2;
    output r2 as cassino_game_test_6.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function mint_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as WAC.record;
    output r2 as WAC.record;


function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as cassino_game_test_6.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get.or_use account[r0] 0u64 into r3;
    sub r3 r2 into r4;
    set r4 into account[r0];
    get.or_use account[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into account[r1];


function transfer_private:
    input r0 as WAC.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as WAC.record;
    cast r1 r2 into r5 as WAC.record;
    output r4 as WAC.record;
    output r5 as WAC.record;


function transfer_private_to_public:
    input r0 as WAC.record;
    input r1 as address.public;
    input r2 as u64.public;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as WAC.record;
    async transfer_private_to_public r1 r2 into r5;
    output r4 as WAC.record;
    output r5 as cassino_game_test_6.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;
    cast r0 r1 into r2 as WAC.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as WAC.record;
    output r3 as cassino_game_test_6.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    sub r2 r1 into r3;
    set r3 into account[r0];


function random_number:
    input r0 as address.public;
    async random_number r0 into r1;
    output r1 as cassino_game_test_6.aleo/random_number.future;

finalize random_number:
    input r0 as address.public;
    rand.chacha into r1 as u32;
    get.or_use random_number_map[r0] 0u32 into r2;
    set r1 into random_number_map[r0];
    rem r2 2u32 into r3;
    is.eq r3 0u32 into r4;
    set r4 into winner[r0];


function make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    is.eq r2 0u32 into r5;
    is.eq r2 1u32 into r6;
    or r5 r6 into r7;
    assert.eq r7 true;
    async make_odd_even_bet_public r0 r1 r2 self.caller into r8;
    output r8 as cassino_game_test_6.aleo/make_odd_even_bet_public.future;

finalize make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    get random_number_map[r3] into r4;
    rem r4 2u32 into r5;
    is.eq r5 r2 into r6;
    set r6 into winner[r3];
    mul r1 2u64 into r7;
    get.or_use account[r3] 0u64 into r8;
    get.or_use account[r0] 0u64 into r9;
    gt r8 r1 into r10;
    assert.eq r10 true;
    add r8 r7 into r11;
    sub r9 r7 into r12;
    set r11 into account[r3];
    set r12 into account[r0];
    sub r8 r7 into r13;
    add r9 r7 into r14;
    set r13 into account[r3];
    set r14 into account[r0];
    ternary r6 r11 r13 into r15;
    ternary r6 r12 r14 into r16;
