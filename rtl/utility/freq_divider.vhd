library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_divider is
    generic (
        g_CLK_CYCLES_FOR_HALF_PERIOD  :     integer     :=3   --g_CLK_CYCLES_FOR_HALF_PERIOD = input frequency / (output frequency * 2)
    );
    port (
        i_clk   :   in      STD_LOGIC;
        o_clk   :   out     STD_LOGIC
    );
end freq_divider;

architecture RTL of freq_divider is 
    signal r_clk    :   STD_LOGIC   :='0';
    signal r_counter : integer range 0 to g_CLK_CYCLES_FOR_HALF_PERIOD -1 :=0;

    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    if r_counter < g_CLK_CYCLES_FOR_HALF_PERIOD -1 then
                        r_counter <= r_counter + 1;
                    else
                        r_counter <= 0;
                        r_clk <= not r_clk;
                    end if;
                end if;
            end process;
            o_clk <= r_clk;

    end RTL;