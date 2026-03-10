import React, { useEffect, useRef, useState } from "react";
import { HotTable } from "@handsontable/react";
import "handsontable/styles/handsontable.min.css";
import "handsontable/styles/ht-theme-main.min.css";
import "./ExcelEditor.css";

const API = "http://127.0.0.1:8000";

export default function ExcelEditor() {
  const [sheets, setSheets] = useState([]);
  const [sheet, setSheet] = useState("");
  const [data, setData] = useState([[]]);
  const pending = useRef([]);
  const timer = useRef(null);

  const sheetRef = useRef("");
  useEffect(() => {
    sheetRef.current = sheet;
  }, [sheet]);

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

    // clear pending updates when switching sheets
    pending.current = [];
    if (timer.current) {
      clearTimeout(timer.current);
      timer.current = null;
    }
  }, [sheet]);

  function queueUpdates(changes) {
    pending.current.push(...changes);

    if (timer.current) return;
    timer.current = setTimeout(async () => {
      const batch = pending.current.splice(0, 200);
      timer.current = null;
      if (!batch.length) return;

      const currentSheet = sheetRef.current;

      await fetch(`${API}/excel/update_cells`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          sheet: currentSheet,
          updates: batch.map((p) => ({
            sheet: currentSheet,
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
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="ht-theme-main">
        <HotTable
          data={data}
          rowHeaders={true}
          colHeaders={true}
          width="100%"
          height="75vh"
          licenseKey="non-commercial-and-evaluation"
          stretchH="all"
          autoColumnSize={{ useHeaders: true }}   // ✅ better auto-fit (includes headers)
          manualColumnResize={true}
          manualRowResize={true}
          colWidths={160}
          wordWrap={true}

          // ✅ “Excel-like coloured titles”: style first row + first column
          cells={(row, col) => {
            if (row === 0 && col === 0) return { className: "excel-title-cell" };
            if (row === 0) return { className: "excel-header-row" };
            if (col === 0) return { className: "excel-title-col" };
            return {};
          }}

          afterChange={(changes, source) => {
            if (!changes || source === "loadData") return;

            const patches = changes.map(([row, col, oldVal, newVal]) => ({
              r: row + 1,
              c: col + 1,
              v: newVal ?? "",
            }));

            queueUpdates(patches);
          }}
        />
      </div>
    </div>
  );
}
