from fastapi import FastAPI, HTTPException #http is used for get,post,put/delete-communication btw dart and python. #fastapi-talks from python to flutter using http
from pydantic import BaseModel #input quality checker which makes sure no required fields r missing, is structured correctly and has the right types.
import openpyxl #bridge that lets Python understand and extract data from Excel spreadsheets.
import json #used to store text files like dictionaries or lists
import os #lets python interact with operation systems. e.g.windows,macOS,Linux
from typing import List, Dict, Optional 
from geopy.distance import geodesic #used to calculate the shortest distance btw two point on the earth, using latitude and longitude
from geopy.geocoders import Nominatim #converting a place name like "Germany" into latitude and longtiude coordinates

                #1.File Storage Setup#

#Function to locate where user data is stored on their system
def get_user_data_path(filename):
    # Same pattern used in SPHERE.py to put profiles & factors in a user data dir :contentReference[oaicite:1]{index=1}
    if os.name == "nt":  # Windows
        base = os.path.join(os.environ.get("LOCALAPPDATA", os.path.expanduser("~")), "SPHERE")
    else:  # macOS/Linux
        base = os.path.join(os.path.expanduser("~"), ".sphere")
    os.makedirs(base, exist_ok=True)
    return os.path.join(base, filename)

# Define file names
PROFILE_FILE = get_user_data_path("profiles.json")
EMISSION_FACTORS_FILE = get_user_data_path("custom_emission_factors.json")

# Make sure required files exist    
def ensure_default_files():
    if not os.path.exists(EMISSION_FACTORS_FILE):
        with open(EMISSION_FACTORS_FILE, "w", encoding="utf-8") as f:
            json.dump({}, f)
    if not os.path.exists(PROFILE_FILE):
        with open(PROFILE_FILE, "w", encoding="utf-8") as f:
            json.dump({}, f)

ensure_default_files()

