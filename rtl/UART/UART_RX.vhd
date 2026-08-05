library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This file contains the UART Receiver.  This receiver is able to
-- receive 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When receive is complete o_data_DV will be
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
        i_data_serial        :   in      STD_LOGIC;
        o_data_parallel      :   out     unsigned(g_BITS_LIMIT -1 downto 0);
        o_data_DV            :   out     STD_LOGIC
    );
end UART_RX;


architecture RTL of UART_RX is

    type t_state_machine is (IDLE, START_BIT, RECIEVE_DATA_BITS, STOP_BIT, CLEAN_UP);
    signal r_SM           : t_state_machine                       := IDLE;

    signal r_clk_counter  : integer range 0 to g_CLKS_PER_BIT-1   := 0;
    signal r_bit_counter  : integer range 0 to g_BITS_LIMIT-1     := 0;  -- 8 Bits Total
    signal r_RX_Byte      : unsigned(g_BITS_LIMIT-1 downto 0)     := (others => '0');
    signal r_RX_DV        : STD_LOGIC                             := '0';
  
    begin


    process (i_Clk)
        begin
            if rising_edge(i_Clk) then 
                case r_SM is

                    when IDLE =>
                        r_RX_DV     <= '0';
                        r_clk_counter <= 0;
                        r_bit_counter <= 0;

                        -------------------------------------------------------------
                        --Detect the start bit.
                        -------------------------------------------------------------
                        if i_data_serial = '0' then       
                            r_SM <= START_BIT;
                        else
                            r_SM <= IDLE;
                        end if;

                    -----------------------------------------------------------------------------------------------------
                    --Wait until the middle of the bit period and make sure it's still low then sample the recieved data.
                    ------------------------------------------------------------------------------------------------------
                    when START_BIT =>
                        if r_clk_counter = (g_CLKS_PER_BIT-1)/2 then
                            if i_data_serial = '0' then
                                r_clk_counter <= 0;  -- reset counter since we found the middle
                                r_SM   <= RECIEVE_DATA_BITS;
                            else
                                r_SM   <= IDLE;
                            end if;
                        else
                            r_clk_counter <= r_clk_counter + 1;
                            r_SM   <= START_BIT;
                        end if;

                    when RECIEVE_DATA_BITS =>
                        --------------------------------------------------------------------------------------------------
                        --since we are at the middle of bit period, we will wait for one bit period and sample the data
                        --------------------------------------------------------------------------------------------------
                        if r_clk_counter < g_CLKS_PER_BIT-1 then
                            r_clk_counter <= r_clk_counter + 1;
                            r_SM   <= RECIEVE_DATA_BITS;
                        else
                            r_clk_counter            <= 0;
                            r_RX_Byte(r_bit_counter) <= i_data_serial;
                            
                            -- Check if we have sent out all bits
                            if r_bit_counter < g_BITS_LIMIT-1 then
                                r_bit_counter <= r_bit_counter + 1;
                                r_SM   <= RECIEVE_DATA_BITS;
                            else
                                r_bit_counter <= 0;
                                r_SM   <= STOP_BIT;
                            end if;
                        end if;

                    when STOP_BIT =>
                        -----------------------------------------------------------------
                        -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                        -----------------------------------------------------------------
                        if r_clk_counter < g_CLKS_PER_BIT-1 then
                            r_clk_counter <= r_clk_counter + 1;
                            r_SM   <= STOP_BIT;
                        else
                            -------------------
                            -- r_DV goes high
                            -------------------
                            r_RX_DV     <= '1';
                            r_clk_counter <= 0;
                            r_SM   <= CLEAN_UP;
                        end if;

                    ---------------------------    
                    -- Stay here 1 clock
                    ---------------------------
                    when CLEAN_UP =>
                        r_SM <= IDLE;
                        r_RX_DV   <= '0';

                        
                    when others =>
                        r_SM <= IDLE;

                    end case;
                end if;
            end process;

        ------------------------------------------------------
        --The r_DV geos high when the byte is ready to read. 
        --And it becomes low after one clock cycle
        -------------------------------------------------------
        o_data_DV   <= r_RX_DV;
        o_data_parallel <= r_RX_Byte;
    
    end RTL;