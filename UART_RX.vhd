library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This file contains the UART Receiver.  This receiver is able to
-- receive 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When receive is complete o_rx_dv will be
-- driven high for one clock cycle.
-- 
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217

entity UART_RX is
    generic (
        g_BITS_LIMIT        :   integer range 7 to 8    :=8;      --can be set to 7 or 8
        g_CLKS_PER_BIT      :   integer                 :=434     --can be determined based on the CLK and Baud rate. =>  CLK / Baud rate
    );
    port (
        i_clk                :   in      STD_LOGIC;
        i_reset              :   in      STD_LOGIC;
        i_data_serial        :   in      STD_LOGIC;
        o_data_parallel      :   out     unsigned(g_BITS_LIMIT -1 downto 0);
        o_data_DV            :   out     STD_LOGIC
    );
end UART_RX;

architecture RTL of UART_RX is
    
    type t_UART_SM is (IDLE, START_BIT, RECIEVE_BITS, STOP_BIT);
    signal   r_SM                 :  t_UART_SM      :=IDLE;
    constant c_HALF_CLKS_PER_BIT  :  integer        :=(g_CLKS_PER_BIT / 2);

    signal r_clk_counter     :  integer range 0 to g_CLKS_PER_BIT     :=0;
    signal r_bit_counter     :  integer range 0 to g_BITS_LIMIT       :=0;
    signal r_data_serial     :  STD_LOGIC                             :='0';
    signal r_shift           :  unsigned(g_BITS_LIMIT -1 downto 0)    :=(others=>'0');
	signal r_DV              :  STD_LOGIC                             :='0';
    
    begin
        process(i_clk, i_reset) is
            begin
                if i_reset = '1' then
                    r_SM <= IDLE;
                    r_clk_counter <= 0;
                    r_bit_counter <= 0;
                    r_data_serial <= '0';
                    r_shift <= (others=>'0');
                    r_DV <= '0';

                elsif rising_edge(i_clk) then
                    r_data_serial <= i_data_serial;

                    case r_SM is 
                        when IDLE =>
                            r_clk_counter <= 0;
                            r_bit_counter <= 0;

                            -------------------------------------------------------------
                            --Detect the falling edge of the start bit.
                            -------------------------------------------------------------
                            if i_data_serial = '0' and r_data_serial = '1' then
								r_DV <= '0';
                                r_SM <= START_BIT;
                            end if;

                        when START_BIT =>
                            ------------------------------------------------------------------------
                            --Wait until the middle of the bit period and sample the recieved data.
                            ------------------------------------------------------------------------
                            if r_clk_counter < c_HALF_CLKS_PER_BIT then
                                r_clk_counter <= r_clk_counter + 1;
                            else
                                r_clk_counter <= 0;
                                if i_data_serial = '0' then --Check if the Start bit is still zero or not, if not come back to idle
                                    r_SM <= RECIEVE_BITS;
                                else
                                    r_SM <= IDLE;
                                end if;
                            end if;

                        when RECIEVE_BITS =>
                            --------------------------------------------------------------------------------------------------
                            --since we are at the middle of bit period, we will wait for one bit period and sample the data
                            --------------------------------------------------------------------------------------------------
                            if r_clk_counter < g_CLKS_PER_BIT then
                                r_clk_counter <= r_clk_counter + 1;
                            else
                                r_clk_counter <= 0;
                                if r_bit_counter < g_BITS_LIMIT then
                                    r_shift <= i_data_serial & r_shift(g_BITS_LIMIT -1 downto 1);
                                    r_bit_counter <= r_bit_counter + 1;
                                else
                                    r_bit_counter <= 0;
                                    r_SM <= STOP_BIT;
                                end if;
                            end if;

                        when STOP_BIT =>
                            -------------------------------------------------
                            --check the stop bit, if its 1, then r_DV goes high
                            --------------------------------------------------
                            if i_data_serial = '1' then
                                r_SM <= IDLE;
                                r_DV <= '1';
                            else
                                r_SM <= IDLE;
                            end if;

                        when others =>
                            r_SM <= IDLE;

                        end case;
                    end if;
            end process;
            
            ---------------------------------------------------------------------------------------------------
            --The r_DV geos high when the byte is ready to read. 
            --And it becomes low when the start bit of new data is recieved.(by falling edge of the start bit)
            ----------------------------------------------------------------------------------------------------
            o_data_DV <= r_DV;
            o_data_parallel <= r_shift;

    end RTL;