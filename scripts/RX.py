# I used this Python script to receive the data that comes from the FPGA through the FPGA's UART transmitter.
# On the FPGA side, we write into a buffer with the size of 80×60 (4800 bytes total). When the text is ready, we send the buffer data 
# one byte at a time through the UART transmitter, bit by bit, with a baud rate of 115200.
# The start bit is 0 and the stop bit is 1, and no parity bit.
# On the PC side, we run this Python script. It listens to the UART port and receives all incoming data.
# This script works as a receiver on the PC. It collects the incoming bits, builds each byte (ASCII code), 
# and converts it to the matching ASCII character. At the end, it saves all the characters into a text file.

# To use this script you shuld install pyserial library. (pip install pyserial)
# Also please change the configuration of the serial port based on your system.

import serial

# Serial port configuration
PORT = 'COM8'
BAUD_RATE = 115200
COLS = 80
ROWS = 60
TOTAL_BYTES = COLS * ROWS  # Total buffer bytes (4800 bytes)
OUTPUT_FILE = 'fpga_text_output.txt'

def receive_from_fpga():
    # Print connection status message to the console
    print(f"Connecting to port {PORT} with baud rate {BAUD_RATE}...")
    
    try:
        # Open the serial port with a timeout of 2 seconds
        ser = serial.Serial(PORT, BAUD_RATE, timeout=2)
        print("Connected! Waiting to receive data from FPGA (press the transfer button [Key 1 on FPGA board])...")
        
        # Initialize an empty bytearray to store incoming data chunks
        received_data = bytearray()
        
        # Loop until all required bytes for the 80x60 buffer are received
        while len(received_data) < TOTAL_BYTES:
            # Read the remaining expected bytes from the serial port
            chunk = ser.read(TOTAL_BYTES - len(received_data))
            if chunk:
                # Append the received chunk to our master bytearray
                received_data.extend(chunk)
                # Display real-time download progress on the same line
                print(f"Received: {len(received_data)} / {TOTAL_BYTES} bytes", end='\r')
                
        print("\nReception complete!")
        
        # Decode the raw bytearray into an ASCII text string, ignoring invalid characters
        text_content = received_data.decode('ascii', errors='ignore')
        
        # Organize the flat text string into 60 separate lines, each containing 80 characters
        formatted_lines = []
        for i in range(ROWS):
            start_idx = i * COLS
            end_idx = start_idx + COLS
            line = text_content[start_idx:end_idx]
            formatted_lines.append(line)
        
        # Write the formatted matrix of lines into the target text file using UTF-8 encoding
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            f.write('\n'.join(formatted_lines))
            
        print(f"Data successfully saved in a {COLS}-column and {ROWS}-row format in file '{OUTPUT_FILE}'.")

    except serial.SerialException as e:
        # Handle potential serial communication errors (e.g., port busy or disconnected)
        print(f"Serial communication error: {e}")
    except KeyboardInterrupt:
        # Handle manual user interruption (Ctrl+C)
        print("\nOperation stopped by user.")
    finally:
        # Ensure the serial port is safely closed if it was successfully opened
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("Serial port closed.")

if __name__ == "__main__":
    # Entry point of the script execution
    receive_from_fpga()