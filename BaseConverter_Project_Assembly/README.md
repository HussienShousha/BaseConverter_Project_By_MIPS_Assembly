# Base Converter

A MIPS assembly program that converts numbers between different numeral systems (bases 2-16).

## Overview

This project implements a base conversion utility in MIPS assembly language. The program takes a number in any base from 2 to 16, validates the input, and converts it to any other base within the same range. It supports hexadecimal notation (digits 0-9 and letters A-F) for bases greater than 10.

## Features

- **Multi-base Support**: Converts between any bases from 2 (binary) to 16 (hexadecimal)
- **Input Validation**: Verifies that all digits in the input number are valid for the specified base
- **Error Handling**: Provides clear error messages when invalid characters are detected
- **Hexadecimal Support**: Handles both numeric (0-9) and alphabetic (A-F) characters

## How It Works

The conversion process follows a two-step algorithm:

1. **Source Base → Decimal**: Converts the input number from its original base to decimal (base 10)
2. **Decimal → Target Base**: Converts the decimal result to the desired target base

### Example Conversion

```
Input Base: 16 (hexadecimal)
Input Number: 2A
Output Base: 2 (binary)
Result: 101010
```

## Usage

### Running the Program

1. Load the program in a MIPS simulator (MARS, SPIM, or QtSPIM)
2. Run the program
3. Follow the prompts:
   - Enter the current base (2-16)
   - Enter the number to convert
   - Enter the target base (2-16)
4. View the converted result

### Input Requirements

- **Base Range**: Integer between 2 and 16
- **Number Format**: String of valid digits for the specified base
  - Binary (base 2): 0-1
  - Octal (base 8): 0-7
  - Decimal (base 10): 0-9
  - Hexadecimal (base 16): 0-9, A-F
- **Maximum Length**: 50 characters

## Program Structure

### Main Components

- **`main`**: Primary program flow and user interaction
- **`val`**: Validates and converts individual characters to their numeric values
- **`OtherToDecimal`**: Converts from any base to decimal
- **`DecimalToOther`**: Converts from decimal to any base

### Data Section

- Input prompts and output messages
- Error messages for invalid input
- Buffers for storing the input number and result (50 bytes each)

## Technical Details

### Validation Logic

The program validates each character in the input:
- Numeric characters ('0'-'9') are valid if their value is less than the base
- Alphabetic characters ('A'-'F') represent values 10-15 for bases > 10
- Any character not meeting these criteria triggers an error

### Conversion Algorithm

**Base to Decimal:**
```
result = 0
power = 1
for each digit from right to left:
    result += digit_value × power
    power × = base
```

**Decimal to Base:**
```
while number > 0:
    remainder = number mod base
    add remainder to result
    number = number ÷ base
reverse result string
```

## Error Handling

When an invalid character is detected, the program:
1. Displays the problematic character
2. Shows the base that was specified
3. Exits gracefully without performing the conversion

Example error message:
```
Error: 'G' is not valid in base 16.
```

## Requirements

- MIPS simulator (MARS, SPIM, or QtSPIM)
- Basic understanding of numeral systems

## Limitations

- Maximum input length: 50 characters
- Only supports bases 2-16
- Uppercase letters only (A-F, not a-f)
- No negative number support
- No floating-point number support

## Future Enhancements

Potential improvements for future versions:
- Support for lowercase hexadecimal letters (a-f)
- Negative number handling
- Extended base support (beyond base 16)
- Batch conversion mode
- Direct base-to-base conversion optimization

## Author

Hussien Shousha

## License

This project is available for educational purposes.
