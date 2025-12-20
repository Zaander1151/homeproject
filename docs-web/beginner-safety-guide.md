# Beginner Electronics Safety Guide

**Your safety matters!** This guide will help you work confidently and safely as you learn electronics.

**Target audience:** Complete beginners with no prior soldering or electronics experience
**Last updated:** 2025-10-30

---

## Core Safety Principles

### The Golden Rules

1. **Never touch the soldering iron tip** - It stays HOT (300-400°C) for 5+ minutes after unplugging
2. **Always wear safety glasses** when cutting wire, soldering, or working with spring-loaded tools
3. **Never work on AC mains voltage (120V)** until you have 10+ successful DC projects completed
4. **Always connect your ESD wrist strap** before handling ESP32 boards or ICs
5. **Unplug your soldering iron** when leaving the workbench (even for "just a minute")
6. **Double-check polarity** before powering any circuit
7. **Never solder near flammable materials** (paper, cloth, aerosols, solvents)
8. **Always have ventilation** when soldering (window open minimum)
9. **Wash your hands** after every soldering session (especially with lead solder)
10. **When in doubt, stop and research** - It's always better to ask than to guess

---

## Soldering Safety

### Fire and Burn Prevention

#### Soldering Iron Temperatures
- **Operating temperature:** 300-400°C (572-752°F)
- **Can melt:** Plastic, skin, cloth instantly
- **Remains hot:** 5-10 minutes after power off
- **Visual cue:** Tip may not glow but is still VERY HOT

#### Safe Practices

**Before You Start:**
- [ ] Clear all flammable materials from workbench (paper, cloth, aerosols)
- [ ] Have soldering iron stand ready and stable
- [ ] Place heat-resistant mat under work area
- [ ] Ensure soldering iron cord won't be pulled or tripped over
- [ ] Have first aid kit accessible (within reach)
- [ ] Know where your fire extinguisher is (or have one nearby)

**During Soldering:**
- [ ] Always place iron in stand when not actively soldering
- [ ] Never leave hot iron unattended (even to answer door/phone)
- [ ] Keep both hands visible - never reach blindly near the iron
- [ ] Route iron cord away from your body and hands
- [ ] Wait 3-5 seconds after removing iron before touching work
- [ ] Warn anyone approaching your workspace that iron is hot

**After Soldering:**
- [ ] Unplug soldering iron immediately when done
- [ ] Place iron in stand and wait 10 minutes before moving
- [ ] Clean tip with brass sponge before final power-off
- [ ] Never put hot iron directly on desk/table (always use stand)
- [ ] Store iron only when completely cool to touch

#### Burn First Aid

**If you touch hot tip or heated component:**
1. Immediately run under cool (not ice cold) water for 5-10 minutes
2. Do NOT apply ice directly (can cause tissue damage)
3. Cover with sterile bandage if skin is broken
4. Take ibuprofen for pain if needed
5. Seek medical attention if:
   - Burn is larger than 2cm diameter
   - Skin is charred or white
   - Blister is very large or painful
   - Burn is on face, hands, or joints

**Most common burn:** Touching component leads immediately after soldering (they stay hot for 30+ seconds)

---

### Fume Safety

#### What's in Solder Fumes?

**Lead solder (60/40):**
- Rosin flux smoke (pine resin, irritating to lungs)
- Lead vapor (minimal, but present)
- Aldehydes (respiratory irritant)

**Lead-free solder:**
- Higher working temperature (more smoke)
- Rosin flux smoke (same as leaded)
- No lead vapor, but still irritating

#### Health Effects
- **Short term:** Eye irritation, coughing, headache, dizziness
- **Long term (poor ventilation):** Respiratory issues, sensitization
- **Lead exposure (without hand washing):** Accumulates in body over time

#### Proper Ventilation

**Minimum Setup (Free):**
- Work near open window
- Position small desk fan to blow fumes away from your face

**Recommended Setup ($30-60):**
- Desktop fume extractor with carbon filter
- Position 6-12 inches from soldering work
- Filter pulls fumes away from your breathing zone

