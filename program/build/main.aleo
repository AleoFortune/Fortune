program cassino_game_test_fp.aleo;



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
    output r2 as cassino_game_test_fp.aleo/deposit_public.future;

finalize deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function withdraw_public:
    input r0 as address.public;
    input r1 as u64.public;
    async withdraw_public self.caller r0 r1 into r2;
    output r2 as cassino_game_test_fp.aleo/withdraw_public.future;

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


function make_odd_even_bet_public:
    input r0 as u64.public;
    input r1 as u32.public;
    gt r0 0u64 into r2;
    assert.eq r2 true;
    is.eq r1 0u32 into r3;
    is.eq r1 1u32 into r4;
    or r3 r4 into r5;
    assert.eq r5 true;
    async make_odd_even_bet_public aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5 r0 r1 self.caller into r6;
    output r6 as cassino_game_test_fp.aleo/make_odd_even_bet_public.future;

finalize make_odd_even_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    rem r4 37u32 into r5;
    rem r5 2u32 into r6;
    is.eq r6 r2 into r7;
    set r7 into winner[r3];
    get.or_use account[r3] 0u64 into r8;
    get.or_use account[r0] 0u64 into r9;
    gt r8 r1 into r10;
    assert.eq r10 true;
    add r8 r1 into r11;
    sub r9 r1 into r12;
    sub r8 r1 into r13;
    add r9 r1 into r14;
    ternary r7 r11 r13 into r15;
    ternary r7 r12 r14 into r16;
    set r15 into account[r3];
    set r16 into account[r0];


function make_straightup_bet_public:
    input r0 as u64.public;
    input r1 as u32.public;
    async make_straightup_bet_public aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5 r0 r1 self.caller into r2;
    output r2 as cassino_game_test_fp.aleo/make_straightup_bet_public.future;

finalize make_straightup_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    rem r4 37u32 into r5;
    is.eq r5 r2 into r6;
    set r6 into winner[r3];
    get.or_use account[r3] 0u64 into r7;
    get.or_use account[r0] 0u64 into r8;
    mul 35u64 r1 into r9;
    add r7 r9 into r10;
    mul 35u64 r1 into r11;
    sub r8 r11 into r12;
    sub r7 r1 into r13;
    add r8 r1 into r14;
    ternary r6 r10 r13 into r15;
    ternary r6 r12 r14 into r16;
    set r15 into account[r3];
    set r16 into account[r0];


function make_red_black_bet_public:
    input r0 as u64.public;
    input r1 as boolean.public;
    gt r0 0u64 into r2;
    assert.eq r2 true;
    async make_red_black_bet_public aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5 r0 r1 self.caller into r3;
    output r3 as cassino_game_test_fp.aleo/make_red_black_bet_public.future;

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
    get.or_use account[r3] 0u64 into r48;
    get.or_use account[r0] 0u64 into r49;
    gte r48 r1 into r50;
    assert.eq r50 true;
    add r48 r1 into r51;
    sub r49 r1 into r52;
    sub r48 r1 into r53;
    add r49 r1 into r54;
    ternary r47 r51 r53 into r55;
    ternary r47 r52 r54 into r56;
    set r55 into account[r3];
    set r56 into account[r0];


function make_dozen_bet_public:
    input r0 as u64.public;
    input r1 as u32.public;
    gt r0 0u64 into r2;
    assert.eq r2 true;
    gte r1 1u32 into r3;
    lte r1 3u32 into r4;
    and r3 r4 into r5;
    assert.eq r5 true;
    async make_dozen_bet_public aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5 r0 r1 self.caller into r6;
    output r6 as cassino_game_test_fp.aleo/make_dozen_bet_public.future;

finalize make_dozen_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u32.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    rem r4 37u32 into r5;
    is.eq r2 1u32 into r6;
    gte r5 1u32 into r7;
    lte r5 12u32 into r8;
    and r7 r8 into r9;
    is.eq r2 2u32 into r10;
    gte r5 13u32 into r11;
    lte r5 24u32 into r12;
    and r11 r12 into r13;
    is.eq r2 3u32 into r14;
    gte r5 25u32 into r15;
    lte r5 36u32 into r16;
    and r15 r16 into r17;
    ternary r14 r17 false into r18;
    ternary r10 r13 r18 into r19;
    ternary r6 r9 r19 into r20;
    set r20 into winner[r3];
    get.or_use account[r3] 0u64 into r21;
    get.or_use account[r0] 0u64 into r22;
    gte r21 r1 into r23;
    assert.eq r23 true;
    mul r1 2u64 into r24;
    add r21 r24 into r25;
    mul r1 2u64 into r26;
    sub r22 r26 into r27;
    sub r21 r1 into r28;
    add r22 r1 into r29;
    ternary r20 r25 r28 into r30;
    ternary r20 r27 r29 into r31;
    set r30 into account[r3];
    set r31 into account[r0];


function make_low_high_bet_public:
    input r0 as u64.public;
    input r1 as boolean.public;
    gt r0 0u64 into r2;
    assert.eq r2 true;
    async make_low_high_bet_public aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5 r0 r1 self.caller into r3;
    output r3 as cassino_game_test_fp.aleo/make_low_high_bet_public.future;

finalize make_low_high_bet_public:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as boolean.public;
    input r3 as address.public;
    rand.chacha into r4 as u32;
    rem r4 37u32 into r5;
    gte r5 1u32 into r6;
    lte r5 18u32 into r7;
    and r6 r7 into r8;
    gte r5 19u32 into r9;
    lte r5 36u32 into r10;
    and r9 r10 into r11;
    ternary r2 r8 r11 into r12;
    set r12 into winner[r3];
    get.or_use account[r3] 0u64 into r13;
    get.or_use account[r0] 0u64 into r14;
    gte r13 r1 into r15;
    assert.eq r15 true;
    add r13 r1 into r16;
    sub r14 r1 into r17;
    sub r13 r1 into r18;
    add r14 r1 into r19;
    ternary r12 r16 r18 into r20;
    ternary r12 r17 r19 into r21;
    set r20 into account[r3];
    set r21 into account[r0];
