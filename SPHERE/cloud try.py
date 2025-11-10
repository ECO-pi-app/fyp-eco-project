import openpyxl
import requests

# Your realtime DB URL (from the screenshot)
BASE_URL = "https://emission-data-62e93-default-rtdb.asia-southeast1.firebasedatabase.app"


def extract_col(sheet, col_letter, start_row=2, max_row=999, stop_on_blank=True):
    """Read a single column from Excel into a list."""
    values = []
    for r in range(start_row, max_row + 1):
        cell_value = sheet[f"{col_letter}{r}"].value
        if cell_value is None or str(cell_value).strip() == "":
            if stop_on_blank:
                break
            else:
                values.append(None)
        else:
            values.append(cell_value)
    return values


def sheet_to_list(ws):
    """
    Convert a whole sheet into a list of rows,
    where each row is a list of cell values.
    """
    data = []
    for row in ws.iter_rows(values_only=True):
        # Skip completely empty rows
        if all(cell is None for cell in row):
            continue
        data.append(list(row))
    return data


def main():
    # 1) Load workbook
    wb = openpyxl.load_workbook("Emission Data.xlsx", data_only=True)

    # ---- Data Sheet (structured, like before) ----
    sheet_data = wb["Data Sheet"]

    countries    = extract_col(sheet_data, "A")  # Country
    distances    = extract_col(sheet_data, "B", stop_on_blank=False)
    steel        = extract_col(sheet_data, "C", stop_on_blank=False)
    aluminium    = extract_col(sheet_data, "D", stop_on_blank=False)
    cement       = extract_col(sheet_data, "E", stop_on_blank=False)
    electricity  = extract_col(sheet_data, "F", stop_on_blank=False)
    plastic      = extract_col(sheet_data, "G", stop_on_blank=False)
    carbon_fiber = extract_col(sheet_data, "H", stop_on_blank=False)

    emission_data_structured = {
        "countries": countries,
        "distances": distances,
        "materials": {
            "Steel": steel,
            "Aluminium": aluminium,
            "Cement": cement,
            "Plastic": plastic,
            "Carbon Fiber": carbon_fiber,
        },
        "electricity": electricity,
    }

    # ---- Other sheets (raw tables) ----
    sheet_transport      = wb["Transport"]
    sheet_transport_wtt  = wb["Transport WTT"]
    sheet_machine_types  = wb["Machine Types"]
    sheet_recycling      = wb["Recycling"]
    sheet_packaging      = wb["Packaging"]

    transport_table      = sheet_to_list(sheet_transport)
    transport_wtt_table  = sheet_to_list(sheet_transport_wtt)
    machine_types_table  = sheet_to_list(sheet_machine_types)
    recycling_table      = sheet_to_list(sheet_recycling)
    packaging_table      = sheet_to_list(sheet_packaging)

    # ---- Build one big payload ----
    payload = {
        "data_sheet": emission_data_structured,
        "transport_sheet": transport_table,
        "transport_wtt_sheet": transport_wtt_table,
        "machine_types_sheet": machine_types_table,
        "recycling_sheet": recycling_table,
        "packaging_sheet": packaging_table,
    }

    # 2) Upload everything under /emission_data
    url = f"{BASE_URL}/emission_data.json"
    resp = requests.put(url, json=payload, timeout=20)

    print("Status:", resp.status_code)
    print("Raw response:", repr(resp.text))


if __name__ == "__main__":
    main()
