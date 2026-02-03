import React, { useEffect, useRef, useState } from "react";
import { HotTable } from "@handsontable/react";
import "handsontable/dist/handsontable.full.min.css";
import "./ExcelEditor.css";

const API = "http://127.0.0.1:8000"; // change if your FastAPI is hosted

export default function ExcelEditor() {
  const [sheets, setSheets] = useState([]);
  const [sheet, setSheet] = useState("");
  const [data, setData] = useState([[]]);
  const pending = useRef([]);
  const timer = useRef(null);

  // load sheet names
  useEffect(() => {
    fetch(`${API}/excel/sheets`)
      .then((r) => r.json())
      .then((j) => {
        setSheets(j.sheets || []);
        if (j.sheets?.length) setSheet(j.sheets[0]);
      })
      .catch(console.error);
  }, []);

  // load selected sheet data
  useEffect(() => {
    if (!sheet) return;
    fetch(`${API}/excel/sheet/${encodeURIComponent(sheet)}?max_rows=200&max_cols=50`)
      .then((r) => r.json())
      .then((j) => setData(j.rows || [[]]))
      .catch(console.error);
  }, [sheet]);

  function queueUpdates(changes) {
    pending.current.push(...changes);

    if (timer.current) return;
    timer.current = setTimeout(async () => {
      const batch = pending.current.splice(0, 200);
      timer.current = null;
      if (!batch.length) return;

      // use your existing backend endpoint:
      await fetch(`${API}/excel/update_cells`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          sheet,
          updates: batch.map((p) => ({
            sheet,
            row: p.r,
            col: p.c,
            value: p.v,
          })),
        }),
      });
    }, 400);
  }

  return (
    <div className="excelPage">
      <div className="excelTop">
        <h1>Excel Editor</h1>

        <div className="excelControls">
          <label>Sheet</label>
          <select value={sheet} onChange={(e) => setSheet(e.target.value)}>
            {sheets.map((s) => (
              <option key={s} value={s}>{s}</option>
            ))}
          </select>
        </div>
      </div>

      <HotTable
        data={data}
        rowHeaders={true}
        colHeaders={true}
        width="100%"
        height="75vh"
        licenseKey="non-commercial-and-evaluation"
        afterChange={(changes, source) => {
          if (!changes || source === "loadData") return;

          const patches = changes.map(([row, col, oldVal, newVal]) => ({
            r: row + 1,     // 1-based for backend
            c: col + 1,
            v: newVal ?? "",
          }));

          queueUpdates(patches);
        }}
      />
    </div>
  );
}
