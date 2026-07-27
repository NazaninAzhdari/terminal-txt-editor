library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity char_buffer is
    generic (
        g_COL_NUM       :   integer     :=40;                       --Maximum number of columns
        g_ROW_NUM       :   integer     :=30;                       --Maximum Number of Rows
        g_RAM_SIZE      :   integer     :=g_COL_NUM * g_ROW_NUM;    --Size of RAM (1200)
        g_COL_BIT_WIDTH :   integer     :=6;                        --Minimum bit-width required to represent the columns (.e.g. 0 to 40)
        g_ROW_BIT_WIDTH :   integer     :=5;                        --minimum bit-width required to represent the rows (.e.g. 0 to 30)
        g_RAM_BIT_WIDTH :   integer     :=11                        --Minimum bit-width required to represent the address of RAM from 0 to 1200
    );
    port (
        i_clk           :   in      STD_LOGIC;
        i_reset         :   in      STD_LOGIC;
        i_write_EN      :   in      STD_LOGIC;
        i_ASCII_code    :   in      unsigned(7 downto 0);
        i_read_EN       :   in      STD_LOGIC;
        i_read_addr     :   in      unsigned(g_RAM_BIT_WIDTH-1 downto 0);  --address from 0 to 1200
        o_ASCII_code    :   out     unsigned(7 downto 0);
        o_column        :   out     unsigned(g_COL_BIT_WIDTH-1 downto 0);
        o_row           :   out     unsigned(g_ROW_BIT_WIDTH-1 downto 0)
    );
end char_buffer;

architecture RTL of char_buffer is
    constant c_DELETE_CODE  :   unsigned(7 downto 0)                :=
    constant c_ENTER_CODE   :   unsigned(7 downto 0)                :=

    type RAM is array ( 0 to g_RAM_SIZE-1) of unsigned(7 downto 0);
    signal r_CHAR_RAM       :   RAM                                 :=(others=>c_DELETE_CODE);

    signal r_column         :   integer range 0 to g_COL_NUM-1      :=0;
    signal r_row            :   integer range 0 to g_ROW_NUM-1      :=0;
    signal i                :   integer range 0 to g_RAM_SIZE-1     :=0;
    signal r_write_addr     :   integer range 0 to g_RAM_SIZE-1     :=0;
    signal r_read_addr      :   integer range 0 to g_RAM_SIZE-1     :=0;

    begin
        
        character_buffer: process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if i_reset = '1' then
                        r_column <= 0;
                        r_row <= 0;

                        if i < g_RAM_SIZE-1 then
                            r_CHAR_RAM(i) <= c_DELETE_CODE;
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
                            if i_ASCII_code = c_DELETE_CODE then
                                if r_column > 0 then
                                    r_column <= r_column -1;
                                    r_row <= r_row;
                                else
                                    if r_row > 0 then
                                        r_row <= r_row - 1;
                                        r_column <= g_COL_NUM -1;
                                    end if;
                                end if;

                            elsif i_ASCII_code = c_ENTER_CODE then
                                if r_row < g_ROW_NUM -1 then
                                    r_column <= 0
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
        -- Computing the address of RAM based on column number and Row number
        -----------------------------------------------------------------------
        -- (Column, Row)    | Address
        -- (0, 0)           | 0
        -- (1, 0)           | 1
        -- (2, 0)           | 2
        --  . . .           | . 
        -- (0, 1)           | 40
        -- (1, 1)           | 41
        -- (2, 1)           | 42
        --  . . .           | . 
        -- (39,29)          | 1199
        r_write_addr <= r_col + (r_row * g_COL_NUM);

        ---------------------------------------
        -- Convert read-adrress to integer
        ---------------------------------------
        r_read_addr <= to_integer(i_red_addr);

        o_column <= to_unsigned(r_column, o_column'length);
        o_row <= to_unsigned(r_row, o_row'length);
    end RTL;