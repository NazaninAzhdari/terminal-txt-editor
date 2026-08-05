library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.font_pack.ALL;

entity draw_start_frame is
    port (
        i_clk               :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_x                 :   in      unsigned(9 downto 0);
        i_y                 :   in      unsigned(9 downto 0);
        o_draw_start_frame  :   out     STD_LOGIC
    );
end draw_start_frame;

architecture RTL of draw_start_frame is
    signal r_x_div_2    :   integer range 0 to 319  :=0;
    signal r_y_div_2    :   integer range 0 to 239  :=0;
    signal r_x_div_16   :   integer range 0 to 39   :=0;
    signal r_y_div_16   :   integer range 0 to 29   :=0;

    begin
        r_x_div_2 <= to_integer(i_x(9 downto 1));
        r_y_div_2 <= to_integer(i_y(9 downto 1));
        r_x_div_16 <= to_integer(i_x(9 downto 4));
        r_y_div_16 <= to_integer(i_y(9 downto 4));

        process(i_clk, i_reset) is
			begin
            if i_reset = '1' then
                o_draw_start_frame <= '0';

            elsif rising_edge(i_clk) then
                -----------------------------------------------------------------------------
                -- Display "NAZ TEXT EDITOR" in the Row of 16 (out of 30 Row => 480/16 = 30)
                -----------------------------------------------------------------------------
                if r_y_div_16 = 12 then
                    case r_x_div_16 is
                        when  11 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_N(r_y_div_2 - 96)(r_x_div_2 - 88); --96 = 12*16/2 and 104 = 11*16/2
                        when  12 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_A(r_y_div_2 - 96)(r_x_div_2 - 96);
                        when  13 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_Z(r_y_div_2 - 96)(r_x_div_2 - 104); 
                        when  14 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 96)(r_x_div_2 - 112);
                        when  15 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 96)(r_x_div_2- 120);
                        when  16 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 96)(r_x_div_2- 128);
                        when  17 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_X(r_y_div_2 - 96)(r_x_div_2- 136);
                        when  18 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 96)(r_x_div_2- 144);
                        when  19 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 96)(r_x_div_2- 152);
                        when  20 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 96)(r_x_div_2- 160);
                        when  21 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_D(r_y_div_2 - 96)(r_x_div_2- 168);
                        when  22 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_I(r_y_div_2 - 96)(r_x_div_2- 176);
                        when  23 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 96)(r_x_div_2- 184);
                        when  24 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_O(r_y_div_2 - 96)(r_x_div_2- 192);
                        when  25 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_R(r_y_div_2 - 96)(r_x_div_2- 200);
                        when others => 
                            o_draw_start_frame <= '0';
                    end case;

                -----------------------------------------------------------------------------
                -- Display "KEY(0) = OPEN EDITOR" in the Row of 18 (out of 30 Row => 480/16 = 30)
                -----------------------------------------------------------------------------
                elsif r_y_div_16 = 18 then
                    case r_x_div_16 is
                        when  9 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_K(r_y_div_2 - 144)(r_x_div_2- 72); --144 = 18*16/2 and 72 = 9*16/2
                        when  10 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 144)(r_x_div_2- 80);
                        when  11 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_Y(r_y_div_2 - 144)(r_x_div_2- 88);
                        when  12 =>
                            o_draw_start_frame <= pc_DRAW_LEFT_PAREN(r_y_div_2 - 144)(r_x_div_2- 96);
                        when  13 =>
                            o_draw_start_frame <= pc_DRAW_DIGIT_0(r_y_div_2 - 144)(r_x_div_2- 104);
                        when  14 =>
                            o_draw_start_frame <= pc_DRAW_RIGHT_PAREN(r_y_div_2 - 144)(r_x_div_2- 112);
                        when  15 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 144)(r_x_div_2- 120);
                        when  16 =>
                            o_draw_start_frame <= pc_DRAW_EQUAL(r_y_div_2 - 144)(r_x_div_2- 128);
                        when  17 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 144)(r_x_div_2- 136);
                        when  18 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_O(r_y_div_2 - 144)(r_x_div_2- 144);
                        when  19 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_P(r_y_div_2 - 144)(r_x_div_2- 152);
                        when  20 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 144)(r_x_div_2- 160);
                        when  21 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_N(r_y_div_2 - 144)(r_x_div_2- 168);
                        when  22 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 144)(r_x_div_2- 176);
                        when  23 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 144)(r_x_div_2- 184);
                        when  24 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_D(r_y_div_2 - 144)(r_x_div_2- 192);
                        when  25 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_I(r_y_div_2 - 144)(r_x_div_2- 200);
                        when  26 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 144)(r_x_div_2- 208);
                        when  27 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_O(r_y_div_2 - 144)(r_x_div_2- 216);
                        when  28 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_R(r_y_div_2 - 144)(r_x_div_2- 224);
                        when others => 
                            o_draw_start_frame <= '0';
                    end case;

                -----------------------------------------------------------------------------
                -- Display "KEY(1) = TRANSMIT TEXT" in the Row of 20 (out of 30 Row => 480/16 = 30)
                -----------------------------------------------------------------------------
                elsif r_y_div_16 = 20 then
                    case r_x_div_16 is
                        when  8 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_K(r_y_div_2 - 160)(r_x_div_2- 64);  -- 160 = 20*16/2 and 64 = 8*16/2
                        when  9 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 160)(r_x_div_2- 72);
                        when  10 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_Y(r_y_div_2 - 160)(r_x_div_2- 80);
                        when  11 =>
                            o_draw_start_frame <= pc_DRAW_LEFT_PAREN(r_y_div_2 - 160)(r_x_div_2- 88);
                        when  12 =>
                            o_draw_start_frame <= pc_DRAW_DIGIT_1(r_y_div_2 - 160)(r_x_div_2- 96);
                        when  13 =>
                            o_draw_start_frame <= pc_DRAW_RIGHT_PAREN(r_y_div_2 - 160)(r_x_div_2- 104);
                        when  14 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 160)(r_x_div_2- 112);
                        when  15 =>
                            o_draw_start_frame <= pc_DRAW_EQUAL(r_y_div_2 - 160)(r_x_div_2- 120);
                        when  16 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 160)(r_x_div_2- 128);
                        when  17 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 160)(r_x_div_2- 136);
                        when  18 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_R(r_y_div_2 - 160)(r_x_div_2- 144);
                        when  19 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_A(r_y_div_2 - 160)(r_x_div_2- 152);
                        when  20 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_N(r_y_div_2 - 160)(r_x_div_2- 160);
                        when  21 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_S(r_y_div_2 - 160)(r_x_div_2- 168);
                        when  22 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_M(r_y_div_2 - 160)(r_x_div_2- 176);
                        when  23 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_I(r_y_div_2 - 160)(r_x_div_2- 184);
                        when  24 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 160)(r_x_div_2- 192);
                        when  25 =>
                            o_draw_start_frame <= pc_DRAW_SPACE(r_y_div_2 - 160)(r_x_div_2- 200);
                        when  26 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 160)(r_x_div_2- 208);
                        when  27 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_E(r_y_div_2 - 160)(r_x_div_2- 216);
                        when  28 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_X(r_y_div_2 - 160)(r_x_div_2- 224);
                        when  29 =>
                            o_draw_start_frame <= pc_DRAW_CAPITAL_T(r_y_div_2 - 160)(r_x_div_2- 232);
                        when others => 
                            o_draw_start_frame <= '0';
                    end case;
                else
                    o_draw_start_frame <= '0';
                end if;
            end if;
        end process;


    end RTL;

    