import React from "react";
import "./Methodology.css";

export default function Methodology() {
  return (
    <div className="method-page">
      <div className="method-hero">
        <h1>Methodology</h1>
        <p>
          How ECO-Pi estimates emissions across materials, transport, energy etc. —
          with transparent inputs and calculations.
        </p>
      </div>

      <div className="method-stack">
        <div className="method-card">
          <h3>1) Materials</h3>
          <p>
            Materials emissions are estimated using an emission factor (EF) per kg of material.
            Total material emissions = EF × mass.
          </p>
          <div className="method-formula">CO₂e = EF (kgCO₂e/kg) × mass (kg)</div>
        </div>

        <div className="method-card">
          <h3>2) Transport</h3>
          <p>
            Transport uses emission factors by mode (road/sea/air). Depending on the dataset,
            factors may be per kg-km or per tonne-km (1000 kg-km). We convert to match user inputs.
          </p>
          <div className="method-formula">CO₂e = EF × mass × distance</div>
        </div>

        <div className="method-card">
          <h3>3) Machining</h3>
          <p>
            Electricity and machining are estimated from energy use. If you have power draw, we
            compute energy from power × time, then multiply by grid intensity.
          </p>
          <div className="method-formula">
            power_drawed = spindle + milling_spindle<br />
            machine_emissions = power_drawed × grid_intensity × time_operated
          </div>
        </div>

        <div className="method-card">
          <h3>4) Fugitive</h3>
          <p>
            The mass of GHG released is determined as the difference between the total amount charged into the system and the remaining charge at the time of assessment.
            The resulting CO₂-equivalent emissions are then calculated by multiplying the released mass by the Global Warming Potential (GWP) of the specific gas.
          </p>
          <div className="method-formula">
            m_GHG = total_charged_amount − current_charge_amount<br />
            Emissions (kgCO₂e) = GWP_GHG × m_GHG
          </div>
        </div>
      </div>
    </div>
  );
}
