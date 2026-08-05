library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity txt_editor_FSM is
    port (
        i_clk               :   in      STD_LOGIC;
        i_reset             :   in      STD_LOGIC;
        i_start             :   in      STD_LOGIC;
        i_TX_start          :   in      STD_LOGIC;
        i_TX_end            :   in      STD_LOGIC;
        o_start_page        :   out     STD_LOGIC;
        o_editing_page      :   out     STD_LOGIC;
        o_transfering_page  :   out     STD_LOGIC;
        o_end_page          :   out     STD_LOGIC
    );
end txt_editor_FSM;

architecture RTL of txt_editor_FSM is
    type t_state_machine is (IDLE, EDITING, TRANSFERING, DONE);
    signal r_state          :   t_state_machine     :=IDLE;
    signal r_start          :   STD_LOGIC           :='0';
    signal r_TX_start       :   STD_LOGIC           :='0';
    signal r_TX_end         :   STD_LOGIC           :='0';

    begin
        process(i_clk, i_reset) is
            begin
                if i_reset = '1' then
                    r_state <= IDLE;

                elsif rising_edge(i_clk) then
                    r_start <= i_start;
                    r_TX_start <= i_TX_start;
                    r_TX_end <= i_TX_end;

                    case r_state is
                        when IDLE =>
                            
                            --falling-edge of start button
                            if i_start = '0' and r_start = '1' then
                                r_state <= EDITING;
                            end if;

                        when EDITING =>
                           
                            --faling-edge of start transfer button
                            if i_TX_start = '0' and r_TX_start = '1' then
                                r_state <= TRANSFERING;
                            end if;

                        when TRANSFERING =>

                            --rising-edge of end transfer button
                            if i_TX_end = '1' and r_TX_end = '0' then
                                r_state <= DONE;
                            end if;

                        when DONE =>

                            --falling-edge of start button
                            if i_start = '0' and r_start = '1' then
                                r_state <= IDLE;
                            end if;

                        when others =>
                            r_state <= IDLE;
                        end case;
                    end if;
            end process;

        o_start_page <= '1' when r_state = IDLE else '0';
        o_editing_page <= '1' when r_state = EDITING else '0';
        o_transfering_page <= '1' when r_state = TRANSFERING else '0';
        o_end_page <= '1' when r_state = DONE else '0';

    end RTL;