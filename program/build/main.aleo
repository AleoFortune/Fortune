program cassino_game_test_ekim.aleo;

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
    output r2 as cassino_game_test_ekim.aleo/deposit_public.future;

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
    output r2 as cassino_game_test_ekim.aleo/withdraw_public.future;

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
    output r1 as cassino_game_test_ekim.aleo/random_number_generate.future;

finalize random_number_generate:
    input r0 as address.public;
    rand.chacha into r1 as u32;
    rem r1 37u32 into r2;
    set r2 into random_number_map[r0];


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
    output r8 as cassino_game_test_ekim.aleo/make_odd_even_bet_public.future;

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
    sub r7 r1 into r12;
    add r8 r1 into r13;
    ternary r6 r10 r12 into r14;
    ternary r6 r11 r13 into r15;
    set r14 into account[r4];
    set r15 into account[r0];


function make_straightup_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    async make_straightup_bet_public r0 r1 r2 r3 self.caller into r4;
    output r4 as cassino_game_test_ekim.aleo/make_straightup_bet_public.future;

finalize make_straightup_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    input r4 as address.public;
    is.eq r3 r2 into r5;
    set r5 into winner[r4];
    get.or_use account[r4] 0u64 into r6;
    get.or_use account[r0] 0u64 into r7;
    mul 35u64 r1 into r8;
    add r6 r8 into r9;
    mul 35u64 r1 into r10;
    sub r7 r10 into r11;
    sub r6 r1 into r12;
    add r7 r1 into r13;
    ternary r5 r9 r12 into r14;
    ternary r5 r11 r13 into r15;
    set r14 into account[r4];
    set r15 into account[r0];


function make_red_black_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as u32.public;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    async make_red_black_bet_public r0 r1 r2 r3 self.caller into r5;
    output r5 as cassino_game_test_ekim.aleo/make_red_black_bet_public.future;

finalize make_red_black_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as u32.public;
    input r4 as address.public;
    is.eq r3 1u32 into r5;
    is.eq r3 3u32 into r6;
    or r5 r6 into r7;
    is.eq r3 5u32 into r8;
    or r7 r8 into r9;
    is.eq r3 7u32 into r10;
    or r9 r10 into r11;
    is.eq r3 9u32 into r12;
    or r11 r12 into r13;
    is.eq r3 12u32 into r14;
    or r13 r14 into r15;
    is.eq r3 14u32 into r16;
    or r15 r16 into r17;
    is.eq r3 16u32 into r18;
    or r17 r18 into r19;
    is.eq r3 18u32 into r20;
    or r19 r20 into r21;
    is.eq r3 19u32 into r22;
    or r21 r22 into r23;
    is.eq r3 21u32 into r24;
    or r23 r24 into r25;
    is.eq r3 23u32 into r26;
    or r25 r26 into r27;
    is.eq r3 25u32 into r28;
    or r27 r28 into r29;
    is.eq r3 27u32 into r30;
    or r29 r30 into r31;
    is.eq r3 30u32 into r32;
    or r31 r32 into r33;
    is.eq r3 32u32 into r34;
    or r33 r34 into r35;
    is.eq r3 34u32 into r36;
    or r35 r36 into r37;
    is.eq r3 36u32 into r38;
    or r37 r38 into r39;
    and r2 r39 into r40;
    not r2 into r41;
    not r39 into r42;
    and r41 r42 into r43;
    is.neq r3 0u32 into r44;
    and r43 r44 into r45;
    or r40 r45 into r46;
    set r46 into winner[r4];
    get.or_use account[r4] 0u64 into r47;
    get.or_use account[r0] 0u64 into r48;
    gte r47 r1 into r49;
    assert.eq r49 true;
    add r47 r1 into r50;
    sub r48 r1 into r51;
    sub r47 r1 into r52;
    add r48 r1 into r53;
    ternary r46 r50 r52 into r54;
    ternary r46 r51 r53 into r55;
    set r54 into account[r4];
    set r55 into account[r0];


function make_dozen_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    gte r2 1u32 into r5;
    lte r2 3u32 into r6;
    and r5 r6 into r7;
    assert.eq r7 true;
    async make_dozen_bet_public r0 r1 r2 r3 self.caller into r8;
    output r8 as cassino_game_test_ekim.aleo/make_dozen_bet_public.future;

finalize make_dozen_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as u32.public;
    input r4 as address.public;
    is.eq r2 1u32 into r5;
    gte r3 1u32 into r6;
    lte r3 12u32 into r7;
    and r6 r7 into r8;
    is.eq r2 2u32 into r9;
    gte r3 13u32 into r10;
    lte r3 24u32 into r11;
    and r10 r11 into r12;
    is.eq r2 3u32 into r13;
    gte r3 25u32 into r14;
    lte r3 36u32 into r15;
    and r14 r15 into r16;
    ternary r13 r16 false into r17;
    ternary r9 r12 r17 into r18;
    ternary r5 r8 r18 into r19;
    set r19 into winner[r4];
    get.or_use account[r4] 0u64 into r20;
    get.or_use account[r0] 0u64 into r21;
    gte r20 r1 into r22;
    assert.eq r22 true;
    mul r1 2u64 into r23;
    add r20 r23 into r24;
    mul r1 2u64 into r25;
    sub r21 r25 into r26;
    sub r20 r1 into r27;
    add r21 r1 into r28;
    ternary r19 r24 r27 into r29;
    ternary r19 r26 r28 into r30;
    set r29 into account[r4];
    set r30 into account[r0];


function make_low_high_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as u32.public;
    gt r1 0u64 into r4;
    assert.eq r4 true;
    async make_low_high_bet_public r0 r1 r2 r3 self.caller into r5;
    output r5 as cassino_game_test_ekim.aleo/make_low_high_bet_public.future;

finalize make_low_high_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as u32.public;
    input r4 as address.public;
    gte r3 1u32 into r5;
    lte r3 18u32 into r6;
    and r5 r6 into r7;
    gte r3 19u32 into r8;
    lte r3 36u32 into r9;
    and r8 r9 into r10;
    ternary r2 r7 r10 into r11;
    set r11 into winner[r4];
    get.or_use account[r4] 0u64 into r12;
    get.or_use account[r0] 0u64 into r13;
    gte r12 r1 into r14;
    assert.eq r14 true;
    add r12 r1 into r15;
    sub r13 r1 into r16;
    sub r12 r1 into r17;
    add r13 r1 into r18;
    ternary r11 r15 r17 into r19;
    ternary r11 r16 r18 into r20;
    set r19 into account[r4];
    set r20 into account[r0];