# Functions to load and save profile data
def load_profiles() -> Dict[str, dict]:
    if os.path.exists(PROFILE_FILE):
        with open(PROFILE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

def save_profiles(profiles: Dict[str, dict]):
    with open(PROFILE_FILE, "w", encoding="utf-8") as f:
        json.dump(profiles, f, indent=2)

def load_custom_emission_factors():
    if os.path.exists(EMISSION_FACTORS_FILE):
        with open(EMISSION_FACTORS_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

def save_custom_emission_factors(data):
    with open(EMISSION_FACTORS_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

custom_emission_factors = load_custom_emission_factors()

# 2. LOAD EXCEL DATA

# Open the Excel workbook
# Assumption: "Emission Data.xlsx" sits next to backend.py
EXCEL_PATH = os.path.join(os.path.dirname(__file__), "Emission Data.xlsx")
book = openpyxl.load_workbook(EXCEL_PATH, data_only=True)

# Load each sheet that SPHERE uses
sheet  = book['Data Sheet']
sheet2 = book['Transport']
sheet3 = book['Transport WTT']
sheet4 = book['Machine Types']
sheet5 = book['Recycling']
sheet6 = book['Packaging']

# Helper functions to read values from Excel columns
def extract_selection_list(cells):
    """Stops reading when it finds an empty cell."""
    values = []
    for cell in cells:
        value = cell[0].value if cell[0].value is not None else ""
        value = value.strip() if isinstance(value, str) else value
        if value == "" or value is None:
            break
        values.append(value)
    return values

def extract_list(cells):
    """Reads all values regardless of blanks."""
    values = []
    for cell in cells:
        value = cell[0].value if cell[0].value is not None else ""
        values.append(value)
    return values

def extract_transport_list(cells):
    # SPHERE stops when it hits blank for transport types :contentReference[oaicite:2]{index=2}
    values = []
    for cell in cells:
        value = cell[0].value if cell[0].value is not None else ""
        if value == "":
            break
        values.append(value)
    return values

def extract_emission_list(cells):
    values = []
    for cell in cells:
        value = cell[0].value
        if value is None or str(value).strip() == "":
            break
        try:
            values.append(float(value))
        except Exception:
            values.append("N/A")
    return values

# pull columns from workbook (exact same cells used in SPHERE.py) :contentReference[oaicite:3]{index=3}
country_cells        = sheet['A2':'A999']
distance_cells       = sheet['B2':'B999']
steel_cells          = sheet['C2':'C999']
aluminium_cells      = sheet['D2':'D999']
cement_cells         = sheet['E2':'E999']
electricity_cells    = sheet['F2':'F999']
plastic_cells        = sheet['G2':'G999']
carbon_fiber_cells   = sheet['H2':'H999']

Transport_cells      = sheet2['A2':'A999']

van_cells            = sheet3['B2':'B5']
van_diesel_cells     = sheet3['D2':'D5']
van_petrol_cells     = sheet3['E2':'E5']
van_battery_cells    = sheet3['F2':'F5']

HGV_diesel_cells     = sheet3['B8':'B15']
HGV_0_diesel_cells   = sheet3['D8':'D15']
HGV_50_diesel_cells  = sheet3['E8':'E15']
HGV_100_diesel_cells = sheet3['F8':'F15']

HGV_R_diesel_cells     = sheet3['B17':'B24']
HGV_R_0_diesel_cells   = sheet3['D17':'D24']
HGV_R_50_diesel_cells  = sheet3['E17':'E24']
HGV_R_100_diesel_cells = sheet3['F17':'F24']

flight_cells           = sheet3['B27':'B29']
Int_flight_cells       = sheet3['D27':'D27']
L_1500_flight_cells    = sheet3['E27':'E29']
M_1500_flight_cells    = sheet3['F27':'F29']

rail_cells             = sheet3['B31':'B31']
freight_train_cells    = sheet3['D31':'D31']

sea_tanker_cells       = sheet3['G34':'G38']
crude_tanker_cells     = sheet3['C34':'C40']
products_tanker_cells  = sheet3['C41':'C46']
chemical_tanker_cells  = sheet3['C47':'C51']
LNG_tanker_cells       = sheet3['C52':'C54']
LPG_tanker_cells       = sheet3['C55':'C57']

crude_value_cells      = sheet3['E34':'E40']
products_value_cells   = sheet3['E41':'E46']
chemical_value_cells   = sheet3['E47':'E51']
LNG_value_cells        = sheet3['E52':'E54']
LPG_value_cells        = sheet3['E55':'E57']

cargo_cells            = sheet3['G60':'G64']
bulk_value_cells       = sheet3['E59':'E65']
general_value_cells    = sheet3['E66':'E72']
container_value_cells  = sheet3['E73':'E79']
vehicle_value_cells    = sheet3['E80':'E82']
roro_value_cells       = sheet3['E83':'E85']

machine_value_cells                 = sheet4['A2':'A999']
specific_machine_energy_use_cells   = sheet4['B2':'B999']

metal_recycling_types_cells    = sheet5['A2':'A999']
metal_recycling_emission_cells = sheet5['B2':'B999']

packaging_types_cells    = sheet6['A2':'A999']
packaging_box_frame_cells = sheet6['B2':'B999']

# turn into lists
country_list      = extract_selection_list(country_cells)
distance_list     = extract_list(distance_cells)
steel_list        = extract_list(steel_cells)
aluminium_list    = extract_list(aluminium_cells)
cement_list       = extract_list(cement_cells)
electricity_list  = extract_list(electricity_cells)
plastic_list      = extract_list(plastic_cells)
carbon_fiber_list = extract_list(carbon_fiber_cells)

transport_list    = extract_transport_list(Transport_cells)

van_list          = extract_list(van_cells)
van_diesel_list   = extract_list(van_diesel_cells)
van_petrol_list   = extract_list(van_petrol_cells)
van_battery_list  = extract_list(van_battery_cells)

# (note: we’re loading the HGV/ship/flight/etc. lists too in case you expand modes later)
HGV_diesel_list     = extract_list(HGV_diesel_cells)
HGV_0_diesel_list   = extract_list(HGV_0_diesel_cells)
HGV_50_diesel_list  = extract_list(HGV_50_diesel_cells)
HGV_100_diesel_list = extract_list(HGV_100_diesel_cells)

HGV_R_diesel_list     = extract_list(HGV_R_diesel_cells)
HGV_R_0_diesel_list   = extract_list(HGV_R_0_diesel_cells)
HGV_R_50_diesel_list  = extract_list(HGV_R_50_diesel_cells)
HGV_R_100_diesel_list = extract_list(HGV_R_100_diesel_cells)

flight_list        = extract_list(flight_cells)
Int_flight_list    = extract_list(Int_flight_cells)
L_1500_flight_list = extract_list(L_1500_flight_cells)
M_1500_flight_list = extract_list(M_1500_flight_cells)

rail_list              = extract_list(rail_cells)
freight_train_rail_list = extract_list(freight_train_cells)

sea_tanker_list     = extract_list(sea_tanker_cells)
crude_tanker_list   = extract_list(crude_tanker_cells)
products_tanker_list = extract_list(products_tanker_cells)
chemical_tanker_list = extract_list(chemical_tanker_cells)
LNG_tanker_list     = extract_list(LNG_tanker_cells)
LPG_tanker_list     = extract_list(LPG_tanker_cells)

crude_value_list     = extract_list(crude_value_cells)
products_value_list  = extract_list(products_value_cells)
chemical_value_list  = extract_list(chemical_value_cells)
LNG_value_list       = extract_list(LNG_value_cells)
LPG_value_list       = extract_list(LPG_value_cells)

cargo_list          = extract_list(cargo_cells)
bulk_value_list     = extract_list(bulk_value_cells)
general_value_list  = extract_list(general_value_cells)
container_value_list = extract_list(container_value_cells)
vehicle_value_list   = extract_list(vehicle_value_cells)
roro_value_list      = extract_list(roro_value_cells)

machine_value_list               = extract_selection_list(machine_value_cells)
specific_machine_energy_use_list = extract_list(specific_machine_energy_use_cells)

metal_recycling_types_list    = extract_selection_list(metal_recycling_types_cells)
metal_recycling_emission_list = extract_emission_list(metal_recycling_emission_cells)

packaging_types_list          = extract_selection_list(packaging_types_cells)
packaging_box_frame_list      = extract_emission_list(packaging_box_frame_cells)

materials = ["Steel", "Aluminium", "Cement", "Plastic", "Carbon Fiber"]  # SPHERE globals :contentReference[oaicite:4]{index=4}

###############################################################################
# --------- 3. GEODATA CACHE (used by transport + sourcing) ------------------#
###############################################################################

def build_country_coords_cache(country_list_input):
    geolocator = Nominatim(user_agent="emission_app_backend")  # similar to SPHERE usage :contentReference[oaicite:5]{index=5}
    cache = {}
    for country in country_list_input:
        try:
            loc = geolocator.geocode(country, timeout=5)
            if loc:
                cache[country] = (loc.latitude, loc.longitude)
            else:
                cache[country] = None
        except Exception:
            cache[country] = None
    return cache

country_coords_cache = build_country_coords_cache(country_list)

###############################################################################
# --------- 4. PURE CALC HELPERS (ported/adapted from SPHERE.py) -------------#
###############################################################################

# ---------- Material Emissions ----------

def get_material_emission(material: str, country_index: int) -> float:
    """
    Return CO2e/kg for a given material in a given country.
    Uses custom_emission_factors first if present. :contentReference[oaicite:6]{index=6}
    """
    material_lists = {
        "Steel": steel_list,
        "Aluminium": aluminium_list,
        "Cement": cement_list,
        "Plastic": plastic_list,
        "Carbon Fiber": carbon_fiber_list,
    }

    # custom override (user-edited factors saved to disk in SPHERE.py) :contentReference[oaicite:7]{index=7}
    override = custom_emission_factors.get("materials", {}).get(material)
    if override is not None:
        return float(override)

    base_list = material_lists.get(material)
    if base_list is None:
        raise ValueError(f"Unknown material {material}")
    raw_val = base_list[country_index]
    return float(str(raw_val).strip())


def calc_raw_material_emission(
    material: str,
    manufacturing_country: str,
    weight_kg: float,
    quantity: int
) -> float:
    """
    Total CO2e from raw material only.
    SPHERE multiplies emission_factor * total_weight. :contentReference[oaicite:8]{index=8}
    """
    if manufacturing_country not in country_list:
        raise ValueError(f"{manufacturing_country} not in known country_list")
    cidx = country_list.index(manufacturing_country)

    per_kg_factor = get_material_emission(material, cidx)
    total_weight = weight_kg * quantity
    return per_kg_factor * total_weight


# ---------- Transport Emissions ----------

def calc_transport_emission(
    origin_country: str,
    dest_country: str,
    total_weight_kg: float,
    emission_factor_per_ton_km: float = 0.01,
):
    """
    SPHERE uses geodesic distance between origin and destination countries, then:
      transport_emission = total_weight * distance_km * factor / 1000
    where factor is CO2e per ton-km. :contentReference[oaicite:9]{index=9}
    """
    ocoords = country_coords_cache.get(origin_country)
    dcoords = country_coords_cache.get(dest_country)
    if not ocoords or not dcoords:
        return None

    distance_km = geodesic(ocoords, dcoords).km
    transport_emission = (
        total_weight_kg * distance_km * emission_factor_per_ton_km / 1000.0
    )
    return {
        "distance_km": distance_km,
        "transport_emission": transport_emission
    }


# ---------- Machine Process Emissions ----------

def calc_machine_emission(
    machine_rows: List[dict],
    manufacturing_country: str,
    weight_after_kg: float,
    weight_after_qty: int,
):
    """
    Mirrors SPHERE row calc:
    emission = energy_use * weight_after * weight_after_qty * (machining_time/60) * electricity_emission
    (see SPHERE: it calculates kWh * hr * kg * electricity factor per country). :contentReference[oaicite:10]{index=10}
    """
    if manufacturing_country not in country_list:
        raise ValueError(f"{manufacturing_country} not in country list")
    cidx = country_list.index(manufacturing_country)

    electricity_emission_factor = float(electricity_list[cidx])

    total_emission = 0.0
    details = []

    for row in machine_rows:
        machine_type = row.get("machine_type", "")
        machining_time_min = float(row.get("machining_time", 0) or 0)

        # look up per-machine energy_use from Excel list
        if machine_type in machine_value_list:
            m_idx = machine_value_list.index(machine_type)
            energy_use = float(specific_machine_energy_use_list[m_idx])
        else:
            energy_use = 0.0  # unknown machine: treat as 0 for now

        emission = (
            energy_use
            * weight_after_kg
            * weight_after_qty
            * (machining_time_min / 60.0)
            * electricity_emission_factor
        )

        total_emission += emission
        details.append({
            "machine_type": machine_type,
            "machining_time_min": machining_time_min,
            "energy_use": energy_use,
            "emission": emission,
        })

    return total_emission, details


# ---------- Packaging Emissions ----------

def calc_packaging_emission(
    packaging_type: Optional[str],
    weight_after_kg: float
):
    """
    SPHERE-style packaging calc:
    factor (g CO2e/kg?) * weight_after / 1000.0 -> kg CO2e.
    From packaging_box_frame_list. :contentReference[oaicite:11]{index=11}
    """
    if not packaging_type:
        return 0.0

    norm = packaging_type.strip().lower()
    normalized_types = [t.strip().lower() for t in packaging_types_list]

    if norm in normalized_types:
        i = normalized_types.index(norm)
        val = packaging_box_frame_list[i]
        if val == "N/A":
            return 0.0
        factor = float(val)
        return factor * weight_after_kg / 1000.0
    return 0.0


# ---------- Recycling Emissions ----------

def calc_recycling_emission(
    recycling_type: str,
    total_weight_after_kg: float,
):
    """
    Uses sheet5 ('Recycling') which SPHERE loads into:
      metal_recycling_types_list and metal_recycling_emission_list :contentReference[oaicite:12]{index=12}

    The UI has a dropdown like 'metal_recycling_dropdown' and includes this
    value in saved profiles (metal_recycling_dropdown in SPHERE.py). :contentReference[oaicite:13]{index=13}

    We'll mirror the typical pattern:
      recycling_emission = factor_per_kg * total_weight_after_kg
    If factor is "N/A", treat as 0.
    """
    norm = recycling_type.strip().lower()
    normalized_types = [t.strip().lower() for t in metal_recycling_types_list]

    if norm not in normalized_types:
        return 0.0

    idx = normalized_types.index(norm)
    factor = metal_recycling_emission_list[idx]  # could be float or "N/A"
    if factor == "N/A":
        return 0.0
    return float(factor) * total_weight_after_kg


# ---------- Business Travel Emissions ----------

def calc_business_travel_row(row: dict):
    """
    SPHERE's Business Travel UI collects:
      transport (e.g. Van),
      variation (specific van type),
      fuel ('Diesel', 'Petrol', 'Battery'),
      origin, destination, mode ('driving', 'plane', 'ship', etc.)
      and shows 'Total Emission: X CO2eKg' per row. :contentReference[oaicite:14]{index=14}

    The workbook sheet3 ('Transport WTT') has lists like:
    - van_list and van_diesel_list / van_petrol_list / van_battery_list
    which look like emission factors for van variants. :contentReference[oaicite:15]{index=15}

    We'll reconstruct a reasonable rule:
      1. If transport is "Van":
         - pick variation index from van_list
         - pick fuel list (diesel/petrol/battery)
         - get factor_per_km from the matching list
      2. Compute distance between origin/destination using geodesic.
      3. emission = factor_per_km * distance_km

    NOTE: If we can't geocode origin/destination, we return 0 for that row.
    """

    transport_type = (row.get("transport") or "").strip()
    variation     = (row.get("variation") or "").strip()
    fuel          = (row.get("fuel") or "").strip()
    origin        = (row.get("origin") or "").strip()
    destination   = (row.get("destination") or "").strip()

    # 1. figure out factor_per_km
    factor_per_km = 0.0

    if transport_type.lower() == "van":
        # Find which van variant index this is
        if variation in van_list:
            i = van_list.index(variation)

            if fuel.lower() == "diesel" and i < len(van_diesel_list):
                factor_per_km = safe_float(van_diesel_list[i])
            elif fuel.lower() == "petrol" and i < len(van_petrol_list):
                factor_per_km = safe_float(van_petrol_list[i])
            elif fuel.lower() == "battery" and i < len(van_battery_list):
                factor_per_km = safe_float(van_battery_list[i])
        # else: could expand to HGV, flights, etc., in future, based on
        # HGV_*_list, flight_list, etc. from sheet3.

    # 2. distance
    distance_km = geocode_distance_km(origin, destination)

    # 3. total emission
    row_emission = factor_per_km * distance_km

    return {
        "distance_km": distance_km,
        "emission": row_emission,
        "factor_per_km": factor_per_km,
    }


def geocode_distance_km(origin: str, destination: str) -> float:
    """
    Helper to geocode 2 text locations and return geodesic distance in km.
    Similar to how SPHERE geocodes countries for transport. :contentReference[oaicite:16]{index=16}
    """
    if not origin or not destination:
        return 0.0

    geolocator = Nominatim(user_agent="emission_app_business_travel")
    try:
        loc_o = geolocator.geocode(origin, timeout=5)
        loc_d = geolocator.geocode(destination, timeout=5)
    except Exception:
        return 0.0

    if not loc_o or not loc_d:
        return 0.0

    return geodesic((loc_o.latitude, loc_o.longitude),
                    (loc_d.latitude, loc_d.longitude)).km


def safe_float(x):
    try:
        return float(x)
    except Exception:
        return 0.0


# ---------- Machine Optimization ("Pareto suggestion") ----------

# SPHERE builds `allowed_machine_substitutions` so CNC machines can swap
# between similar CNCs, others can't, then checks which emits less for the
# same machining time and weight. :contentReference[oaicite:17]{index=17}
non_substitutable = [
    "Surface Grinder (S.G)",
    "Wire Cut (W/C)",
    "Rokou Roku Micro Fine Precision Machine Center"
]
cnc_names = [
    "CNC (RB8)",
    "CNC (YCM4)",
    "CNC (YCM1)"
]
cnc_machines = [m for m in machine_value_list if m in cnc_names]

allowed_machine_substitutions = {}
for m in machine_value_list:
    if m in non_substitutable:
        allowed_machine_substitutions[m] = []
    elif m in cnc_machines:
        allowed_machine_substitutions[m] = [x for x in cnc_machines if x != m]
    else:
        allowed_machine_substitutions[m] = []

def suggest_optimal_machine(
    current_machine: str,
    machining_time_min: float,
    weight_after_kg: float,
    weight_after_qty: int,
    manufacturing_country: str,
):
    """
    Mirrors SPHERE.suggest_optimal_machine():
      - compute emission of current machine
      - test allowed substitutes
      - return best machine + its emission. :contentReference[oaicite:18]{index=18}
    """
    if manufacturing_country not in country_list:
        raise ValueError("Unknown manufacturing_country")
    cidx = country_list.index(manufacturing_country)

    def machine_emission(machine_name: str) -> float:
        if machine_name not in machine_value_list:
            return float("inf")
        midx = machine_value_list.index(machine_name)
        energy = float(specific_machine_energy_use_list[midx])
        electricity_emission_factor = float(electricity_list[cidx])
        return (
            energy
            * weight_after_kg
            * weight_after_qty
            * (machining_time_min / 60.0)
            * electricity_emission_factor
        )

    current_em = machine_emission(current_machine)
    best_machine = current_machine
    best_emission = current_em

    for alt in allowed_machine_substitutions.get(current_machine, []):
        alt_em = machine_emission(alt)
        if alt_em < best_emission:
            best_emission = alt_em
            best_machine = alt

    return {
        "current_machine": current_machine,
        "current_emission": current_em,
        "best_machine": best_machine,
        "best_emission": best_emission,
        "reduction": current_em - best_emission
    }


# ---------- Sourcing Optimization (material+country) ----------

def get_best_material_and_country(
    total_weight_kg: float,
    user_country: str,
    current_material: Optional[str] = None,
):
    """
    SPHERE iterates over every [material, source_country] pair and calculates:
      material_emission + transport_emission,
    where transport is modeled as shipping material from source_country
    to user_country using a 0.01 CO2e per ton-km factor. :contentReference[oaicite:19]{index=19}

    We expose this for Flutter to show "best source recommendation".
    """
    best_choice = None
    min_total_emission = float("inf")

    # Which materials to consider:
    if current_material and current_material in materials:
        test_materials = [current_material]
    else:
        test_materials = materials

    for mat in test_materials:
        for cidx, src_country in enumerate(country_list):

            # material emission factor for (mat, src_country)
            override = custom_emission_factors.get("materials", {}).get(mat)
            if override is not None:
                material_factor = float(override)
            else:
                material_lists = {
                    "Steel": steel_list,
                    "Aluminium": aluminium_list,
                    "Cement": cement_list,
                    "Plastic": plastic_list,
                    "Carbon Fiber": carbon_fiber_list,
                }
                base_list = material_lists[mat]
                try:
                    material_factor = float(base_list[cidx])
                except Exception:
                    continue

            # skip if can't geocode either end
            if (
                user_country not in country_coords_cache
                or src_country not in country_coords_cache
                or country_coords_cache[user_country] is None
                or country_coords_cache[src_country] is None
            ):
                continue

            distance_km = geodesic(
                country_coords_cache[src_country],
                country_coords_cache[user_country]
            ).km

            transport_emission_factor = 0.01  # ton-km factor (same as SPHERE) :contentReference[oaicite:20]{index=20}
            transport_emission = total_weight_kg * distance_km * transport_emission_factor / 1000.0

            # total for this combo
            total_emission = material_factor * total_weight_kg + transport_emission

            if total_emission < min_total_emission:
                min_total_emission = total_emission
                best_choice = {
                    "material": mat,
                    "source_country": src_country,
                    "material_emission_factor": material_factor,
                    "material_emission_total": material_factor * total_weight_kg,
                    "transport_emission_total": transport_emission,
                    "distance_km": distance_km,
                    "total_emission": total_emission,
                }

    return best_choice


# --------- 5. API REQUEST / RESPONSE MODELS ---------------------------------#


class MachineRow(BaseModel):
    machine_type: str
    machining_time: float  # minutes

class BusinessTravelRow(BaseModel):
    transport: str
    variation: str
    fuel: str
    origin: str
    destination: str

class EmissionRequest(BaseModel):
    # material + weight before machining
    material: str
    raw_weight_kg: float
    raw_weight_qty: int

    # after machining
    weight_after_kg: float
    weight_after_qty: int

    # geography
    manufacturing_country: str
    transport_origin_country: str
    transport_dest_country: str

    # packaging + recycling
    packaging_type: Optional[str] = None
    recycling_type: Optional[str] = None  # new

    # machine process rows
    machine_rows: List[MachineRow] = []

    # business travel rows
    business_travel_rows: List[BusinessTravelRow] = []

class ProfileSaveRequest(BaseModel):
    profile_name: str
    description: Optional[str] = ""
    data: dict  # arbitrary blob from Flutter (full form state)

class EmissionFactorsUpdateRequest(BaseModel):
    materials: Dict[str, float]  # e.g. {"Steel": 1.23, "Aluminium": 4.5}

class MachineOptimizeRequest(BaseModel):
    current_machine: str
    machining_time_min: float
    weight_after_kg: float
    weight_after_qty: int
    manufacturing_country: str

class SourcingOptimizeRequest(BaseModel):
    total_weight_kg: float
    user_country: str
    current_material: Optional[str] = None

# --------- 6. FASTAPI APP + ENDPOINTS ---------------------------------------#


app = FastAPI(title="SPHERE Backend API (no Tkinter)")

@app.get("/meta/machines")
def get_machinedata():
    """
    machine information
    """
    return {
        "machines":machine_value_list
    }

@app.get("/meta/options")
def get_options():
    """
    Flutter calls this to populate dropdowns:
      - countries
      - materials
      - machine types
      - packaging types
      - recycling types
      - business travel (van variants)
    """
    return {
        "countries": country_list,
        "materials": materials,
        "machines": machine_value_list,
        "packaging_types": packaging_types_list,
        "recycling_types": metal_recycling_types_list,
        "van_variants": van_list,
        "van_fuels": ["Diesel", "Petrol", "Battery"],
    }


@app.post("/emissions/calculate")
def calculate_emissions(req: EmissionRequest):
    """
    Main calculation endpoint, modeled after SPHERE's on-screen totals:
    - raw material
    - transport
    - machining
    - packaging
    - recycling
    - business travel
    - total
    """

    # 1. raw material
    raw_emission = calc_raw_material_emission(
        req.material,
        req.manufacturing_country,
        req.raw_weight_kg,
        req.raw_weight_qty
    )

    # 2. transport for product shipment country→country
    total_weight_for_transport = req.raw_weight_kg * req.raw_weight_qty
    transport_info = calc_transport_emission(
        req.transport_origin_country,
        req.transport_dest_country,
        total_weight_for_transport
    )
    if transport_info is None:
        transport_emission = 0.0
        distance_km = None
    else:
        transport_emission = transport_info["transport_emission"]
        distance_km = transport_info["distance_km"]

    # 3. machine processing
    machine_total, machine_details = calc_machine_emission(
        [row.dict() for row in req.machine_rows],
        req.manufacturing_country,
        req.weight_after_kg,
        req.weight_after_qty
    )

    # 4. packaging
    packaging_emission = calc_packaging_emission(
        req.packaging_type,
        req.weight_after_kg
    )

    # 5. recycling
    recycling_emission = 0.0
    if req.recycling_type:
        recycling_emission = calc_recycling_emission(
            req.recycling_type,
            req.weight_after_kg * req.weight_after_qty
        )

    # 6. business travel rows
    bt_results = []
    bt_total = 0.0
    for bt in req.business_travel_rows:
        r = calc_business_travel_row(bt.dict())
        bt_results.append(r)
        bt_total += r["emission"]

    total = (
        raw_emission
        + transport_emission
        + machine_total
        + packaging_emission
        + recycling_emission
        + bt_total
    )

    return {
        "raw_material_emission": raw_emission,
        "transport_emission": transport_emission,
        "machine_emission": machine_total,
        "machine_details": machine_details,
        "packaging_emission": packaging_emission,
        "recycling_emission": recycling_emission,
        "business_travel_emission": bt_total,
        "business_travel_details": bt_results,
        "total_emission": total,
        "transport_distance_km": distance_km,
    }


@app.post("/emissions/recycling")
def recycling_only(recycling_type: str, total_weight_after_kg: float):
    """
    Convenience endpoint if Flutter wants to calc recycling separately.
    """
    val = calc_recycling_emission(recycling_type, total_weight_after_kg)
    return {
        "recycling_emission": val
    }


@app.post("/emissions/business_travel")
def business_travel_only(rows: List[BusinessTravelRow]):
    """
    Convenience endpoint to compute business travel total and per-row details.
    """
    bt_results = []
    bt_total = 0.0
    for bt in rows:
        r = calc_business_travel_row(bt.dict())
        bt_results.append(r)
        bt_total += r["emission"]
    return {
        "business_travel_emission": bt_total,
        "details": bt_results
    }


@app.post("/optimize/machine")
def optimize_machine(req: MachineOptimizeRequest):
    """
    "Pareto suggestion": For one machine row, tell Flutter if there's a lower
    emission CNC alternative (mirrors suggest_optimal_machine in SPHERE). :contentReference[oaicite:21]{index=21}
    """
    result = suggest_optimal_machine(
        current_machine=req.current_machine,
        machining_time_min=req.machining_time_min,
        weight_after_kg=req.weight_after_kg,
        weight_after_qty=req.weight_after_qty,
        manufacturing_country=req.manufacturing_country,
    )
    return result


@app.post("/optimize/sourcing")
def optimize_sourcing(req: SourcingOptimizeRequest):
    """
    Recommend best (material, source_country) for given total weight and
    destination country, same logic as get_best_material_and_country in SPHERE. :contentReference[oaicite:22]{index=22}
    """
    best_choice = get_best_material_and_country(
        total_weight_kg=req.total_weight_kg,
        user_country=req.user_country,
        current_material=req.current_material
    )
    if best_choice is None:
        raise HTTPException(status_code=404, detail="No valid sourcing option found")
    return best_choice


@app.get("/profiles")
def list_profiles():
    """
    Return just names + descriptions for profile picker.
    (SPHERE stores profiles.json this same way.) :contentReference[oaicite:23]{index=23}
    """
    profiles = load_profiles()
    return [
        {
            "name": name,
            "description": pdata.get("description", ""),
        }
        for name, pdata in profiles.items()
    ]


@app.get("/profiles/{name}")
def get_profile(name: str):
    profiles = load_profiles()
    if name not in profiles:
        raise HTTPException(status_code=404, detail="Profile not found")
    return profiles[name]


@app.post("/profiles")
def save_profile(req: ProfileSaveRequest):
    """
    Save/overwrite profile. Flutter can send the entire form state here.
    This mirrors SPHERE's save_profile_inputs(), which serializes widget state,
    transport rows, machine rows, etc., into profiles.json. :contentReference[oaicite:24]{index=24}
    """
    profiles = load_profiles()
    profiles[req.profile_name] = {
        "description": req.description,
        **req.data
    }
    save_profiles(profiles)
    return {"ok": True}


@app.post("/emission-factors")
def update_custom_emission_factors(req: EmissionFactorsUpdateRequest):
    """
    Update per-material custom emission factors (same concept as the
    'Custom Emission Factors' dialog in SPHERE). :contentReference[oaicite:25]{index=25}
    """
    global custom_emission_factors
    current = load_custom_emission_factors()
    current["materials"] = current.get("materials", {})
    for mat, val in req.materials.items():
        current["materials"][mat] = float(val)
    save_custom_emission_factors(current)
    custom_emission_factors = current
    return {"ok": True, "custom_emission_factors": custom_emission_factors}