**Professional Setup ($100+):**
- Fume extraction arm with high-CFM fan
- HEPA + activated carbon filtration
- Ducted to outside window

**Warning signs of poor ventilation:**
- Smelling strong rosin smoke during soldering
- Coughing or eye irritation during session
- Headache after 30+ minutes of soldering
- Visible smoke accumulating in room

**Solution:** Improve ventilation immediately. Don't continue soldering in poor conditions.

---

### Lead Safety (If Using Lead Solder)

#### Why Lead Solder?
- **Easier to learn:** Lower melting point (183°C vs 217°C for lead-free)
- **Better flow:** Wets components more easily
- **Shinier joints:** Easier to see good vs bad joints

#### Safe Lead Solder Practices

**During Work:**
- Don't eat, drink, or touch your face while soldering
- Keep food and drinks OFF the workbench
- Wash hands thoroughly with soap after every session

**Cleanup:**
- Wipe down workbench with damp cloth after soldering
- Vacuum or sweep up any solder clippings (don't leave on floor)
- Store solder in container, not loose on desk

**Long-term:**
- Lead exposure is cumulative (builds up over years)
- Primary risk is ingestion (hand-to-mouth), not fumes
- Proper hand washing prevents 99% of lead exposure

**Alternative:** Use lead-free solder (requires higher temperature, slightly harder to learn)

---

## Electrical Safety

### DC Voltage Levels (What You'll Work With)

| Voltage | Risk Level | Examples | Safety Notes |
|---------|------------|----------|--------------|
| **3.3V** | ✅ Safe | ESP32 GPIO pins, sensors | Cannot feel, very safe |
| **5V** | ✅ Safe | USB power, Arduino | Cannot feel, very safe |
| **9V** | ✅ Safe | 9V battery | Tongue tingle only |
| **12V** | ✅ Mostly safe | LED strips, automotive | Can feel, harmless |
| **24V** | ⚠️ Caution | Industrial sensors | Perceptible, startling |
| **48V** | ⚠️ Caution | PoE devices | Can be painful |
| **120V AC** | ⛔ DANGEROUS | Mains power | LETHAL - avoid until experienced |

**Your first 10-20 projects will use 3.3V and 5V exclusively.** These are completely safe to touch.

### DC Project Safety

#### Before Powering On
- [ ] Double-check polarity (red = positive, black = ground)
- [ ] Verify no short circuits (use multimeter continuity test)
- [ ] Ensure ESP32 is plugged in correct orientation
- [ ] Check that voltage matches component specs (don't power 3.3V device with 5V)
- [ ] Inspect breadboard connections (no loose wires touching)

#### Common Mistakes (and How to Avoid Them)

**Reversed Polarity:**
- **Symptom:** Component gets very hot immediately, magic smoke
- **Prevention:** Always connect red to +, black to - or GND
- **Fix:** Immediately unplug power, check wiring diagram

**Short Circuit:**
- **Symptom:** Power supply shuts off, wire gets hot, sparks
- **Prevention:** Use continuity test before powering on
- **Fix:** Unplug immediately, inspect for crossed wires

**Overvoltage:**
- **Symptom:** Component dies silently or smokes
- **Prevention:** Verify sensor/component voltage rating (3.3V vs 5V)
- **Example:** ESP32 GPIO is 3.3V - don't connect directly to 5V sensor without level shifter

**Exceeding Current Limits:**
- **Symptom:** ESP32 reboots randomly, USB port shuts off
- **Prevention:** ESP32 GPIO pins max 40mA total, use transistors/MOSFETs for high-current loads
- **Example:** Don't power LED strip directly from GPIO (use relay or MOSFET)

---

### AC Mains Voltage (120V) - FOR FUTURE REFERENCE ONLY

**DO NOT attempt AC projects until:**
- ✅ You've completed 10+ successful DC projects
- ✅ You understand voltage, current, and resistance deeply
- ✅ You've researched Canadian Electrical Code basics
- ✅ You have proper enclosures and strain relief
- ✅ You've watched professional tutorials on AC wiring safety

#### Why AC is Dangerous
- **120V AC can kill** - even small currents (30mA) can cause cardiac arrest
- **AC contracts muscles** - can't let go of energized conductor
- **Current takes path through heart** - hand-to-hand contact especially dangerous

#### When You're Ready for AC Projects
**Safe practices:**
1. Always use GFCI outlets (trip in 4-6ms on ground fault)
2. Work on unpowered circuits only (unplug while wiring)
3. Use proper strain relief on cords
4. Mount relays in grounded metal or plastic enclosures
5. Never expose AC terminals (always covered/enclosed)
6. Get professional electrician's guidance for first AC project
7. Understand neutral vs hot vs ground

**Recommended first AC project:**
- Smart plug with pre-made relay module (Sonoff, Shelly)
- Modify existing device rather than building from scratch
- Keep all wiring enclosed, only connect DC control signals

---

## ESD (Electrostatic Discharge) Safety

### Why ESD Matters

**You can't feel static discharge below 3,000V**
- Walking across carpet: 10,000-35,000V
- Sitting in chair: 1,500-5,000V
- Picking up plastic bag: 5,000-20,000V

**ESP32 chips can be damaged by 100V**
- You won't feel it, but chip dies silently
- Symptom: Board doesn't work, no obvious reason
- Prevention: ESD mat + wrist strap

### Proper ESD Protection

#### Setup
1. Place ESD mat on workbench
2. Connect mat's ground snap to:
   - **Best:** Ground plug on AC outlet (via ground cord)
   - **Good:** Metal workbench leg (if conductive)
   - **Okay:** Large metal object (radiator, water pipe)
3. Connect wrist strap to ground snap
4. Wear wrist strap snugly around wrist

#### When to Use
- [ ] Any time you handle ESP32 boards (unpowered)
- [ ] When handling ICs, sensors, or static-sensitive components
- [ ] When plugging/unplugging boards from breadboard

#### When NOT Needed
- [ ] Working with soldering iron (could conduct heat)
- [ ] Handling passive components (resistors, capacitors, LEDs)
- [ ] Working on powered circuits (safety issue - disconnect strap)

#### Common ESD Mistakes
- ❌ Touching ESP32 GPIO pins with bare hands (discharge path)
- ❌ Setting board on carpet, plastic, or styrofoam
- ❌ Working in dry room with no humidity control (winter months)
- ❌ Wearing synthetic fleece or wool clothing (high static generation)

**Good habits:**
- ✅ Touch ESD mat before picking up ESP32
- ✅ Store boards in anti-static bags when not in use
- ✅ Keep workspace humidity 40-60% (prevents static buildup)

---

## Tool Safety

### Soldering Iron
- **Risk:** Severe burns, fire hazard
- **Safe use:** Always in stand when not in hand, unplug when leaving workbench
- **PPE:** None required for soldering itself, safety glasses for nearby cutting

### Wire Cutters/Strippers
- **Risk:** Pinched fingers, flying wire pieces
- **Safe use:** Cut away from body, wear safety glasses
- **Common injury:** Wire end flying into eye (happens fast!)

### Needle Nose Pliers
- **Risk:** Pinched fingers, hand fatigue
- **Safe use:** Don't over-squeeze (can break plier tips)

### Tweezers
- **Risk:** Minimal (poked fingers)
- **Safe use:** Sharp-tipped tweezers can puncture skin

### Multimeter
- **Risk:** Electric shock if used on AC mains
- **Safe use:** For DC circuits under 50V only (as beginner)
- **Never:** Touch live AC circuits with meter probes

### Bench Power Supply
- **Risk:** Short circuit sparks, overvoltage damage
- **Safe use:** Set voltage BEFORE connecting to circuit, use current limiting

### Hobby Knife
- **Risk:** Cuts (very common!)
- **Safe use:** Always cut AWAY from body, use cutting mat
- **PPE:** Consider cut-resistant gloves for heavy stripping work

---

## Workspace Safety

### Fire Safety

#### Prevention
- [ ] No flammable materials within 12" of soldering iron
- [ ] No aerosols (spray paint, air duster) near hot iron or sparks
- [ ] Solder over heat-resistant mat (not paper, wood, cloth)
- [ ] Unplug iron when leaving workspace
- [ ] Don't overload power strips (max 1500W per strip)

#### Fire Extinguisher
- **Type:** ABC (all-purpose) or BC (electrical)
- **Location:** Within 10 feet of workbench
- **Size:** 5lb minimum
- **Check:** Monthly pressure gauge inspection

#### Smoke Detector
- Install in workspace room
- Test monthly
- Replace battery annually

#### What to Do if Fire Starts
1. **Small fire (component):** Unplug power, smother with mat
2. **Medium fire (board/wire):** Use fire extinguisher, evacuate
3. **Large fire:** Evacuate immediately, call 911

**Never:** Use water on electrical fire (use extinguisher)

---

### First Aid

**Keep in workspace:**
- [ ] Adhesive bandages (10-20 count)
- [ ] Burn gel or aloe vera
- [ ] Sterile gauze pads
- [ ] Medical tape
- [ ] Antiseptic wipes
- [ ] Tweezers (for splinters)
- [ ] Ice pack

**For serious injuries:**
- Call 911 (fire, severe burns, electric shock)
- Know your address for emergency services
- Keep phone charged and accessible

---

### Ergonomics

**Prevent repetitive strain injury:**
- Adjust chair height so elbows at 90°
- Take breaks every 45-60 minutes
- Stretch hands and wrists
- Use magnifying lamp to avoid hunching
- Adequate lighting (no eye strain)

**Signs of overuse:**
- Wrist pain (take break, use wrist support)
- Eye strain (improve lighting, use magnification)
- Back pain (check posture, chair height)

---

## Chemical Safety

### Solder Flux
- **Irritant:** Skin, eyes, respiratory
- **Handling:** Avoid prolonged skin contact, wash hands after use
- **Fumes:** Ventilation required

### Isopropyl Alcohol (90%+ for cleaning PCBs)
- **Flammable:** Keep away from heat/sparks
- **Irritant:** Skin, eyes (wear gloves for prolonged use)
- **Ventilation:** Use in well-ventilated area
- **Storage:** Sealed container, away from soldering iron

### Acetone (if used for cleaning)
- **Flammable:** Highly flammable, keep away from open flame
- **Irritant:** Skin, eyes, respiratory
- **Dissolves plastic:** Don't use on ESP32 boards or plastic enclosures

### Tip Tinner/Cleaner
- **Corrosive:** Contains acidic flux
- **Handling:** Use only on hot iron tip, avoid skin contact
- **Storage:** Sealed container

**General chemical safety:**
- Read MSDS (Material Safety Data Sheet) before use
- Store in original labeled containers
- Keep out of reach of children and pets
- Dispose properly (follow local hazardous waste guidelines)

---

## Common Beginner Mistakes (And How to Avoid Them)

### "I touched the hot tip!"
- **Why:** Muscle memory from pens/pencils (we hold near tip)
- **Prevention:** Always grip iron by handle only, never near tip
- **Habit:** Train yourself to place iron in stand after every solder joint

### "I burned my finger on a component!"
- **Why:** Just-soldered components stay hot 30-60 seconds
- **Prevention:** Wait before touching, or use tweezers to test temperature
- **Habit:** Touch ESD mat before touching components (cools hands and discharges static)

### "My ESP32 doesn't work anymore!"
- **Likely causes:** ESD damage, reversed polarity, overvoltage
- **Prevention:** Always use wrist strap, double-check wiring, verify voltage
- **Good news:** ESP32 boards are $5-7, part of learning process

### "I inhaled a lot of solder smoke!"
- **Why:** Working too close to fumes, poor ventilation
- **Prevention:** Fume extractor or fan, work 12-18" from work, window open
- **If it happens:** Go outside for fresh air, drink water, stop soldering for day

### "I can't get the solder to flow!"
- **Likely causes:** Tip not hot enough, dirty tip, wrong solder type
- **Prevention:** Temperature at 350°C for leaded (400°C for lead-free), clean tip often
- **Safety note:** Don't increase temperature excessively (damages tip, more fumes)

### "I created a short circuit!"
- **Why:** Breadboard wiring mistake, solder bridge
- **Prevention:** Use continuity test before powering, inspect joints carefully
- **If it happens:** Unplug immediately, use multimeter to find short

---

## Daily Safety Checklist

### Before Starting Work
- [ ] Workspace clear of clutter and flammable materials
- [ ] Soldering iron stand stable and positioned correctly
- [ ] ESD mat connected and wrist strap within reach
- [ ] Safety glasses on desk
- [ ] Fire extinguisher accessible
- [ ] Phone charged (in case of emergency)
- [ ] Adequate ventilation (window open or fan on)
- [ ] Lighting sufficient (no eye strain)

### During Work
- [ ] Soldering iron in stand when not in hand
- [ ] Wrist strap connected when handling ESP32
- [ ] Components allowed to cool before touching
- [ ] Taking breaks every 45-60 minutes
- [ ] Maintaining good posture

### After Work
- [ ] Soldering iron unplugged
- [ ] All power supplies and tools unplugged
- [ ] Hot iron in stand cooling (10+ minutes)
- [ ] Workspace cleaned (wire clippings, flux residue)
- [ ] Components stored in anti-static bags
- [ ] Hands washed (especially if using lead solder)
- [ ] Tools returned to proper storage

---

## When to Ask for Help

**Stop immediately and research/ask if:**
- You smell burning (not flux) - like plastic, insulation, or wood
- You see sparks or smoke from powered circuit
- You feel ANY shock from a DC circuit (even 12V - indicates problem)
- Component becomes too hot to touch within seconds of powering on
- You're unsure about AC mains wiring or voltage
- You experience dizziness, headache, or nausea while soldering

**Resources for help:**
- r/AskElectronics (Reddit)
- r/esp32 (Reddit)
- Home Assistant forums
- ESPHome Discord
- Local makerspace or electronics club

**Never feel embarrassed to ask basic questions.** Everyone was a beginner once, and the community is very helpful.

---

## Safety Graduation Checklist

**You're ready for intermediate projects when you can:**
- [ ] Solder 10+ through-hole joints cleanly without burns or mistakes
- [ ] Identify voltage levels and polarity without hesitation
- [ ] Use multimeter confidently (voltage, continuity, resistance)
- [ ] Build circuits from schematic diagrams
- [ ] Debug simple circuit problems independently
- [ ] Maintain safe workspace habits automatically (no reminders needed)

**You're ready for AC mains projects when you can:**
- [ ] Completed 20+ DC projects successfully
- [ ] Understand voltage, current, resistance, and Ohm's law deeply
- [ ] Read and understand Canadian Electrical Code basics
- [ ] Identify neutral, hot, and ground wires by color and function
- [ ] Explain why GFCI is critical for safety
- [ ] Built proper enclosures for all projects
- [ ] Received guidance from experienced electrician or EE

---

## Emergency Contacts

**Keep these numbers accessible:**
- **Fire/Medical Emergency:** 911
- **Poison Control:** 1-800-222-1222 (if ingested chemicals)
- **Non-emergency (burn/injury advice):** Your doctor or Telehealth Ontario (1-866-797-0000)

**Have this information ready for 911:**
- Your address: _______________________
- Nearest cross street: _______________________
- Description of emergency
- Any relevant medical conditions

---

## Summary: The Most Important Safety Rules

1. **Soldering iron tip is HOT** - Always in stand, unplug when done
2. **Ventilation matters** - Window open or fume extractor
3. **Wash hands after soldering** - Especially with lead solder
4. **ESD protection** - Wrist strap for ESP32 work
5. **Check polarity** - Red = +, Black = GND
6. **Start with DC** - Master 3.3V/5V before AC mains
7. **Safety glasses** - When cutting wire or soldering overhead
8. **Take breaks** - Prevent fatigue errors
9. **Ask questions** - Community is helpful
10. **Have fun safely!** - Confidence comes with practice

---

**Remember:** Safety isn't about being scared—it's about being prepared. With proper precautions, electronics is a very safe and rewarding hobby. You've got this! 🔒⚡

**Next step:** Review this guide, then read `/home/hazzard/homeproject/docs/my-electronics-lab-plan.md` to start ordering your equipment!
