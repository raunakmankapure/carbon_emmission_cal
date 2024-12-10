# carbon_emission_calculator

A new Flutter project made for ride buddy app

🔴 Short demo of features and calculations :
https://github.com/user-attachments/assets/a2798849-71fc-4bb5-8fe3-0de5c7d880f2

It is a Flutter-based application that calculates environmental and financial impact based on ride-sharing and trip data. It empowers users to track carbon emissions, assess eco-impact, and achieve sustainability goals through intuitive metrics and engaging features.

---

## Key Features

### **Emissions Calculator**
- **Customizable Calculation**: Calculates carbon emissions based on trip parameters:
  - Distance traveled
  - Type of fuel (Petrol, Diesel, or Electric Vehicle)
  - Traffic conditions (Light, Moderate, Heavy)
  - Idle time during the trip
  - Time of the day (Day/Night)
  - Number of riders (emissions are shared among riders)
- **Scientific Adjustments**:
  - Traffic conditions and fuel type affect emission rates.
  - Night trips benefit from a reduction factor.

### **Eco Sidebar**
- **Impact Summary**:
  - **Money Saved**: Calculates financial savings based on emission reduction.
  - **Water Conserved**: Represents savings in liters based on emissions.
  - **Energy Saved**: Displays energy savings in kWh.
- **Progress Tracking**:
  - Tracks progress toward a **Carbon Reduction Goal** (e.g., 1-ton reduction).
  - Progress is visually represented using a progress bar.
- **Achievements**:
  - Unlock badges for milestones: Beginner, Regular, and Expert.
  - Badges are dynamic and visually engaging.

### **UI / UX**
- Dark and light theme mode
- Splash screen, animations and many more used in ridebuddy
- Google fonts for making the best UI

### Deletion and UNDO feature
- For delete any trip record from the homescreen **swipe left**. 
- For bringing back the deleted record there is option have **UNDO** is there.
 

### **Motivational Engagement**
- Milestone-based messages and motivational quotes inspire users to continue reducing their carbon footprint.

---

## Solution & Logic

The application combines real-world emission factors and calculations with an engaging user interface to drive sustainability. 

### **Emissions Calculation**
1. **Formula**:
   - Base Emission Rate: `distance × baseEmissionRate`
   - Adjustments: Multipliers for fuel type and traffic conditions.
   - Idle Emissions: `idleTime × idleEmissionsPerMinute`
   - Nighttime Reduction: 5% reduction for trips during night hours.
   - Shared Rides: Emissions are proportionately reduced based on the number of riders.

2. **Implementation**:
   - **Fuel Multiplier**: Diesel increases emissions by 15%, EVs contribute 0 emissions.
   - **Traffic Multiplier**: Heavy traffic adds 20% more emissions.
   - **Idle Emissions**: Accounts for emissions while idling.

### **Savings Calculation**
- **Money Saved**: ₹0.15 saved per gram of reduced emissions.
- **Water and Energy Saved**: Simple multipliers based on total emissions (0.5L and 0.3 kWh per gram, respectively).

### **Achievements & Goals**
- Progress toward a carbon reduction goal is tracked as a percentage.
- Achievements (Beginner, Regular, Expert) are unlocked based on the number of trips.

---

## How to Run the Project

### Prerequisites
- Flutter SDK installed
- `pubspec.yaml` dependencies resolved
- flutter run
- 

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/raunakmankapure/carbon_emmission_cal
   cd file_name
   flutter pub get
