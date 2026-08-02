library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity draw_cursor is
    generic (
        g_LOG2_SCALE    :   integer     :=3;             --log2(scale)
        g_COL_NUM       :   integer     :=80;            --Maximum number of columns (640 /8)
        g_ROW_NUM       :   integer     :=60;            --Maximum Number of Rows (480 / 8)
        g_COL_BIT_WIDTH :   integer     :=7;             --Minimum bit-width required to represent the columns (.e.g. 0 to 80)
        g_ROW_BIT_WIDTH :   integer     :=6;             --minimum bit-width required to represent the rows (.e.g. 0 to 60)
        g_BLINK_LIMIT   :   integer     :=25000
    );
    port (
        i_clk           :   in 	STD_LOGIC;
        i_reset         :   in 	STD_LOGIC;
        i_column        :   in 	unsigned(g_COL_BIT_WIDTH-1 downto 0);
        i_row           :   in 	unsigned(g_ROW_BIT_WIDTH-1 downto 0);
        i_x             :   in 	unsigned(9 downto 0);
        i_y             :   in 	unsigned(9 downto 0);
        o_draw_cursor   :   out 	STD_LOGIC
    );
end draw_cursor;

architecture RTL of draw_cursor is
    signal r_x_div_scale    :   integer range 0 to g_COL_NUM-1      :=0;
    signal r_y_div_scale    :   integer range 0 to g_ROW_NUM-1      :=0;
    signal r_column         :   integer range 0 to g_COL_NUM-1      :=0;
    signal r_row            :   integer range 0 to g_ROW_NUM-1      :=0;
    signal r_cursor         :   STD_LOGIC                           :='0';
    signal r_blink          :   STD_LOGIC                           :='0';
    signal r_counter        :   integer range 0 to g_BLINK_LIMIT-1  :=0;

    begin
        r_column <= to_integer(i_column);
        r_row <= to_integer(i_row);
        r_x_div_scale <= to_integer(i_x(i_x'left downto g_LOG2_SCALE));   -- i_x / SCALE
        r_y_div_scale <= to_integer(i_y(i_y'left downto g_LOG2_SCALE));   -- i_y / SCALE

        process(i_clk, i_reset) is
            begin
                if i_reset = '1' then
                    r_cursor <= '0';

                elsif rising_edge(i_clk) then
                    --Draw the cursor based on the cloumn and row position
                    if ( r_x_div_scale = r_column) and (r_y_div_scale = r_row ) then
                        r_cursor <= '1';
                    else
                        r_cursor <= '0';
                    end if;

                    --Blinking Cursor
                    if r_counter < g_BLINK_LIMIT-1 then
                        r_counter <= r_counter + 1;
                    else
                        r_counter <= 0;
                        r_blink <= not r_blink;
                    end if;

                end if;
            end process;

            o_draw_cursor <= r_blink when r_cursor = '1' else '0';

    end RTL;