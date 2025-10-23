# Four-Bar Mechanism - Quick Reference Card

## 📁 Files Overview

| File | Purpose | Lines | Key Features |
|------|---------|-------|--------------|
| `four_bar_mechanism.m` | Main analysis & animation | 434 | Complete analysis with continuous animation |
| `quick_start_example.m` | Easy examples | 300 | 4 pre-configured linkages |
| `test_four_bar.m` | Validation suite | 276 | Tests all functions |
| `README_FourBar.md` | Full documentation | 242 | Complete user guide |
| `REFACTORING_SUMMARY.md` | Technical overview | 263 | Refactoring details |

## 🚀 Quick Start Commands

```matlab
% Run main simulation (edit link lengths first)
four_bar_mechanism

% Try example configurations
quick_start_example

% Validate installation
test_four_bar
```

## 🔧 Configuration Parameters

### Linkage Dimensions (edit at top of script)
```matlab
link1 = 6.0;    % Ground link (AD) - Fixed distance
link2 = 2.0;    % Input crank (AB) - Rotates
link3 = 5.0;    % Coupler (BC) - Connects
link4 = 4.5;    % Follower (CD) - Output
```

### Animation Settings
```matlab
fps = 30;               % Animation speed (frames/sec)
num_frames = 360;       % Resolution (points around circle)
```

## 📊 Understanding the Output

### Console Output
```
Linkage Dimensions: [Shows your link lengths]
Grashof Analysis: [Mechanism type classification]
```

### Plot Window
Three synchronized plots:
1. **Coupler Angle (θ₃)** - How coupler rotates vs input
2. **Follower Angle (θ₄)** - Output link rotation
3. **Transmission Angle (μ)** - Force transmission quality
   - **Good**: 45-135° (between dashed lines)
   - **Poor**: Near 0° or 180°

### Animation Window
- **Blue line** = Input crank
- **Green line** = Coupler
- **Red line** = Follower (output)
- **Black line** = Ground (fixed)
- **Magenta dots** = Coupler curve trace
- **Circles** = Joints/pivots

## 🔍 Function Reference

### `check_grashof_condition(L1, L2, L3, L4)`
**Purpose**: Classify linkage type  
**Returns**: `[is_grashof, linkage_type]`  
**Example**: `[true, 'Grashof - Crank-Rocker']`

### `solve_four_bar_angles(L1, L2, L3, L4, theta2, theta3_init, theta4_init)`
**Purpose**: Calculate angles for given input  
**Returns**: `[theta3, theta4]` in radians  
**Method**: Freudenstein equation (analytical)

### `calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4)`
**Purpose**: Measure force transmission quality  
**Returns**: `mu` (transmission angle in radians)  
**Good range**: 45-135°

## 📐 Mechanism Types (Grashof Classification)

| Type | Description | Example Links |
|------|-------------|---------------|
| **Crank-Rocker** | Input rotates, output rocks | L₁=6, L₂=2, L₃=5, L₄=4.5 |
| **Double-Crank** | Both rotate continuously | L₁=3, L₂=5, L₃=6, L₄=5.5 |
| **Rocker-Crank** | Input rocks, output rotates | Swap crank/follower |
| **Double-Rocker** | Both oscillate | Coupler is shortest |
| **Non-Grashof** | No full rotation possible | L₁=10, L₂=3, L₃=5, L₄=4 |

## ⚠️ Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| Animation too fast | Decrease `fps` value |
| Animation too slow | Increase `fps` or decrease `num_frames` |
| "Discriminant < 0" | Links can't form closed loop - check dimensions |
| Plots not showing | Check graphics backend: `graphics_toolkit qt` |
| Octave warnings | Normal for gnuplot toolkit - can ignore |

## 🎯 Design Guidelines

### Grashof Condition
For at least one link to rotate completely:
```
s + l ≤ p + q
```
where s=shortest, l=longest, p,q=other two

### Transmission Angle
Good design: Keep μ in range 45-135°
- μ near 0° or 180° = poor force transmission
- μ = 90° = optimal force transmission

### Link Length Rules
1. **Triangle inequality**: Sum of any three links > fourth link
2. **Assembly**: Check that `|L₁ - L₄| ≤ L₂ + L₃ ≤ L₁ + L₄`
3. **Grashof**: If you want full rotation, ensure s+l < p+q

## 📊 Performance

- **Calculation**: ~0.5 sec for 360 positions
- **Animation**: 30 fps smooth playback
- **Accuracy**: < 1e-15 closure error
- **Memory**: ~1 MB (minimal)

## 🔬 Testing

Run the test suite:
```matlab
test_four_bar
```

Expected output:
- ✅ Test 1: Grashof Condition Check
- ✅ Test 2: Angle Solver (zero error)
- ✅ Test 3: Transmission Angle
- ✅ Test 4: Complete Cycle
- ✅ Test 5: Plot Generation

## 💡 Tips

1. **Start with default values** to understand the output
2. **Use quick_start_example.m** to try different types
3. **Check transmission angle plot** for design quality
4. **Modify one link at a time** to see effects
5. **Keep backup of working configurations**

## 📚 Learn More

- Full documentation: `README_FourBar.md`
- Technical details: `REFACTORING_SUMMARY.md`
- Theory: See references section in README

## 🆘 Getting Help

1. Check troubleshooting in `README_FourBar.md`
2. Run `test_four_bar` to verify installation
3. Try `quick_start_example` with default settings
4. Review example configurations in REFACTORING_SUMMARY

---

**Version**: 1.0 (October 2025)  
**Compatibility**: MATLAB R2016b+ / GNU Octave 4.0+  
**License**: Educational use  
**Repository**: Cheskpoff23/MecFracII
