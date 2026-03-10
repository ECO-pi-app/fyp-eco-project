// src/components/pages/Profiles.js
import React, { useEffect, useMemo, useState } from "react";
import "./Profiles.css";
import { FaPen, FaTrash, FaFolderOpen } from "react-icons/fa";

const API_BASE = "http://127.0.0.1:8000";

function Profiles() {
  const [profiles, setProfiles] = useState([]);
  const [q, setQ] = useState("");
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(true);

  const username = localStorage.getItem("sphere_username") || "";
  const loggedIn = localStorage.getItem("sphere_logged_in") === "true";

  useEffect(() => {
    if (!loggedIn || !username) {
      window.location.href = "/sign-in";
      return;
    }

    (async () => {
      try {
        setErr("");
        const res = await fetch(
          `${API_BASE}/profiles?username=${encodeURIComponent(username)}`
        );
        const data = await res.json().catch(() => ({}));
        if (!res.ok) throw new Error(data.detail || "Failed to load profiles");
        setProfiles(data.profiles || []);
      } catch (e) {
        setErr(e.message);
      } finally {
        setLoading(false);
      }
    })();
  }, [loggedIn, username]);

  const filtered = useMemo(() => {
    const term = q.trim().toLowerCase();
    if (!term) return profiles;
    return profiles.filter((p) => String(p).toLowerCase().includes(term));
  }, [profiles, q]);

  async function handleDelete(profileName) {
    const ok = window.confirm(`Delete "${profileName}"? This cannot be undone.`);
    if (!ok) return;

    try {
      setErr("");
      const res = await fetch(
        `${API_BASE}/profiles/delete/${encodeURIComponent(
          username
        )}/${encodeURIComponent(profileName)}`,
        { method: "DELETE" }
      );
      const data = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(data.detail || "Delete failed");

      setProfiles((prev) => prev.filter((p) => p !== profileName));
    } catch (e) {
      setErr(e.message);
    }
  }

  async function handleRename(oldName) {
    const newName = window.prompt(`Rename "${oldName}" to:`, oldName);
    if (!newName) return;

    const cleaned = newName.trim();
    if (!cleaned) return;

    try {
      setErr("");
      const res = await fetch(`${API_BASE}/profiles/rename`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, old_name: oldName, new_name: cleaned }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(data.detail || "Rename failed");

      setProfiles((prev) => prev.map((p) => (p === oldName ? cleaned : p)));
    } catch (e) {
      setErr(e.message);
    }
  }

  return (
    <div className="profiles-page">
      <div className="profiles-card">
        <div className="profiles-top">
          <div>
            <h1>Profiles</h1>
            <p className="muted">
              Signed in as <b>{username}</b>
            </p>
          </div>

          <a className="profiles-back" href="/dashboard">
            Back
          </a>
        </div>

        <div className="profiles-toolbar">
          <input
            className="profiles-search"
            placeholder="Search profiles..."
            value={q}
            onChange={(e) => setQ(e.target.value)}
          />
        </div>

        {loading && <p className="muted">Loading...</p>}
        {err && <p className="error">{err}</p>}

        {!loading && !err && filtered.length === 0 && (
          <p className="muted">No profiles found.</p>
        )}

        {!loading && !err && filtered.length > 0 && (
          <ul className="profiles-list">
            {filtered.map((name) => (
              <li key={name} className="profiles-item">
                <span className="profiles-name">{name}</span>

                <div className="profiles-actions">
                    <a
                        className="icon-btn"
                        href={`/profiles/${encodeURIComponent(name)}`}
                        title="Open profile"
                        aria-label="Open profile"
                    >
                        <FaFolderOpen />
                    </a>

                  <button
                    className="icon-btn"
                    title="Rename profile"
                    onClick={() => handleRename(name)}
                    aria-label="Rename profile"
                    type="button"
                  >
                    <FaPen />
                  </button>

                  <button
                    className="icon-btn danger"
                    title="Delete profile"
                    onClick={() => handleDelete(name)}
                    aria-label="Delete profile"
                    type="button"
                  >
                    <FaTrash />
                  </button>
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default Profiles;
