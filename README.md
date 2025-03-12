# README


## Project Description

The system is designed to display different time periods of the day ("SANG" - Morning, "TRUA" - Noon, "CHIEU" - Afternoon, "TOI" - Night) on the LCD based on user input. The project is implemented using Verilog HDL and tested through simulation and real hardware execution.

![LCD display}(https://github.com/giangday/Communication-between-FPGA-and-LCD/blob/main/demo_lcd.jpg?raw=true)

## Features

- Implements a finite state machine (FSM) to control the LCD display.
- Uses Verilog HDL to program the system.
- Displays four time periods: "SANG", "TRUA", "CHIEU", and "TOI".
- Tested through simulation and on an Arty-Z7 FPGA board.
- Provides a testbench for verification.

## Implementation Details

### State Machine Logic

- Each time period has two writing states, one enabling and one disabling the LCD write signal.
- The FSM transitions based on button inputs from the FPGA board.
- The system resets upon power-on or reset signal activation.

### Frequency Divider

- A frequency divider module generates a clock signal for LCD communication.
- The divisor value is set to 125,000,000, and the output toggles at half this count.

### Testbench

- The testbench simulates the system using a clock and reset signal.
- Monitors LCD output states through Verilog simulation.
- Validates FSM behavior and LCD control logic.

## Simulation and Testing

- The system was simulated using a testbench in Verilog.
- The output was observed via waveform simulation.
- The system was deployed on an Arty-Z7 board for real-world validation.

## Applications

The system can be applied in various real-world scenarios, such as:

- Displaying work shifts in industrial zones.
- Informing customers about meal times in restaurants and hotels.
- Scheduling activities in conference halls and meeting rooms.
- Controlling home appliances based on different time periods.
- Providing patient schedule information in hospitals and clinics.

## Conclusion

This project successfully demonstrates the use of a finite state machine to control a 16x2 LCD display. The implementation showcases practical applications in various fields, including automation, scheduling, and smart home systems. Future improvements could include adding more display options, integrating with sensors, or expanding the system for more complex user interactions.
