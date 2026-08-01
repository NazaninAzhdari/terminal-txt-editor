library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity txt_editor_top is
    port (
        i_clk               :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_start_L           :   in      STD_LOGIC;
        i_TX_start_L        :   in      STD_LOGIC;

		  --LEDs
		  o_LED					:	out 		unsigned(3 downto 0);
        
        --UART interface
        i_UART_RX           :   in      STD_LOGIC;
        o_UART_TX           :   out     STD_LOGIC;

        --HDMI Interface
        o_hdmi_CLK          :   out     STD_LOGIC;
        o_hdmi_DE           :   out     STD_LOGIC;
        o_hdmi_HS           :   out     STD_LOGIC;
        o_hdmi_VS           :   out     STD_LOGIC;
        o_hdmi_video        :   out     unsigned(23 downto 0)
    );
end txt_editor_top;

architecture RTL of txt_editor_top is
    constant c_DEBOUNCE_LIMIT   :   integer     :=20000000; --0.4 Sec
    constant c_BLINK_LIMIT      :   integer     :=25000000; --0.5 Sec
    constant c_SCREEN_WIDTH     :   integer     :=640;
    constant c_SCREEN_HEIGHT    :   integer     :=480;
    constant c_SCALE            :   integer     :=8;                            --Size of Each character
    constant c_LOG2_SCALE       :   integer     :=3;                            --log2(scale)
    constant c_COL_NUM          :   integer     := c_SCREEN_WIDTH/ c_SCALE;     --Maximum number of columns (640 /8)
    constant c_ROW_NUM          :   integer     := c_SCREEN_HEIGHT / c_SCALE;   --Maximum Number of Rows (480 / 8)
    constant c_RAM_SIZE         :   integer     :=c_COL_NUM * c_ROW_NUM;        --Size of RAM (4800)
    constant c_COL_BIT_WIDTH    :   integer     :=7;                            --Minimum bit-width required to represent the columns (.e.g. 0 to 80)
    constant c_ROW_BIT_WIDTH    :   integer     :=6;                            --minimum bit-width required to represent the rows (.e.g. 0 to 60)
    constant c_RAM_BIT_WIDTH    :   integer     :=13;                           --Minimum bit-width required to represent the address of RAM from 0 to 4800
    
    signal w_reset              :   STD_LOGIC                               :='0';
	signal w_x					:   unsigned(9 downto 0)                    :=(others=>'0');
	signal w_y					:   unsigned(9 downto 0)                    :=(others=>'0');
    signal w_ascii_code         :   unsigned(7 downto 0)                    :=(others=>'0');
    signal w_ascci_DV           :   STD_LOGIC                               :='0';
    signal w_clk25              :   STD_LOGIC                               :='0';
    signal w_DE                 :   STD_LOGIC                               :='0';
    signal w_read_ASCCI         :   unsigned(7 downto 0)                    :=(others=>'0');
    signal w_column             :   unsigned(c_COL_BIT_WIDTH-1 downto 0)    :=(others=>'0');
    signal w_row                :   unsigned(c_ROW_BIT_WIDTH-1 downto 0)    :=(others=>'0');
    signal w_draw_char          :   STD_LOGIC                               :='0';
    signal w_draw_cursor        :   STD_LOGIC                               :='0';
    signal w_start_En           :   STD_LOGIC                               :='0';
    signal w_editing_En         :   STD_LOGIC                               :='0';
    signal w_transfering_EN     :   STD_LOGIC                               :='0';
    signal w_end_EN             :   STD_LOGIC                               :='0';
    signal r_read_addr_vga      :   integer range 0 to c_RAM_SIZE-1         :=0;
    signal r_ram_counter        :   integer range 0 to c_RAM_SIZE-1         :=0;
    signal r_read_addr          :   unsigned(c_RAM_BIT_WIDTH-1 downto 0)    :=(others=>'0');
    signal r_x_div_scale        :   integer range 0 to c_COL_NUM-1          :=0;
    signal r_y_div_scale        :   integer range 0 to c_ROW_NUM-1          :=0;
    signal r_transfer_done      :   STD_LOGIC                               :='0';
    signal r_write_en           :   STD_LOGIC                               :='0';
    signal w_TX_active          :   STD_LOGIC                               :='0';
    signal r_tx_ACTIVE          :   STD_LOGIC                               :='0';
	signal w_uart_tx            :   STD_LOGIC                               :='0';
	signal r_tx_en              :   STD_LOGIC                               :='0';
    signal r_tx_byte            :   unsigned(7 downto 0)                    :=(others=>'0');

    type t_state_machine is (IDLE, PRE_FETCH, LOAD_BYTE, WAIT_TX_HIGH, WAIT_TX_LOW);
    signal r_state : t_state_machine := IDLE;
	
    begin
        ------------------------------
        --Debouncing the Reset Button
        ------------------------------
        Debouncing_the_reset_button: entity work.debounce_filter
        generic map (
            g_DEBOUNCE_LIMIT => c_DEBOUNCE_LIMIT
        )
        port map(
            i_clk       => i_clk,
            i_bouncy    => i_reset,
            o_debounced => w_reset
        );

        -----------------------------------------------------
        -- Generating 25MHz frequency out of 50MHz frequency
        -----------------------------------------------------
        generate_25mhz_frequency: entity work.freq_divider
        generic map(
            g_CLK_CYCLES_FOR_HALF_PERIOD => 1
        )
        port map(
            i_clk   => i_clk,  --50 MHz
            o_clk   => w_clk25 --25 MHz
        );

        -----------------------------------------
        -- VGA Synchronization
        -----------------------------------------
        VGA_synchronization: entity work.VGAsync
        port map (
            i_clk25 => w_clk25,
            i_reset => w_reset,
            o_X => w_x,
            o_Y => w_y,
            o_DE => w_DE,
            o_HS => o_HDMI_HS,
            o_VS => o_HDMI_VS
        );

        o_HDMI_CLK <= w_clk25;
        o_HDMI_DE <= w_DE;

        ---------------------------------------------
        -- The Editor State Machine
        ---------------------------------------------
        editor_state_machine: entity work.txt_editor_FSM
        port map (
            i_clk               => i_clk,
            i_reset             => w_reset,
            i_start             => not i_start_L,
            i_TX_start          => not i_tx_start_L,
            i_TX_end            => r_transfer_done,
            o_start_page        => w_start_En,
            o_editing_page      => w_editing_EN,
            o_transfering_page  => w_transfering_EN,
            o_end_page          => w_End_EN
        );

        -------------------------------------------------------------------------
        -- Recieve the ASCII code of characters through UART Reciever (Serially)
        -------------------------------------------------------------------------
        UART_reciever: entity work.UART_RX
        generic map (
            g_BITS_LIMIT   => 8,
            g_CLKS_PER_BIT => 434    
        )
        port map(
            i_clk                => i_clk,
            i_data_serial        => i_UART_RX,
            o_data_parallel      => w_ascii_code,
            o_data_DV            => w_ascci_DV
        );

        -- only when we are in editing mode, we can write into budder.
        r_write_en <= w_ascci_DV when w_editing_en = '1' else '0';
		  
	
        ----------------------------------------------------------------------
        -- Store the ASCII Characters into a Buffer RAM
        -- READ ascii characters from buffer RAM 
        ----------------------------------------------------------------------
        character_buffer: entity work.char_buffer
        generic map (
            g_COL_NUM       => c_COL_NUM,                    --Maximum number of columns (640 /8)
            g_ROW_NUM       => c_ROW_NUM,                    --Maximum Number of Rows (480 / 8)
            g_RAM_SIZE      => c_RAM_SIZE,                   -- 80 * 60
            g_COL_BIT_WIDTH => c_COL_BIT_WIDTH,              --Minimum bit-width required to represent the columns (.e.g. 0 to 80)
            g_ROW_BIT_WIDTH => c_ROW_BIT_WIDTH,              --minimum bit-width required to represent the rows (.e.g. 0 to 60)
            g_RAM_BIT_WIDTH => c_RAM_BIT_WIDTH               --Minimum bit-width required to represent the address of RAM from 0 to 4800
        )
        port map (
            i_clk           => i_clk,
            i_reset         => w_reset,
            i_write_EN      => r_write_EN,
            i_ASCII_code    => w_ASCII_code,
            i_read_EN       => '1',
            i_read_addr     => r_read_addr,
            o_ASCII_code    => w_read_ascci,
            o_column        => w_column,
            o_row           => w_row
        );

        ------------------------------------------------------------------------------------------------
        -- Computing the address of RAM based on X/Y cordinates to display on VGA screen (read address)
        ------------------------------------------------------------------------------------------------
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
        r_x_div_scale <= to_integer(w_x(w_x'left downto c_LOG2_SCALE));   -- x / SCALE
        r_y_div_scale <= to_integer(w_y(w_y'left downto c_LOG2_SCALE));   -- y / SCALE
        r_read_addr_vga <= r_x_div_scale + (r_y_div_scale  * c_COL_NUM);

        ----------------------------------------------------------------------------------------------
        -- Computing the address of RAM based on a counter to sent through the UART-TX (read address)
        ----------------------------------------------------------------------------------------------    
        process(i_clk, w_reset)
            begin
                if w_reset = '1' then
                    r_state <= IDLE;
                    r_ram_counter <= 0;
                    r_tx_en <= '0';
                    r_tx_byte <= (others => '0');

                elsif rising_edge(i_clk) then
                    r_tx_active <= w_tx_active;
                    r_tx_en <= '0'; 

                    case r_state is
                        when IDLE =>
                            r_transfer_done <= '0';
                            r_ram_counter <= 0;
                            if w_transfering_EN = '1' then
                                r_state <= PRE_FETCH;
                            end if;
                        
                        when PRE_FETCH =>
                            r_tx_byte <= w_read_ascci;
                            r_state <= LOAD_BYTE;

                        when LOAD_BYTE =>
                            r_tx_byte <= w_read_ascci;
                            r_tx_en  <= '1';        
                            r_state    <= WAIT_TX_HIGH;

                        when WAIT_TX_HIGH =>
                            -- Wait for one clock cycle to transmitter become busy
                            r_state <= WAIT_TX_LOW;

                        when WAIT_TX_LOW =>
                            
                            if w_tx_active = '0' and r_tx_active = '1' then
                                if r_ram_counter = c_RAM_SIZE-1 then
                                    r_state <= IDLE;
                                    r_transfer_done <= '1'; 
                                else
                                    r_ram_counter <= r_ram_counter + 1;
                                    r_state <= PRE_FETCH;
                                end if;
                            end if;
                    end case;
                end if;
            end process;

        r_read_addr <= to_unsigned(r_ram_counter, r_read_addr'length) when w_transfering_EN = '1' else
                        to_unsigned(r_read_addr_vga, r_read_addr'length);

        ------------------------------------------
        -- UART Transmitter
        ------------------------------------------
        uart_transmitter: entity work.UART_TX
        generic map(
            g_BITS_LIMIT        => 8,      --can be set to 7 or 8
            g_CLKS_PER_BIT      => 434     --can be determined based on the CLK and Baud rate. =>  CLK / Baud rate
        )
        port map(
            i_clk           => i_clk,
            i_En            => r_tx_en,
            i_data_byte     => r_tx_byte,
            o_data_Serial   => w_UART_TX,
            o_TX_active     => w_TX_ACTIVE,
            o_TX_Done       => OPEN
        );
		  
        -- Drive UART line high when transmitter is not active
        o_UART_TX <= w_uart_tx when w_TX_Active = '1' else '1';
 
        -----------------------------------------------------
        -- Draw the letters based on their ascii code
        -----------------------------------------------------
        drawing_characters: entity work.draw_characters
        generic map (
            g_SCALE         => c_SCALE,         --Size of Each character
            g_LOG2_SCALE    => c_LOG2_SCALE,    --log2(scale)
            g_SCREEN_WIDTH  => c_SCREEN_WIDTH,
            g_SCREEN_HEIGHT => c_SCREEN_HEIGHT
        )
        port map (
            i_clk           => i_clk,
            i_reset         => w_reset,
            i_x             => w_x,
            i_y             => w_y,
            i_ASCII_code    => w_read_ASCCI,
            o_draw          => w_draw_char
        );

        ---------------------------------
        -- Draw the Cursor
        ---------------------------------
        drawing_cursor: entity work.draw_cursor
        generic map (
            g_LOG2_SCALE    => c_LOG2_SCALE,
            g_COL_NUM       => c_COL_NUM,                    --Maximum number of columns (640 /8)
            g_ROW_NUM       => c_ROW_NUM,                    --Maximum Number of Rows (480 / 8)
            g_COL_BIT_WIDTH => c_COL_BIT_WIDTH,              --Minimum bit-width required to represent the columns (.e.g. 0 to 80)
            g_ROW_BIT_WIDTH => c_ROW_BIT_WIDTH,              --minimum bit-width required to represent the rows (.e.g. 0 to 60)
            g_BLINK_LIMIT   => c_BLINK_LIMIT
        )
        port map (
            i_clk           => i_clk,
            i_reset         => w_reset,
            i_column        => w_column,
            i_row           => w_row,
            i_x             => w_x,
            i_y             => w_y,
            o_draw_cursor   => w_draw_cursor
        );

        o_HDMI_video <= "111111110000000000000000" when w_start_En = '1' and w_DE = '1' else
                        (others=>'1') when (w_draw_char = '1' or w_draw_cursor = '1') and w_DE = '1' and w_editing_EN = '1' else 
                        (others=>'0') when (w_draw_char = '0' and w_draw_cursor = '0') and w_DE = '1' and w_editing_EN = '1' else
                        "000000001111111100000000" when w_transfering_EN = '1' and w_DE = '1' else
                        "000000000000000011111111" when w_end_EN = '1' and w_DE = '1' else
                        (others=>'0');
								
        o_LED(0) <= '1' when w_start_EN = '1' else '0';
        o_LED(1) <= '1' when w_editing_EN = '1' else '0';
        o_LED(2) <= '1' when w_transfering_EN = '1' else '0';
        o_LED(3) <= '1' when w_end_EN = '1' else '0';

    end RTL;