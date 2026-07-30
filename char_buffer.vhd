library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.font_pack.pc_ASCII_ENTER;
use work.font_pack.pc_ASCII_BACKSPACE;
use work.font_pack.pc_ASCII_CAPITAL_A;

entity char_buffer is
    generic (
        g_SCALE         :   integer     :=8;                        --Size of Each character
        g_LOG2_SCALE    :   integer     :=3;                        --log2(scale)
        g_COL_NUM       :   integer     :=80;                       --Maximum number of columns (640 /8)
        g_ROW_NUM       :   integer     :=60;                       --Maximum Number of Rows (480 / 8)
        g_RAM_SIZE      :   integer     :=4800;    					  --Size of RAM (4800)
        g_COL_BIT_WIDTH :   integer     :=7;                        --Minimum bit-width required to represent the columns (.e.g. 0 to 80)
        g_ROW_BIT_WIDTH :   integer     :=6;                        --minimum bit-width required to represent the rows (.e.g. 0 to 60)
        g_RAM_BIT_WIDTH :   integer     :=13                        --Minimum bit-width required to represent the address of RAM from 0 to 4800
    );
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_write_EN      :   in      STD_LOGIC;
        i_ASCII_code    :   in      unsigned(7 downto 0);
        i_read_EN       :   in      STD_LOGIC;
        i_x             :   in      unsigned(9 downto 0);
        i_y             :   in      unsigned(9 downto 0);
        o_ASCII_code    :   out     unsigned(7 downto 0);
        o_column        :   out     unsigned(g_COL_BIT_WIDTH-1 downto 0);
        o_row           :   out     unsigned(g_ROW_BIT_WIDTH-1 downto 0)
    );
end char_buffer;

architecture RTL of char_buffer is
    --RAM
    type RAM is array ( 0 to g_RAM_SIZE-1) of unsigned(7 downto 0);
    signal r_CHAR_RAM       :   RAM                                 :=(others=>pc_ASCII_BACKSPACE);

    --Signals
    signal r_column         :   integer range 0 to g_COL_NUM-1      :=0;
    signal r_row            :   integer range 0 to g_ROW_NUM-1      :=0;
    signal i                :   integer range 0 to g_RAM_SIZE-1     :=0;
    signal r_write_addr     :   integer range 0 to g_RAM_SIZE-1     :=0;
    signal r_read_addr      :   integer range 0 to g_RAM_SIZE-1     :=0;
    signal r_x_div_scale    :   integer range 0 to g_COL_NUM-1      :=0;
    signal r_y_div_scale    :   integer range 0 to g_ROW_NUM-1      :=0;

    begin
        dual_port_RAM: process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if i_reset = '1' then
                        r_column <= 0;
                        r_row <= 0;

                        if i < g_RAM_SIZE-1 then
                            r_CHAR_RAM(i) <= pc_ASCII_BACKSPACE;
                            i <= i + 1;
                            if i = g_RAM_SIZE-1 then
                                i <= 0;
                            end if;
                        end if;

                    else
                        --If an ASCII code has recieved, write it into the RAM
                        if i_write_EN = '1' then
                            r_CHAR_RAM(r_write_addr) <= i_ASCII_code;
                            -- Check out to see what that ASCII code is.
                            if i_ASCII_code = pc_ASCII_BACKSPACE then
                                if r_column > 0 then
                                    r_column <= r_column -1;
                                    r_row <= r_row;
                                else
                                    if r_row > 0 then
                                        r_row <= r_row - 1;
                                        r_column <= g_COL_NUM -1;
                                    end if;
                                end if;

                            elsif i_ASCII_code = pc_ASCII_ENTER then
                                if r_row < g_ROW_NUM -1 then
                                    r_column <= 0;
                                    r_row <= r_row + 1;
                                end if;

                            else  --Normal character
                                if r_column < g_COL_NUM -1 then
                                    r_column <= r_column + 1;
                                    r_row <= r_row;
                                else
                                    if r_row < g_ROW_NUM -1 then
                                        r_column <= 0;
                                        r_row <= r_row + 1;
                                    end if;
                                end if;

                            end if; 
                        end if;

                        --Reading from the RAM, whn i_read_en is high
                        if i_read_en = '1' then
                            o_ASCII_code <= r_CHAR_RAM(r_read_addr);
                        end if;

                    end if;

                end if;
            end process;

        -----------------------------------------------------------------------
        -- Computing the address of RAM based on column number and Row number (write address)
        -----------------------------------------------------------------------
        -- (Column, Row)    | Address
        -- (0, 0)           | 0
        -- (1, 0)           | 1
        -- (2, 0)           | 2
        --  . . .           | . 
        -- (0, 1)           | 80
        -- (1, 1)           | 81
        -- (2, 1)           | 82
        --  . . .           | . 
        -- (79,59)          | 4799
        r_write_addr <= r_column + (r_row * g_COL_NUM);


        -----------------------------------------------------------------------
        -- Computing the address of RAM based on X/Y cordinates (read address)
        -----------------------------------------------------------------------
        -- (X, Y)           | Address
        -- (0, 0)           | 0
        -- (1, 0)           | 1
        -- (2, 0)           | 2
        --  . . .           | . 
        -- (0, 1)           | 80
        -- (1, 1)           | 81
        -- (2, 1)           | 82
        --  . . .           | . 
        -- (79,59)          | 4799
        r_x_div_scale <= to_integer(i_x(i_x'left downto g_LOG2_SCALE));   -- i_x / SCALE
        r_y_div_scale <= to_integer(i_y(i_y'left downto g_LOG2_SCALE));   -- i_y / SCALE
        r_read_addr <= r_x_div_scale + (r_y_div_scale  * g_COL_NUM);

        o_column <= to_unsigned(r_column, o_column'length);
        o_row <= to_unsigned(r_row, o_row'length);
    end RTL;