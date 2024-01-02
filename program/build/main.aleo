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
    rem r4 37u32 into r5;
    get.or_use random_number_map[r3] 0u32 into r6;
    set r5 into random_number_map[r3];
    rem r6 2u32 into r7;
    is.eq r7 r2 into r8;
    set r8 into winner[r3];
    mul r1 2u64 into r9;
    get.or_use account[r3] 0u64 into r10;
    get.or_use account[r0] 0u64 into r11;
    gt r10 r1 into r12;
    assert.eq r12 true;
    add r10 r9 into r13;
    sub r11 r9 into r14;
    set r13 into account[r3];
    set r14 into account[r0];
    sub r10 r9 into r15;
    add r11 r9 into r16;
    set r15 into account[r3];
    set r16 into account[r0];
    ternary r8 r13 r15 into r17;
    ternary r8 r14 r16 into r18;


closure is_number_red:
    input r0 as u32;
    is.eq r0 1u32 into r1;
    is.eq r0 3u32 into r2;
    or r1 r2 into r3;
    is.eq r0 5u32 into r4;
    or r3 r4 into r5;
    is.eq r0 7u32 into r6;
    or r5 r6 into r7;
    is.eq r0 9u32 into r8;
    or r7 r8 into r9;
    is.eq r0 12u32 into r10;
    or r9 r10 into r11;
    is.eq r0 14u32 into r12;
    or r11 r12 into r13;
    is.eq r0 16u32 into r14;
    or r13 r14 into r15;
    is.eq r0 18u32 into r16;
    or r15 r16 into r17;
    is.eq r0 19u32 into r18;
    or r17 r18 into r19;
    is.eq r0 21u32 into r20;
    or r19 r20 into r21;
    is.eq r0 23u32 into r22;
    or r21 r22 into r23;
    is.eq r0 25u32 into r24;
    or r23 r24 into r25;
    is.eq r0 27u32 into r26;
    or r25 r26 into r27;
    is.eq r0 30u32 into r28;
    or r27 r28 into r29;
    is.eq r0 32u32 into r30;
    or r29 r30 into r31;
    is.eq r0 34u32 into r32;
    or r31 r32 into r33;
    is.eq r0 36u32 into r34;
    or r33 r34 into r35;
    output r35 as boolean;


function make_red_black_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    gt r1 0u64 into r3;
    assert.eq r3 true;
    async make_red_black_bet_public r0 r1 r2 self.caller into r4;
    output r4 as cassino_game_test_6.aleo/make_red_black_bet_public.future;

finalize make_red_black_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    rem r4 37u32 into r5;
    is.eq r5 1u32 into r6;
    is.eq r5 3u32 into r7;
    or r6 r7 into r8;
    is.eq r5 5u32 into r9;
    or r8 r9 into r10;
    is.eq r5 7u32 into r11;
    or r10 r11 into r12;
    is.eq r5 9u32 into r13;
    or r12 r13 into r14;
    is.eq r5 12u32 into r15;
    or r14 r15 into r16;
    is.eq r5 14u32 into r17;
    or r16 r17 into r18;
    is.eq r5 16u32 into r19;
    or r18 r19 into r20;
    is.eq r5 18u32 into r21;
    or r20 r21 into r22;
    is.eq r5 19u32 into r23;
    or r22 r23 into r24;
    is.eq r5 21u32 into r25;
    or r24 r25 into r26;
    is.eq r5 23u32 into r27;
    or r26 r27 into r28;
    is.eq r5 25u32 into r29;
    or r28 r29 into r30;
    is.eq r5 27u32 into r31;
    or r30 r31 into r32;
    is.eq r5 30u32 into r33;
    or r32 r33 into r34;
    is.eq r5 32u32 into r35;
    or r34 r35 into r36;
    is.eq r5 34u32 into r37;
    or r36 r37 into r38;
    is.eq r5 36u32 into r39;
    or r38 r39 into r40;
    and r2 r40 into r41;
    not r2 into r42;
    not r40 into r43;
    and r42 r43 into r44;
    is.neq r5 0u32 into r45;
    and r44 r45 into r46;
    or r41 r46 into r47;
    set r47 into winner[r3];
    mul r1 2u64 into r48;
    get.or_use account[r3] 0u64 into r49;
    get.or_use account[r0] 0u64 into r50;
    gte r49 r1 into r51;
    assert.eq r51 true;
    add r49 r48 into r52;
    sub r50 r1 into r53;
    sub r49 r1 into r54;
    add r50 r1 into r55;
    ternary r47 r52 r54 into r56;
    ternary r47 r53 r55 into r57;
    set r56 into account[r3];
    set r57 into account[r0];
