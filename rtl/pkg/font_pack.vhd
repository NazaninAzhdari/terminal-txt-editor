library IEEE;
use IEEE.NUMERIC_STD.ALL;

package font_pack is
    ------------------------
    -- Type Decleration
    ------------------------
    type pt_array8x8 is array (0 to 7) of unsigned(0 to 7);

    -----------------------------------
    -- ASCII code of uppercase letters
    -----------------------------------
    constant pc_ASCII_CAPITAL_A     : unsigned(7 downto 0) := to_unsigned(65, 8);
    constant pc_ASCII_CAPITAL_B     : unsigned(7 downto 0) := to_unsigned(66, 8);
    constant pc_ASCII_CAPITAL_C     : unsigned(7 downto 0) := to_unsigned(67, 8);
    constant pc_ASCII_CAPITAL_D     : unsigned(7 downto 0) := to_unsigned(68, 8);
    constant pc_ASCII_CAPITAL_E     : unsigned(7 downto 0) := to_unsigned(69, 8);
    constant pc_ASCII_CAPITAL_F     : unsigned(7 downto 0) := to_unsigned(70, 8);
    constant pc_ASCII_CAPITAL_G     : unsigned(7 downto 0) := to_unsigned(71, 8);
    constant pc_ASCII_CAPITAL_H     : unsigned(7 downto 0) := to_unsigned(72, 8);
    constant pc_ASCII_CAPITAL_I     : unsigned(7 downto 0) := to_unsigned(73, 8);
    constant pc_ASCII_CAPITAL_J     : unsigned(7 downto 0) := to_unsigned(74, 8);
    constant pc_ASCII_CAPITAL_K     : unsigned(7 downto 0) := to_unsigned(75, 8);
    constant pc_ASCII_CAPITAL_L     : unsigned(7 downto 0) := to_unsigned(76, 8);
    constant pc_ASCII_CAPITAL_M     : unsigned(7 downto 0) := to_unsigned(77, 8);
    constant pc_ASCII_CAPITAL_N     : unsigned(7 downto 0) := to_unsigned(78, 8);
    constant pc_ASCII_CAPITAL_O     : unsigned(7 downto 0) := to_unsigned(79, 8);
    constant pc_ASCII_CAPITAL_P     : unsigned(7 downto 0) := to_unsigned(80, 8);
    constant pc_ASCII_CAPITAL_Q     : unsigned(7 downto 0) := to_unsigned(81, 8);
    constant pc_ASCII_CAPITAL_R     : unsigned(7 downto 0) := to_unsigned(82, 8);
    constant pc_ASCII_CAPITAL_S     : unsigned(7 downto 0) := to_unsigned(83, 8);
    constant pc_ASCII_CAPITAL_T     : unsigned(7 downto 0) := to_unsigned(84, 8);
    constant pc_ASCII_CAPITAL_U     : unsigned(7 downto 0) := to_unsigned(85, 8);
    constant pc_ASCII_CAPITAL_V     : unsigned(7 downto 0) := to_unsigned(86, 8);
    constant pc_ASCII_CAPITAL_W     : unsigned(7 downto 0) := to_unsigned(87, 8);
    constant pc_ASCII_CAPITAL_X     : unsigned(7 downto 0) := to_unsigned(88, 8);
    constant pc_ASCII_CAPITAL_Y     : unsigned(7 downto 0) := to_unsigned(89, 8);
    constant pc_ASCII_CAPITAL_Z     : unsigned(7 downto 0) := to_unsigned(90, 8);

    -----------------------------------
    -- ASCII code of lowercase letters
    -----------------------------------
    constant pc_ASCII_SMALL_a       : unsigned(7 downto 0) := to_unsigned(97, 8);
    constant pc_ASCII_SMALL_b       : unsigned(7 downto 0) := to_unsigned(98, 8);
    constant pc_ASCII_SMALL_c       : unsigned(7 downto 0) := to_unsigned(99, 8);
    constant pc_ASCII_SMALL_d       : unsigned(7 downto 0) := to_unsigned(100, 8);
    constant pc_ASCII_SMALL_e       : unsigned(7 downto 0) := to_unsigned(101, 8);
    constant pc_ASCII_SMALL_f       : unsigned(7 downto 0) := to_unsigned(102, 8);
    constant pc_ASCII_SMALL_g       : unsigned(7 downto 0) := to_unsigned(103, 8);
    constant pc_ASCII_SMALL_h       : unsigned(7 downto 0) := to_unsigned(104, 8);
    constant pc_ASCII_SMALL_i       : unsigned(7 downto 0) := to_unsigned(105, 8);
    constant pc_ASCII_SMALL_j       : unsigned(7 downto 0) := to_unsigned(106, 8);
    constant pc_ASCII_SMALL_k       : unsigned(7 downto 0) := to_unsigned(107, 8);
    constant pc_ASCII_SMALL_l       : unsigned(7 downto 0) := to_unsigned(108, 8);
    constant pc_ASCII_SMALL_m       : unsigned(7 downto 0) := to_unsigned(109, 8);
    constant pc_ASCII_SMALL_n       : unsigned(7 downto 0) := to_unsigned(110, 8);
    constant pc_ASCII_SMALL_o       : unsigned(7 downto 0) := to_unsigned(111, 8);
    constant pc_ASCII_SMALL_p       : unsigned(7 downto 0) := to_unsigned(112, 8);
    constant pc_ASCII_SMALL_q       : unsigned(7 downto 0) := to_unsigned(113, 8);
    constant pc_ASCII_SMALL_r       : unsigned(7 downto 0) := to_unsigned(114, 8);
    constant pc_ASCII_SMALL_s       : unsigned(7 downto 0) := to_unsigned(115, 8);
    constant pc_ASCII_SMALL_t       : unsigned(7 downto 0) := to_unsigned(116, 8);
    constant pc_ASCII_SMALL_u       : unsigned(7 downto 0) := to_unsigned(117, 8);
    constant pc_ASCII_SMALL_v       : unsigned(7 downto 0) := to_unsigned(118, 8);
    constant pc_ASCII_SMALL_w       : unsigned(7 downto 0) := to_unsigned(119, 8);
    constant pc_ASCII_SMALL_x       : unsigned(7 downto 0) := to_unsigned(120, 8);
    constant pc_ASCII_SMALL_y       : unsigned(7 downto 0) := to_unsigned(121, 8);
    constant pc_ASCII_SMALL_z       : unsigned(7 downto 0) := to_unsigned(122, 8);

    -----------------------------------
    -- ASCII code of digits
    -----------------------------------
    constant pc_ASCII_DIGIT_0       : unsigned(7 downto 0) := to_unsigned(48, 8);
    constant pc_ASCII_DIGIT_1       : unsigned(7 downto 0) := to_unsigned(49, 8);
    constant pc_ASCII_DIGIT_2       : unsigned(7 downto 0) := to_unsigned(50, 8);
    constant pc_ASCII_DIGIT_3       : unsigned(7 downto 0) := to_unsigned(51, 8);
    constant pc_ASCII_DIGIT_4       : unsigned(7 downto 0) := to_unsigned(52, 8);
    constant pc_ASCII_DIGIT_5       : unsigned(7 downto 0) := to_unsigned(53, 8);
    constant pc_ASCII_DIGIT_6       : unsigned(7 downto 0) := to_unsigned(54, 8);
    constant pc_ASCII_DIGIT_7       : unsigned(7 downto 0) := to_unsigned(55, 8);
    constant pc_ASCII_DIGIT_8       : unsigned(7 downto 0) := to_unsigned(56, 8);
    constant pc_ASCII_DIGIT_9       : unsigned(7 downto 0) := to_unsigned(57, 8);

    ----------------------------------------
    -- ASCII code of signs and punctuations
    ----------------------------------------
    constant pc_ASCII_EXCLAMATION   : unsigned(7 downto 0) := to_unsigned(33, 8); -- !
    constant pc_ASCII_QUOTE         : unsigned(7 downto 0) := to_unsigned(34, 8); -- "
    constant pc_ASCII_HASH          : unsigned(7 downto 0) := to_unsigned(35, 8); -- #
    constant pc_ASCII_DOLLAR        : unsigned(7 downto 0) := to_unsigned(36, 8); -- $
    constant pc_ASCII_PERCENT       : unsigned(7 downto 0) := to_unsigned(37, 8); -- %
    constant pc_ASCII_AMPERSAND     : unsigned(7 downto 0) := to_unsigned(38, 8); -- &
    constant pc_ASCII_APOSTROPHE    : unsigned(7 downto 0) := to_unsigned(39, 8); -- '
    constant pc_ASCII_LEFT_PAREN    : unsigned(7 downto 0) := to_unsigned(40, 8); -- (
    constant pc_ASCII_RIGHT_PAREN   : unsigned(7 downto 0) := to_unsigned(41, 8); -- )
    constant pc_ASCII_ASTERISK      : unsigned(7 downto 0) := to_unsigned(42, 8); -- *
    constant pc_ASCII_PLUS          : unsigned(7 downto 0) := to_unsigned(43, 8); -- +
    constant pc_ASCII_COMMA         : unsigned(7 downto 0) := to_unsigned(44, 8); -- ,
    constant pc_ASCII_MINUS         : unsigned(7 downto 0) := to_unsigned(45, 8); -- -
    constant pc_ASCII_PERIOD        : unsigned(7 downto 0) := to_unsigned(46, 8); -- .
    constant pc_ASCII_SLASH         : unsigned(7 downto 0) := to_unsigned(47, 8); -- /
    constant pc_ASCII_COLON         : unsigned(7 downto 0) := to_unsigned(58, 8); -- :
    constant pc_ASCII_SEMICOLON     : unsigned(7 downto 0) := to_unsigned(59, 8); -- ;
    constant pc_ASCII_LESS_THAN     : unsigned(7 downto 0) := to_unsigned(60, 8); -- <
    constant pc_ASCII_EQUAL         : unsigned(7 downto 0) := to_unsigned(61, 8); -- =
    constant pc_ASCII_GREATER_THAN  : unsigned(7 downto 0) := to_unsigned(62, 8); -- >
    constant pc_ASCII_QUESTION      : unsigned(7 downto 0) := to_unsigned(63, 8); -- ?
    constant pc_ASCII_AT            : unsigned(7 downto 0) := to_unsigned(64, 8); -- @

    --------------------------------
    -- ASCII Control characters
    --------------------------------
    constant pc_ASCII_BACKSPACE     : unsigned(7 downto 0) := to_unsigned(127, 8);
    constant pc_ASCII_ENTER         : unsigned(7 downto 0) := to_unsigned(13, 8);
    constant pc_ASCII_SPACE         : unsigned(7 downto 0) := to_unsigned(32, 8);

    ----------------------------------------
    -- Bit-Map of CAPITAL LETTERS (A–Z)
    ----------------------------------------
    constant pc_DRAW_CAPITAL_A : pt_array8x8 :=(
        "00011000",
        "00100100",
        "01000010",
        "01111110",
        "01000010",
        "01000010",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_B : pt_array8x8 :=(
        "01111100",
        "01000010",
        "01000010",
        "01111100",
        "01000010",
        "01000010",
        "01111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_C : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000000",
        "01000000",
        "01000000",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_D : pt_array8x8 :=(
        "01111000",
        "01000100",
        "01000010",
        "01000010",
        "01000010",
        "01000100",
        "01111000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_E : pt_array8x8 :=(
        "01111110",
        "01000000",
        "01000000",
        "01111100",
        "01000000",
        "01000000",
        "01111110",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_F : pt_array8x8 :=(
        "01111110",
        "01000000",
        "01000000",
        "01111100",
        "01000000",
        "01000000",
        "01000000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_G : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000000",
        "01011110",
        "01000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_H : pt_array8x8 :=(
        "01000010",
        "01000010",
        "01000010",
        "01111110",
        "01000010",
        "01000010",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_I : pt_array8x8 :=(
        "00111100",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_J : pt_array8x8 :=(
        "00011110",
        "00001000",
        "00001000",
        "00001000",
        "00001000",
        "01001000",
        "00110000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_K : pt_array8x8 :=(
        "01000010",
        "01000100",
        "01001000",
        "01110000",
        "01001000",
        "01000100",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_L : pt_array8x8 :=(
        "01000000",
        "01000000",
        "01000000",
        "01000000",
        "01000000",
        "01000000",
        "01111110",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_M : pt_array8x8 :=(
        "01000010",
        "01100110",
        "01011010",
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_N : pt_array8x8 :=(
        "01000010",
        "01100010",
        "01010010",
        "01001010",
        "01000110",
        "01000010",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_O : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_P : pt_array8x8 :=(
        "01111100",
        "01000010",
        "01000010",
        "01111100",
        "01000000",
        "01000000",
        "01000000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_Q : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000010",
        "01000010",
        "01001010",
        "01000100",
        "00111010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_R : pt_array8x8 :=(
        "01111100",
        "01000010",
        "01000010",
        "01111100",
        "01001000",
        "01000100",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_S : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000000",
        "00111100",
        "00000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_T : pt_array8x8 :=(
        "01111110",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_U : pt_array8x8 :=(
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_V : pt_array8x8 :=(
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "00100100",
        "00100100",
        "00011000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_W : pt_array8x8 :=(
        "01000010",
        "01000010",
        "01000010",
        "01000010",
        "01011010",
        "01100110",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_X : pt_array8x8 :=(
        "01000010",
        "00100100",
        "00011000",
        "00011000",
        "00100100",
        "01000010",
        "01000010",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_Y : pt_array8x8 :=(
        "01000010",
        "00100100",
        "00011000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_CAPITAL_Z : pt_array8x8 :=(
        "01111110",
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "01000000",
        "01111110",
        "00000000"
    );

    ----------------------------------------
    -- Bit-Map of SMALL LETTERS (a–z)
    ----------------------------------------
    constant pc_DRAW_SMALL_a : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111000",
        "00000100",
        "00111100",
        "01000100",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_SMALL_b : pt_array8x8 :=(
        "01000000",
        "01000000",
        "01111000",
        "01000100",
        "01000100",
        "01000100",
        "01111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_c : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111000",
        "01000100",
        "01000000",
        "01000100",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_d : pt_array8x8 :=(
        "00000100",
        "00000100",
        "00111100",
        "01000100",
        "01000100",
        "01000100",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_SMALL_e : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111000",
        "01000100",
        "01111100",
        "01000000",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_SMALL_f : pt_array8x8 :=(
        "00001100",
        "00010010",
        "00010000",
        "00111000",
        "00010000",
        "00010000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_SMALL_g : pt_array8x8 :=(
        "00000000",
        "00111100",
        "01000100",
        "01000100",
        "00111100",
        "00000100",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_h : pt_array8x8 :=(
        "01000000",
        "01000000",
        "01111000",
        "01000100",
        "01000100",
        "01000100",
        "01000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_i : pt_array8x8 :=(
        "00010000",
        "00000000",
        "00110000",
        "00010000",
        "00010000",
        "00010000",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_j : pt_array8x8 :=(
        "00001000",
        "00000000",
        "00011000",
        "00001000",
        "00001000",
        "00001000",
        "01001000",
        "00110000"
    );

    constant pc_DRAW_SMALL_k : pt_array8x8 :=(
        "01000000",
        "01000000",
        "01001000",
        "01010000",
        "01100000",
        "01010000",
        "01001000",
        "00000000"
    );

    constant pc_DRAW_SMALL_l : pt_array8x8 :=(
        "00110000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_m : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01101000",
        "01010100",
        "01010100",
        "01000100",
        "01000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_n : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01111000",
        "01000100",
        "01000100",
        "01000100",
        "01000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_o : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111000",
        "01000100",
        "01000100",
        "01000100",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_p : pt_array8x8 :=(
        "00000000",
        "01111000",
        "01000100",
        "01000100",
        "01111000",
        "01000000",
        "01000000",
        "00000000"
    );

    constant pc_DRAW_SMALL_q : pt_array8x8 :=(
        "00000000",
        "00111100",
        "01000100",
        "01000100",
        "00111100",
        "00000100",
        "00000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_r : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111000",
        "01000100",
        "01000000",
        "01000000",
        "01000000",
        "00000000"
    );

    constant pc_DRAW_SMALL_s : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00111100",
        "01000000",
        "00111000",
        "00000100",
        "01111000",
        "00000000"
    );

    constant pc_DRAW_SMALL_t : pt_array8x8 :=(
        "00010000",
        "00010000",
        "00111000",
        "00010000",
        "00010000",
        "00010000",
        "00001100",
        "00000000"
    );

    constant pc_DRAW_SMALL_u : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01000100",
        "01000100",
        "01000100",
        "01000100",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_SMALL_v : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01000100",
        "01000100",
        "01000100",
        "00101000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_SMALL_w : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01000100",
        "01000100",
        "01010100",
        "01101100",
        "01000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_x : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01000100",
        "00101000",
        "00010000",
        "00101000",
        "01000100",
        "00000000"
    );

    constant pc_DRAW_SMALL_y : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01000100",
        "01000100",
        "01000100",
        "00111100",
        "00000100",
        "00111000"
    );

    constant pc_DRAW_SMALL_z : pt_array8x8 :=(
        "00000000",
        "00000000",
        "01111100",
        "00001000",
        "00010000",
        "00100000",
        "01111100",
        "00000000"
    );

    -------------------------------------
    -- Bit-Map of DIGITS (0–9)
    -------------------------------------
    constant pc_DRAW_DIGIT_0 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000110",
        "01001010",
        "01010010",
        "01100010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_1 : pt_array8x8 :=(
        "00010000",
        "00110000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00111000",
        "00000000"
    );

    constant pc_DRAW_DIGIT_2 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "00000010",
        "00001100",
        "00010000",
        "00100000",
        "01111110",
        "00000000"
    );

    constant pc_DRAW_DIGIT_3 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "00000010",
        "00011100",
        "00000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_4 : pt_array8x8 :=(
        "00000100",
        "00001100",
        "00010100",
        "00100100",
        "01111110",
        "00000100",
        "00000100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_5 : pt_array8x8 :=(
        "01111110",
        "01000000",
        "01111100",
        "00000010",
        "00000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_6 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000000",
        "01111100",
        "01000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_7 : pt_array8x8 :=(
        "01111110",
        "00000010",
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "00100000",
        "00000000"
    );

    constant pc_DRAW_DIGIT_8 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000010",
        "00111100",
        "01000010",
        "01000010",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_DIGIT_9 : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01000010",
        "00111110",
        "00000010",
        "01000010",
        "00111100",
        "00000000"
    );

    ------------------------------------------------
    -- Bit-Map of SIGNS & PUNCTUATION
    ------------------------------------------------
    constant pc_DRAW_SPACE : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_EXCLAMATION : pt_array8x8 :=(
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00010000",
        "00000000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_QUESTION : pt_array8x8 :=(
        "00111100",
        "01000010",
        "00000010",
        "00001100",
        "00010000",
        "00000000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_PERIOD : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_COMMA : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00010000",
        "00010000",
        "00001000"
    );

    constant pc_DRAW_MINUS : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00111100",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_PLUS : pt_array8x8 :=(
        "00000000",
        "00010000",
        "00010000",
        "01111110",
        "00010000",
        "00010000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_ASTERISK : pt_array8x8 :=(
        "00000000",
        "00101000",
        "00010000",
        "01111110",
        "00010000",
        "00101000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_SLASH : pt_array8x8 :=(
        "00000010",
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "01000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_EQUAL  : pt_array8x8 :=(
        "00000000",
        "00111100",
        "00000000",
        "00111100",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_LEFT_PAREN : pt_array8x8 :=(
        "00001000",
        "00010000",
        "00100000",
        "00100000",
        "00100000",
        "00010000",
        "00001000",
        "00000000"
    );

    constant pc_DRAW_RIGHT_PAREN : pt_array8x8 :=(
        "00100000",
        "00010000",
        "00001000",
        "00001000",
        "00001000",
        "00010000",
        "00100000",
        "00000000"
    );

    constant pc_DRAW_LESS_THAN : pt_array8x8 :=(
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "00010000",
        "00001000",
        "00000100",
        "00000000"
    );

    constant pc_DRAW_GREATER_THAN : pt_array8x8 :=(
        "00100000",
        "00010000",
        "00001000",
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "00000000"
    );

    constant pc_DRAW_AT : pt_array8x8 :=(
        "00111100",
        "01000010",
        "01011010",
        "01011010",
        "01011110",
        "01000000",
        "00111100",
        "00000000"
    );

    constant pc_DRAW_HASH : pt_array8x8 :=(
        "00000000",
        "00010100",
        "00111110",
        "00010100",
        "00010100",
        "00111110",
        "00010100",
        "00000000"
    );

    constant pc_DRAW_DOLLAR : pt_array8x8 :=(
        "00010000",
        "00111100",
        "01010000",
        "00111000",
        "00010100",
        "00111100",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_PERCENT : pt_array8x8 :=(
        "01100010",
        "01100100",
        "00001000",
        "00010000",
        "00100000",
        "01001100",
        "01000110",
        "00000000"
    );

    constant pc_DRAW_AMPERSAND : pt_array8x8 :=(
        "00110000",
        "01001000",
        "01001000",
        "00110000",
        "01001010",
        "01000100",
        "00111010",
        "00000000"
    );

    constant pc_DRAW_APOSTROPHE : pt_array8x8 :=(
        "00010000",
        "00010000",
        "00010000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_QUOTE : pt_array8x8 :=(
        "00101000",
        "00101000",
        "00101000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    );

    constant pc_DRAW_COLON : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00010000",
        "00000000",
        "00010000",
        "00000000"
    );

    constant pc_DRAW_SEMICOLON : pt_array8x8 :=(
        "00000000",
        "00000000",
        "00000000",
        "00010000",
        "00000000",
        "00010000",
        "00010000",
        "00001000"
    );

    constant pc_DRAW_UNKNOWN : pt_array8x8 :=(
        "00000000",
        "01111110",
        "01100110",
        "01011010",
        "01011010",
        "01100110",
        "01111110",
        "00000000"
    );


end package;
