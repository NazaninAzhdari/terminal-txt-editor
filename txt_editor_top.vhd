library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity txt_editor_top is
    port (
        i_clk               :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_UART_RX           :   in      STD_LOGIC; 

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
		  
		  
        ----------------------------------------------------------------------
        -- Store the ASCII Characters into a Buffer RAM
        -- READ ascii characters from buffer RAM 
        ----------------------------------------------------------------------
        character_buffer: entity work.char_buffer
        generic map (
            g_SCALE         => c_SCALE,
            g_LOG2_SCALE    => c_LOG2_SCALE,
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
            i_write_EN      => w_ASCCI_DV,
            i_ASCII_code    => w_ASCII_code,
            i_read_EN       => '1',
            i_x             => w_x,
            i_y             => w_y,
            o_ASCII_code    => w_read_ascci,
            o_column        => w_column,
            o_row           => w_row
        );

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

        o_HDMI_video <= (others=>'1') when (w_draw_char = '1' or w_draw_cursor = '1') and w_DE = '1' else (others=>'0');

    end RTL;