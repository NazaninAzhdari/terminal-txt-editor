library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.font_pack.ALL;

entity draw_characters is
    generic (
        g_SCALE         :   integer     :=8;    --Size of Each character
        g_LOG2_SCALE    :   integer     :=3;     --log2(scale)
        g_SCREEN_WIDTH  :   integer     :=640;
        g_SCREEN_HEIGHT :   integer     :=480
    );
    port (
        i_clk           :   in  STD_LOGIC;
        i_reset         :   in  STD_LOGIC;
        i_x             :   in  unsigned(9 downto 0);
        i_y             :   in  unsigned(9 downto 0);
        i_ASCII_code    :   in  unsigned(7 downto 0);
        o_draw          :   in  STD_LOGIC
    );
end draw_characters;

architecture RTL of draw_characters is
    constant c_ZERO_MASK    :   unsigned(9 downto 0)                        :=to_unsigned(0, g_LOG2_SCALE);
    signal r_x              :   integer range 0 to g_SCREEN_WIDTH-1         :=0;
    signal r_y              :   integer range 0 to g_SCREEN_HEIGHT-1        :=0;
    signal r_x_start_char   :   integer range 0 to g_SCREEN_WIDTH-1         :=0;
    signal r_y_start_char   :   integer range 0 to g_SCREEN_HEIGHT-1        :=0;

    begin
        r_x <= to_integer(i_x);
        r_y <= to_integer(i_y);

        -- The scale is 8. meaning that size of each letter is 8.
        -- to draw a letter:  o_draw <= pc_LETTER(r_y - (r_y_div_8 * 8))(r_x - (r_x_div_8 * 8))
        -- r_x_start_char = (r_x_div_8 * 8)
        -- r_y_start_char = (r_y_div_8 * 8)
        r_x_start_char <= to_integer((i_x(i_x'left downto g_LOG2_SCALE) & c_ZERO_MASK));   -- (i_x / SCALE) * SCALE
        r_y_start_char <= to_integer((i_y(i_y'left downto g_LOG2_SCALE) & c_ZERO_MASK));   -- (i_y / SCALE) * SCALE

        process(i_clk, i_reset) is
            begin
                if i_reset = '1' then
                    o_draw <= '0';

                elsif rising_edge(i_clk) then
                    case i_ascii_code is
                        -- Draw uppercase leters
                        when pc_ASCII_CAPITAL_A => o_draw <= pc_DRAW_CAPITAL_A(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_B => o_draw <= pc_DRAW_CAPITAL_B(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_C => o_draw <= pc_DRAW_CAPITAL_C(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_D => o_draw <= pc_DRAW_CAPITAL_D(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_E => o_draw <= pc_DRAW_CAPITAL_E(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_F => o_draw <= pc_DRAW_CAPITAL_F(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_G => o_draw <= pc_DRAW_CAPITAL_G(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_H => o_draw <= pc_DRAW_CAPITAL_H(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_I => o_draw <= pc_DRAW_CAPITAL_I(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_J => o_draw <= pc_DRAW_CAPITAL_J(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_K => o_draw <= pc_DRAW_CAPITAL_K(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_L => o_draw <= pc_DRAW_CAPITAL_L(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_M => o_draw <= pc_DRAW_CAPITAL_M(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_N => o_draw <= pc_DRAW_CAPITAL_N(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_O => o_draw <= pc_DRAW_CAPITAL_O(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_P => o_draw <= pc_DRAW_CAPITAL_P(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_Q => o_draw <= pc_DRAW_CAPITAL_Q(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_R => o_draw <= pc_DRAW_CAPITAL_R(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_S => o_draw <= pc_DRAW_CAPITAL_S(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_T => o_draw <= pc_DRAW_CAPITAL_T(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_U => o_draw <= pc_DRAW_CAPITAL_U(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_V => o_draw <= pc_DRAW_CAPITAL_V(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_W => o_draw <= pc_DRAW_CAPITAL_W(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_X => o_draw <= pc_DRAW_CAPITAL_X(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_Y => o_draw <= pc_DRAW_CAPITAL_Y(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_CAPITAL_Z => o_draw <= pc_DRAW_CAPITAL_Z(r_y - r_y_start_char)(r_x - r_x_start_char);
                        --Draw lowercase letters
                        when pc_ASCII_SMALL_A => o_draw <= pc_DRAW_SMALL_A(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_B => o_draw <= pc_DRAW_SMALL_B(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_C => o_draw <= pc_DRAW_SMALL_C(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_D => o_draw <= pc_DRAW_SMALL_D(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_E => o_draw <= pc_DRAW_SMALL_E(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_F => o_draw <= pc_DRAW_SMALL_F(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_G => o_draw <= pc_DRAW_SMALL_G(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_H => o_draw <= pc_DRAW_SMALL_H(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_I => o_draw <= pc_DRAW_SMALL_I(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_J => o_draw <= pc_DRAW_SMALL_J(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_K => o_draw <= pc_DRAW_SMALL_K(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_L => o_draw <= pc_DRAW_SMALL_L(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_M => o_draw <= pc_DRAW_SMALL_M(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_N => o_draw <= pc_DRAW_SMALL_N(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_O => o_draw <= pc_DRAW_SMALL_O(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_P => o_draw <= pc_DRAW_SMALL_P(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_Q => o_draw <= pc_DRAW_SMALL_Q(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_R => o_draw <= pc_DRAW_SMALL_R(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_S => o_draw <= pc_DRAW_SMALL_S(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_T => o_draw <= pc_DRAW_SMALL_T(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_U => o_draw <= pc_DRAW_SMALL_U(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_V => o_draw <= pc_DRAW_SMALL_V(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_W => o_draw <= pc_DRAW_SMALL_W(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_X => o_draw <= pc_DRAW_SMALL_X(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_Y => o_draw <= pc_DRAW_SMALL_Y(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_SMALL_Z => o_draw <= pc_DRAW_SMALL_Z(r_y - r_y_start_char)(r_x - r_x_start_char);
                        --Draw digits
                        when pc_ASCII_DIGIT_0 => o_draw <= pc_DRAW_DIGIT_0(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_1 => o_draw <= pc_DRAW_DIGIT_1(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_2 => o_draw <= pc_DRAW_DIGIT_2(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_3 => o_draw <= pc_DRAW_DIGIT_3(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_4 => o_draw <= pc_DRAW_DIGIT_4(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_5 => o_draw <= pc_DRAW_DIGIT_5(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_6 => o_draw <= pc_DRAW_DIGIT_6(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_7 => o_draw <= pc_DRAW_DIGIT_7(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_8 => o_draw <= pc_DRAW_DIGIT_8(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_DIGIT_9 => o_draw <= pc_DRAW_DIGIT_9(r_y - r_y_start_char)(r_x - r_x_start_char);
                        --Draw signs and punctuations
                        when pc_ASCII_EXCLAMATION => o_draw <= pc_DRAW_EXCLAMATION(r_y - r_y_start_char)(r_x - r_x_start_char); --!
                        when pc_ASCII_QUOTE => o_draw <= pc_DRAW_QUOTE(r_y - r_y_start_char)(r_x - r_x_start_char); -- "
                        when pc_ASCII_HASH => o_draw <= pc_DRAW_HASH(r_y - r_y_start_char)(r_x - r_x_start_char); -- #
                        when pc_ASCII_DOLLAR => o_draw <= pc_DRAW_DOLLAR(r_y - r_y_start_char)(r_x - r_x_start_char); -- $
                        when pc_ASCII_PERCENT => o_draw <= pc_DRAW_PERCENT(r_y - r_y_start_char)(r_x - r_x_start_char); -- %
                        when pc_ASCII_AMPERSAND => o_draw <= pc_DRAW_AMPERSAND(r_y - r_y_start_char)(r_x - r_x_start_char); -- &
                        when pc_ASCII_APOSTROPHE => o_draw <= pc_DRAW_APOSTROPHE(r_y - r_y_start_char)(r_x - r_x_start_char); -- '
                        when pc_ASCII_LEFT_PAREN => o_draw <= pc_DRAW_LEFT_PAREN(r_y - r_y_start_char)(r_x - r_x_start_char); -- (
                        when pc_ASCII_RIGHT_PAREN => o_draw <= pc_DRAW_RIGHT_PAREN(r_y - r_y_start_char)(r_x - r_x_start_char); -- )
                        when pc_ASCII_ASTERISK => o_draw <= pc_DRAW_ASTERISK(r_y - r_y_start_char)(r_x - r_x_start_char); -- *
                        when pc_ASCII_PLUS => o_draw <= pc_DRAW_PLUS(r_y - r_y_start_char)(r_x - r_x_start_char); -- +
                        when pc_ASCII_COMMA => o_draw <= pc_DRAW_COMMA(r_y - r_y_start_char)(r_x - r_x_start_char); -- ,
                        when pc_ASCII_MINUS => o_draw <= pc_DRAW_MINUS(r_y - r_y_start_char)(r_x - r_x_start_char); -- -
                        when pc_ASCII_PERIOD => o_draw <= pc_DRAW_PERIOD(r_y - r_y_start_char)(r_x - r_x_start_char); -- .
                        when pc_ASCII_SLASH => o_draw <= pc_DRAW_SLASH(r_y - r_y_start_char)(r_x - r_x_start_char); -- /
                        when pc_ASCII_COLON => o_draw <= pc_DRAW_COLON(r_y - r_y_start_char)(r_x - r_x_start_char); -- :
                        when pc_ASCII_SEMICOLON => o_draw <= pc_DRAW_SEMICOLON(r_y - r_y_start_char)(r_x - r_x_start_char); -- ;
                        when pc_ASCII_LESS_THAN => o_draw <= pc_DRAW_LESS_THAN(r_y - r_y_start_char)(r_x - r_x_start_char); -- <
                        when pc_ASCII_EQUAL => o_draw <= pc_DRAW_EQUAL(r_y - r_y_start_char)(r_x - r_x_start_char); -- =
                        when pc_ASCII_GREATER_THAN => o_draw <= pc_DRAW_GREATER_THAN(r_y - r_y_start_char)(r_x - r_x_start_char); -- >
                        when pc_ASCII_QUESTION => o_draw <= pc_DRAW_QUESTION(r_y - r_y_start_char)(r_x - r_x_start_char); -- ?
                        when pc_ASCII_AT  => o_draw <= pc_DRAW_AT(r_y - r_y_start_char)(r_x - r_x_start_char); -- @
                        -- Control lines
                        when pc_ASCII_BACKSPACE => o_draw <= pc_DRAW_SPACE(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when pc_ASCII_ENTER => o_draw <= pc_DRAW_SPACE(r_y - r_y_start_char)(r_x - r_x_start_char);
                        when others => o_draw <= pc_DRAW_UNKNOWN(r_y - r_y_start_char)(r_x - r_x_start_char);
                    end case;
                end if;
            end process;

    end RTL;