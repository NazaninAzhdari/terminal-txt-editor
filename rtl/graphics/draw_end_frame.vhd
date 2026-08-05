library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.font_pack.ALL;

entity draw_end_frame is
    port (
        i_clk               :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_x                 :   in      unsigned(9 downto 0);
        i_y                 :   in      unsigned(9 downto 0);
        o_draw_end_frame     :   out     STD_LOGIC
    );
end draw_end_frame;

architecture RTL of draw_end_frame is
    signal r_x_div_4    :   integer range 0 to 159  :=0;
    signal r_y_div_4    :   integer range 0 to 119  :=0;
    signal r_x_div_32   :   integer range 0 to 19   :=0;
    signal r_y_div_32   :   integer range 0 to 14   :=0;

    begin
        r_x_div_4 <= to_integer(i_x(9 downto 2));
        r_y_div_4 <= to_integer(i_y(9 downto 2));
        r_x_div_32 <= to_integer(i_x(9 downto 5));
        r_y_div_32 <= to_integer(i_y(9 downto 5));

        process(i_clk, i_reset) is
			begin
            if i_reset = '1' then
                o_draw_end_frame <= '0';

            elsif rising_edge(i_clk) then
                -----------------------------------------------------------------------------
                -- Display "Done!" in the Row of 6 (out of 15 Row => 480/32 = 15)
                -----------------------------------------------------------------------------
                if r_y_div_32 = 6 then
                    case r_x_div_32 is
                        when 8 =>
                            o_draw_end_frame <= pc_DRAW_CAPITAL_D(r_y_div_4 - 48)(r_x_div_4- 64);
                        when 9 =>
                            o_draw_end_frame <= pc_DRAW_SMALL_o(r_y_div_4 - 48)(r_x_div_4- 72);
                        when 10 =>
                            o_draw_end_frame <= pc_DRAW_SMALL_n(r_y_div_4 - 48)(r_x_div_4- 80);
                        when 11 =>
                            o_draw_end_frame <= pc_DRAW_SMALL_e(r_y_div_4 - 48)(r_x_div_4- 88);
                        when 12 =>
                            o_draw_end_frame <= pc_DRAW_EXCLAMATION(r_y_div_4 - 48)(r_x_div_4- 96);
                        when others => 
                            o_draw_end_frame <= '0';
                    end case;

                else
                    o_draw_end_frame <= '0';
                end if;
            end if;
        end process;


    end RTL;

    