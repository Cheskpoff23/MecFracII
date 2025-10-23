# Four-Bar Mechanism Analysis - MATLAB Script

## Overview

This MATLAB script performs comprehensive kinematic analysis of four-bar linkage mechanisms. It provides:
- Grashof condition checking and classification
- Position analysis using Newton-Raphson iteration
- Transmission angle calculation
- Real-time mechanism animation
- Graphical plots of angles throughout the rotation cycle

## Features

### 1. Grashof Condition Analysis
- Automatically determines if the linkage satisfies the Grashof condition
- Classifies the mechanism type:
  - Crank-Rocker
  - Double-Crank
  - Rocker-Crank
  - Double-Rocker
  - Triple-Rocker (non-Grashof)

### 2. Kinematic Analysis
- Solves for coupler (θ₃) and follower (θ₄) angles for any input angle (θ₂)
- Uses Newton-Raphson method for accurate iterative solution
- Handles singularities and convergence issues

### 3. Transmission Angle Monitoring
- Calculates transmission angle throughout the motion cycle
- Highlights optimal transmission range (45-135°)
- Helps identify dead positions and poor force transmission regions

### 4. Real-Time Animation
- Visual representation of mechanism motion
- Shows all four links with color coding
- Displays coupler curve trace
- Shows current angles in title

### 5. Comprehensive Plotting
- Coupler angle vs input angle
- Follower angle vs input angle
- Transmission angle vs input angle

## File Structure

```
four_bar_mechanism.m    - Main script with all functions
README_FourBar.md       - This documentation file
```

## Usage

### Basic Usage

1. Open MATLAB
2. Navigate to the script directory
3. Run the script:
   ```matlab
   four_bar_mechanism
   ```

### Customizing the Linkage

Edit the following parameters in the script (lines 30-33):

```matlab
link1 = 6.0;    % Ground link length (AD)
link2 = 2.0;    % Input crank length (AB)
link3 = 5.0;    % Coupler link length (BC)
link4 = 4.5;    % Output follower length (CD)
```

### Adjusting Animation Speed

Edit the animation parameters (lines 36-38):

```matlab
omega2 = 2.0;           % Angular velocity (rad/s)
fps = 30;               % Frames per second
num_frames = 360;       % Total frames for complete rotation
```

## Linkage Configuration

The four-bar linkage consists of:
- **Link 1 (Ground)**: Fixed link between points A and D
- **Link 2 (Input Crank)**: Rotating input link from A to B
- **Link 3 (Coupler)**: Connecting link from B to C
- **Link 4 (Output Follower)**: Rotating output link from C to D

```
    B ----------- C
   /               \
  /                 \
 A ================= D
    Link 1 (Ground)
```

## Understanding the Output

### Console Output
The script displays:
- Linkage dimensions
- Grashof classification
- Whether continuous rotation is possible
- Calculation progress

### Plot Window
Shows three subplots:
1. **Coupler Angle (θ₃)**: Shows how the coupler rotates as input rotates
2. **Follower Angle (θ₄)**: Shows output link rotation
3. **Transmission Angle (μ)**: Shows force transmission quality
   - Good range: 45-135° (marked with dashed lines)
   - Poor transmission: Near 0° or 180°

### Animation Window
Real-time visualization showing:
- Link positions and orientations
- Joint locations (colored circles)
- Coupler curve (magenta dots)
- Current angles in title

## Example Configurations

### Example 1: Crank-Rocker Mechanism
```matlab
link1 = 6.0;
link2 = 2.0;
link3 = 5.0;
link4 = 4.5;
```
Input link makes complete rotations; output link rocks back and forth.

### Example 2: Double-Crank Mechanism
```matlab
link1 = 3.0;
link2 = 5.0;
link3 = 6.0;
link4 = 5.5;
```
Both input and output links can make complete rotations.

### Example 3: Non-Grashof Mechanism
```matlab
link1 = 10.0;
link2 = 3.0;
link3 = 5.0;
link4 = 4.0;
```
No link can make a complete rotation; all links rock.

## Functions

The script includes three modular helper functions:

### 1. `check_grashof_condition(L1, L2, L3, L4)`
Determines Grashof condition and classifies linkage type.

**Inputs:**
- L1, L2, L3, L4: Link lengths

**Outputs:**
- is_grashof: Boolean indicating Grashof satisfaction
- linkage_type: Classification string

### 2. `solve_four_bar_angles(L1, L2, L3, L4, theta2, theta3_init, theta4_init)`
Solves for θ₃ and θ₄ using Newton-Raphson iteration.

**Inputs:**
- L1, L2, L3, L4: Link lengths
- theta2: Input angle (radians)
- theta3_init, theta4_init: Initial guesses (radians)

**Outputs:**
- theta3: Coupler angle (radians)
- theta4: Follower angle (radians)

### 3. `calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4)`
Calculates transmission angle for force transmission analysis.

**Inputs:**
- L2, L3, L4: Link lengths
- theta2, theta3, theta4: Current angles (radians)

**Outputs:**
- mu: Transmission angle (radians)

## Modifying the Code

### Adding New Features
The modular structure makes it easy to add features:
- Velocity/acceleration analysis: Add new functions after angle solving
- Different coupler points: Modify the plotting section
- Export data: Add file I/O after calculations

### Changing Display
- Modify subplot layout in lines 115-157
- Adjust figure sizes in line 102 and 169
- Change colors/line widths in animation section (lines 211-245)

## Troubleshooting

### Common Issues

**Problem:** Animation runs too fast/slow
- **Solution:** Adjust `fps` parameter (line 36)

**Problem:** "Singular Jacobian" warning
- **Solution:** Check if link lengths form a valid mechanism
- Ensure Grashof condition is checked

**Problem:** Links don't close properly
- **Solution:** Verify link lengths satisfy assembly conditions
- Check that s + l ≤ p + q

**Problem:** Script runs but no animation appears
- **Solution:** Check MATLAB graphics settings
- Ensure figure windows aren't hidden

## Requirements

- MATLAB R2016b or later (earlier versions may work with minor modifications)
- No additional toolboxes required
- Basic plotting and numerical computation capabilities

## References

- Erdman, A. G., & Sandor, G. N. (1997). *Mechanism Design: Analysis and Synthesis*. Prentice Hall.
- Norton, R. L. (2011). *Design of Machinery*. McGraw-Hill.
- Uicker, J. J., Pennock, G. R., & Shigley, J. E. (2010). *Theory of Machines and Mechanisms*. Oxford University Press.

## Author

Refactored for improved readability, maintainability, and documentation.

## License

This script is provided for educational and research purposes. Feel free to modify and distribute with attribution.

## Version History

- **v1.0** (2025): Initial refactored version with modular functions and comprehensive documentation
