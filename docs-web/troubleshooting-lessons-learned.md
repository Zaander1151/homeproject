# Troubleshooting Lessons Learned

This document captures real troubleshooting sessions and lessons learned to improve future diagnostic approaches.

---

## Session: 2026-01-23 - Bedroom LED Strip Power Issues

### The Problem
- LED strip showing 0.6V at pads when connected, despite 5V at power supply
- Voltage dropped whenever strip was connected

### What I Did Wrong

1. **Jumped to "bad hardware" too quickly** - When voltage dropped to 0.6V (diode forward voltage), I assumed the LED strip was shorted/damaged and recommended cutting off LEDs. This was wrong.

2. **Didn't verify the diagnosis** - I should have had the user test the strip's resistance BEFORE recommending cutting it. The strip measured 13.25KΩ (healthy) - not shorted at all.

3. **Focused on the wrong component** - I kept troubleshooting the strip and solder joints when the actual problem was in the power bus wiring.

4. **Didn't trace the full power path systematically** - Should have methodically checked voltage at each point from PSU to load before blaming any single component.

### The Actual Problem
- A break/discontinuity in the power bus wire
- Whatever device was physically "last" on the bus (past the break) would lose power
- Moving connections closer to the input bypassed the broken section

### Correct Diagnostic Approach

When voltage drops unexpectedly under load:

1. **Measure at multiple points simultaneously** - Check voltage at PSU output, at each distribution point, and at the load. Find WHERE the drop occurs.

2. **Check continuity of power distribution** - Before blaming any device, verify the power bus/wiring is continuous from source to all tap points.

3. **Test components in isolation** - Measure resistance of suspected "bad" components BEFORE cutting/replacing them.

4. **Consider the full circuit** - The problem may not be where the symptom appears. Voltage drop at the load could be caused by:
   - Bad connection at the load
   - Bad connection upstream (fuse, distribution, wiring)
   - Undersized wiring for the current
   - Break in the power path

5. **Listen to the user** - When they say "the joints look fine" and "polarity is correct," believe them and move on to other possibilities.

### Key Diagnostic Questions (Power Issues)

Ask these in order:

1. Where exactly are you measuring? (Which points, both probes)
2. What's the voltage at the SOURCE right now?
3. What's the voltage at each DISTRIBUTION point?
4. What's the voltage at the LOAD?
5. Does the source voltage drop when load is connected? (Points to upstream issue)
6. Is there continuity through the entire power path?

### Red Flags I Missed

- "At the Wago it reads 5V... when I connect the LED it drops" - This told me the problem was upstream of the Wago, not at the strip
- Voltage dropping to exactly 0.6V suggests current limiting through a high-resistance path, not necessarily a short
- User moved connections and different device lost power - this screams "wiring issue" not "device issue"

### The Fix
Moved all connections closer to the power input, bypassing the broken section of the bus. Proper fix would be to locate and repair the break, but workaround is acceptable if everything fits.

---

## General Troubleshooting Principles

### Before Blaming Hardware

1. Test the component in isolation (resistance, continuity)
2. Verify the component is receiving proper power/signals
3. Check all connections to/from the component
4. Rule out wiring issues first

### Systematic Voltage Tracing

For any "not getting power" issue:
```
PSU Output → Fuse → Distribution → Wiring → Device
    ↓          ↓         ↓           ↓         ↓
  Check      Check     Check      Check     Check
  voltage   voltage   voltage   continuity  voltage
            (both      at all                at
            sides)     taps                  device
```

### The 0.6V Clue

When you see ~0.6V under load:
- Could be: Forward voltage of a protection diode (reverse polarity)
- Could be: Voltage drop across a high-resistance connection with current flowing
- Could be: Current-limited supply protecting itself
- NOT necessarily: A short circuit in the load

### Ask Better Questions

Instead of assuming, ask:
- "What changes when you connect/disconnect X?"
- "Does the SOURCE voltage change, or just the load?"
- "Can you measure continuity from point A to point B?"

---

## Notes Format for Future Sessions

When troubleshooting, document as we go:

```
## Issue: [Brief description]
- Symptom: [What user observes]
- Measurement: [Actual readings]
- Hypothesis: [What I think is wrong]
- Test: [How to verify hypothesis]
- Result: [What the test showed]
- Next step: [Based on result]
```

This prevents jumping to conclusions and creates a record of what was tried.
