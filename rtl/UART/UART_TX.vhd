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

    type t_state_machine is (IDLE, SEND_START_BIT, SEND_DATA_BITS, SEND_STOP_BIT, CLEAN_UP);
    signal r_state        : t_state_machine                       := IDLE;

    signal r_clk_counter  : integer range 0 to g_CLKS_PER_BIT-1   := 0;
    signal r_bit_counter  : integer range 0 to g_BITS_LIMIT-1     := 0;  -- 8 Bits Total
    signal r_TX_Data      : unsigned(g_BITS_LIMIT-1 downto 0)     := (others => '0');
    signal r_TX_Done      : STD_LOGIC                             := '0';
  
    begin
    process (i_Clk)
        begin
            if rising_edge(i_Clk) then
                
                r_TX_Done   <= '0';  -- Default assignment

                case r_state is
                    when IDLE =>
                        o_TX_Active <= '0';
                        o_data_serial <= '1';         -- Drive Line High for Idle
                        r_clk_counter <= 0;
                        r_bit_counter <= 0;

                        -----------------------------------------------------------
                        --if i_en is high, register the byte that we want to send
                        -----------------------------------------------------------
                        if i_En = '1' then
                            r_TX_Data <= i_data_byte;
                            r_state <= SEND_START_BIT;
                        else
                            r_state <= IDLE;
                        end if;

                    ----------------------------------------------------------------------------
                    -- Send start bit for one bit period (8.68 * 10^-6 Sec.) = 1 / Baud rate
                    ----------------------------------------------------------------------------
                    when SEND_START_BIT =>
                        o_TX_Active <= '1';
                        o_data_serial <= '0';

                        -- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
                        if r_clk_counter < g_CLKS_PER_BIT-1 then
                            r_clk_counter <= r_clk_counter + 1;
                            r_state   <= SEND_START_BIT;
                        else
                            r_clk_counter <= 0;
                            r_state   <= SEND_DATA_BITS;
                        end if;

                    
                    -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
                    when SEND_DATA_BITS =>
                        o_data_serial <= r_TX_Data(r_bit_counter);
                    
                        if r_clk_counter < g_CLKS_PER_BIT-1 then
                            r_clk_counter <= r_clk_counter + 1;
                            r_state   <= SEND_DATA_BITS;
                        else
                            r_clk_counter <= 0;
                            
                            -- Check if we have sent out all bits
                            if r_bit_counter < g_BITS_LIMIT-1 then
                                r_bit_counter <= r_bit_counter + 1;
                                r_state   <= SEND_DATA_BITS;
                            else
                                r_bit_counter <= 0;
                                r_state   <= SEND_STOP_BIT;
                            end if;
                        end if;

                    ----------------------------------------------------------------------------
                    -- Send stop bit for one bit period (8.68 * 10^-6 Sec.) = 1 / Baud rate
                    ----------------------------------------------------------------------------
                    when SEND_STOP_BIT =>
                        o_data_serial <= '1';

                        -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                        if r_clk_counter < g_CLKS_PER_BIT-1 then
                            r_clk_counter <= r_clk_counter + 1;
                            r_state   <= SEND_STOP_BIT;
                        else
                            r_TX_Done   <= '1';
                            r_clk_counter <= 0;
                            r_state   <= CLEAN_UP;
                        end if;

                    ------------------------- 
                    -- Stay here 1 clock
                    -------------------------
                    when CLEAN_UP =>
                        -------------------------------------------------------------------------------------
                        -- The o_tx Active becomes low one cycle after the o_tx_done geos high (when the byte is sent.)
                        -- And it's high when we are in sending process 
                        --------------------------------------------------------------------------------------
                        o_TX_Active <= '0';
                        r_state   <= IDLE;
                    
                        
                    when others =>
                        r_state <= IDLE;

                end case;
            end if;
        end process;

        ----------------------------------------------------
        --The o_tx_done geos high when the byte is sent. 
        ----------------------------------------------------
        o_TX_Done <= r_TX_Done;
  
end RTL;