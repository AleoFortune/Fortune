program fortune_newlogic.aleo;

record WAC:
    owner as address.private;
    amount as u64.private;


mapping account:
	key as address.public;
	value as u64.public;


mapping random_number_map:
	key as address.public;
	value as u32.public;


mapping choice_map:
	key as address.public;
	value as [u32; 32u32].public;

function deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    async deposit_public r0 r1 into r2;
    output r2 as fortune_newlogic.aleo/deposit_public.future;

finalize deposit_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function place_bet_public:
    input r0 as u64.public;
    input r1 as [u32; 32u32].public;
    input r2 as u64.public;
    async place_bet_public aleo1l8lyps4rm43lklhnt0yaupvtz758d3dx2wzfr6uqwwg4tk4lev9qvguw09 self.caller r0 r1 r2 into r3;
    output r3 as fortune_newlogic.aleo/place_bet_public.future;

finalize place_bet_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    input r3 as [u32; 32u32].public;
    input r4 as u64.public;
    set r3 into choice_map[r1];
    rand.chacha into r5 as u32;
    rem r5 37u32 into r6;
    set r6 into random_number_map[r1];
    not false into r7;
    is.eq r6 r3[0u32] into r8;
    and r7 r8 into r9;
    ternary r9 true false into r10;
    not r10 into r11;
    is.eq r6 r3[1u32] into r12;
    and r11 r12 into r13;
    ternary r13 true r10 into r14;
    not r14 into r15;
    is.eq r6 r3[2u32] into r16;
    and r15 r16 into r17;
    ternary r17 true r14 into r18;
    not r18 into r19;
    is.eq r6 r3[3u32] into r20;
    and r19 r20 into r21;
    ternary r21 true r18 into r22;
    not r22 into r23;
    is.eq r6 r3[4u32] into r24;
    and r23 r24 into r25;
    ternary r25 true r22 into r26;
    not r26 into r27;
    is.eq r6 r3[5u32] into r28;
    and r27 r28 into r29;
    ternary r29 true r26 into r30;
    not r30 into r31;
    is.eq r6 r3[6u32] into r32;
    and r31 r32 into r33;
    ternary r33 true r30 into r34;
    not r34 into r35;
    is.eq r6 r3[7u32] into r36;
    and r35 r36 into r37;
    ternary r37 true r34 into r38;
    not r38 into r39;
    is.eq r6 r3[8u32] into r40;
    and r39 r40 into r41;
    ternary r41 true r38 into r42;
    not r42 into r43;
    is.eq r6 r3[9u32] into r44;
    and r43 r44 into r45;
    ternary r45 true r42 into r46;
    not r46 into r47;
    is.eq r6 r3[10u32] into r48;
    and r47 r48 into r49;
    ternary r49 true r46 into r50;
    not r50 into r51;
    is.eq r6 r3[11u32] into r52;
    and r51 r52 into r53;
    ternary r53 true r50 into r54;
    not r54 into r55;
    is.eq r6 r3[12u32] into r56;
    and r55 r56 into r57;
    ternary r57 true r54 into r58;
    not r58 into r59;
    is.eq r6 r3[13u32] into r60;
    and r59 r60 into r61;
    ternary r61 true r58 into r62;
    not r62 into r63;
    is.eq r6 r3[14u32] into r64;
    and r63 r64 into r65;
    ternary r65 true r62 into r66;
    not r66 into r67;
    is.eq r6 r3[15u32] into r68;
    and r67 r68 into r69;
    ternary r69 true r66 into r70;
    not r70 into r71;
    is.eq r6 r3[16u32] into r72;
    and r71 r72 into r73;
    ternary r73 true r70 into r74;
    not r74 into r75;
    is.eq r6 r3[17u32] into r76;
    and r75 r76 into r77;
    ternary r77 true r74 into r78;
    not r78 into r79;
    is.eq r6 r3[18u32] into r80;
    and r79 r80 into r81;
    ternary r81 true r78 into r82;
    not r82 into r83;
    is.eq r6 r3[19u32] into r84;
    and r83 r84 into r85;
    ternary r85 true r82 into r86;
    not r86 into r87;
    is.eq r6 r3[20u32] into r88;
    and r87 r88 into r89;
    ternary r89 true r86 into r90;
    not r90 into r91;
    is.eq r6 r3[21u32] into r92;
    and r91 r92 into r93;
    ternary r93 true r90 into r94;
    not r94 into r95;
    is.eq r6 r3[22u32] into r96;
    and r95 r96 into r97;
    ternary r97 true r94 into r98;
    not r98 into r99;
    is.eq r6 r3[23u32] into r100;
    and r99 r100 into r101;
    ternary r101 true r98 into r102;
    not r102 into r103;
    is.eq r6 r3[24u32] into r104;
    and r103 r104 into r105;
    ternary r105 true r102 into r106;
    not r106 into r107;
    is.eq r6 r3[25u32] into r108;
    and r107 r108 into r109;
    ternary r109 true r106 into r110;
    not r110 into r111;
    is.eq r6 r3[26u32] into r112;
    and r111 r112 into r113;
    ternary r113 true r110 into r114;
    not r114 into r115;
    is.eq r6 r3[27u32] into r116;
    and r115 r116 into r117;
    ternary r117 true r114 into r118;
    not r118 into r119;
    is.eq r6 r3[28u32] into r120;
    and r119 r120 into r121;
    ternary r121 true r118 into r122;
    not r122 into r123;
    is.eq r6 r3[29u32] into r124;
    and r123 r124 into r125;
    ternary r125 true r122 into r126;
    not r126 into r127;
    is.eq r6 r3[30u32] into r128;
    and r127 r128 into r129;
    ternary r129 true r126 into r130;
    not r130 into r131;
    is.eq r6 r3[31u32] into r132;
    and r131 r132 into r133;
    ternary r133 true r130 into r134;
    mul r2 r4 into r135;
    get.or_use account[r1] 0u64 into r136;
    get.or_use account[r0] 0u64 into r137;
    gt r136 r2 into r138;
    assert.eq r138 true;
    add r136 r135 into r139;
    sub r137 r135 into r140;
    sub r136 r2 into r141;
    add r137 r2 into r142;
    ternary r134 r139 r141 into r143;
    ternary r134 r140 r142 into r144;
    set r143 into account[r1];
    set r144 into account[r0];
