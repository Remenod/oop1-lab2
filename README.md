# OOP Lab 2

This project demonstrates object-oriented programming techniques in Maple.  
It implements two custom data types — **MyMatrix** and **MyTime** — as modules with encapsulated data, methods, constructors, operator overloading, and custom printing behavior.

The repository also includes a test suite that verifies correctness using Maple’s standard numeric and matrix operations as reference implementations.

---

## Project Structure

```
.
├── main.mpl            # Entry point, example usage and demonstration
├── Modules/
│   ├── Matrix.mpl      # MyMatrix class implementation
│   └── MyTime.mpl      # MyTime class implementation
└── Tests/
    ├── MatrixTests.mpl # Test suite for MyMatrix
    └── MyTimeTests.mpl # Test suite for MyTime
```

---

## MyMatrix

A custom matrix class supporting:

- Construction from:
  - Maple Matrix
  - List-of-lists
  - String formatted as rows
  - Another MyMatrix
- Operations:
  - Determinant calculation
  - Transpose
  - Addition and multiplication (operator overloading)
- Custom pretty-printing

### Example

```maple
with(LinearAlgebra):

A := Matrix([[1,2],[3,4]]);
M := MyMatrix(A);
print(M);
```

---

## MyTime

Represents a time-of-day as seconds since midnight.

Features:

- Construction from seconds or `(hours, minutes, seconds)`
- Time normalization (wraps around 24 hours)
- Adding time (AddSeconds, AddOneMinute, etc.)
- Subtraction and addition with operator overloading
- Human-readable formatting
- Function `WhatLesson()` describing which class period the time corresponds to

### Example

```maple
t := MyTime(8, 30, 0);
print(t);
t:-AddOneHour();
print(t);
```

---

## Running Tests

Each module has an associated test file.  
To run tests, simply load them in Maple:

```maple
read "Tests/MatrixTests.mpl":
read "Tests/MyTimeTests.mpl":
```

Tests include randomized checks comparing custom operations to Maple's built-in behavior.

---

## Requirements

- Maple 2021 or newer (older versions likely work but are not tested)
- No external dependencies

---

## Usage

Load the main script to see demonstration examples:

```maple
read "main.mpl":
```

or run main as it

```bash
maple -q main.mpl
```
