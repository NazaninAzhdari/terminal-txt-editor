library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This file contains the UART Transceiver.  This transceiver is able to
-- send 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When sending is complete r_tx_done will be
-- driven high for one clock cycle.
-- 
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217

entity UART_TX is
    generic (
        g_BITS_LIMIT        :   integer range 7 to 8    :=8;      --can be set to 7 or 8
        g_CLKS_PER_BIT      :   integer                 :=434     --can be determined based on the CLK and Baud rate. =>  CLK / Baud rate
    );
    port (
        i_clk           :       in      STD_LOGIC;
        i_en            :       in      STD_LOGIC;
        i_data_byte     :       in      unsigned(g_BITS_LIMIT-1 downto 0);
        o_data_serial   :       out     STD_LOGIC;
        o_TX_active     :       out     STD_LOGIC;
        o_TX_Done       :       out     STD_LOGIC
    );          
end UART_TX;

architecture RTL of UART_TX is
    type TX is (IDLE, SEND_START_BIT, SEND_DATA_BITS, SEND_STOP_BIT);
    signal r_tx             :       TX                                  :=IDLE;
    signal r_shift          :       unsigned(g_BITS_LIMIT-1 downto 0)   :=(others=>'0');
    signal r_data_serial    :       STD_LOGIC                           :='0';
    signal r_bit_counter    :       integer range 0 to 8                :=0;
    signal r_clk_counter    :       integer range 0 to g_CLKS_PER_BIT   :=0;
    signal r_tx_done        :       STD_LOGIC                           :='0';
    signal r_tx_active      :       STD_LOGIC                           :='0';
    
    begin
        process(i_clk) is
            begin
                if rising_edge(i_clk) then
                    case r_tx is
                        when IDLE =>
                            r_clk_counter <= 0;
                            r_bit_counter <= 0;
                            r_data_serial <= '1';
                            r_tx_active <= '0';
                            r_tx_done <= '0';

                            -----------------------------------------------------------
                            --if i_en is high, register the byte that we want to send
                            -----------------------------------------------------------
                            if i_en = '1' then
                                r_shift <= i_data_byte;
                                r_tx <= SEND_START_BIT;
                            end if;

                        when SEND_START_BIT =>
                            ----------------------------------------------------------------------------
                            -- Send start bit for one bit period (8.68 * 10^-6 Sec.) = 1 / Baud rate
                            ----------------------------------------------------------------------------
                            if r_clk_counter < g_CLKS_PER_BIT -1 then
                                r_clk_counter <= r_clk_counter +1;
                                r_data_serial <= '0';
                                r_tx_active <= '1';
                            else
                                r_clk_counter <= 0;
                                r_tx <= SEND_DATA_BITS;
                            end if;
                                
                        when SEND_DATA_BITS =>
                            if r_bit_counter < 8 then
                                if r_clk_counter < g_CLKS_PER_BIT -1 then
                                    r_clk_counter <= r_clk_counter + 1;
                                    r_data_serial <= r_shift(0);
                                else
                                    r_shift(7 downto 0) <= '0' & r_shift(7 downto 1);
                                    r_clk_counter <= 0;
                                    r_bit_counter <= r_bit_counter + 1;
                                end if;
                            else
                                r_bit_counter <= 0;
                                r_tx <= SEND_STOP_BIT;
                            end if;

                        when SEND_STOP_BIT =>
                            ----------------------------------------------------------------------------
                            -- Send stop bit for one bit period (8.68 * 10^-6 Sec.) = 1 / Baud rate
                            ----------------------------------------------------------------------------
                            if r_clk_counter < g_CLKS_PER_BIT -1 then
                                r_data_serial <= '1';
                                r_clk_counter <= r_clk_counter + 1;
                            else
                                r_clk_counter <= 0;
                                r_tx_active <= '0';
                                r_tx_done <= '1';
                                r_tx <= IDLE;
                            end if;

                        when others =>
                            r_tx <= IDLE;

                    end case;
                end if;
            end process;

            ----------------------------------------------------
            --The o_tx_done geos high when the byte is sent. 
            --The sata will be sent bit by bit.
            ----------------------------------------------------
            o_tx_done <= r_tx_done;
            o_data_serial <= r_data_serial;
            
            -------------------------------------------------------------------------------------
            -- The o_tx Active becomes low when the o_tx_done geos high (when the byte is sent.)
            -- And it's high when we are in sending process 
            --------------------------------------------------------------------------------------
            o_tx_active <= r_tx_active;
    end RTL;