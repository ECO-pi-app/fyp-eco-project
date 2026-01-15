import React, { useEffect, useState } from "react";

import "./Dashboard.css";

function Dashboard() {
  const [username, setUsername] = useState("");
  const [profiles, setProfiles] = useState([]);

  useEffect(() => {
    const loggedIn = localStorage.getItem("sphere_logged_in") === "true";
    const u = localStorage.getItem("sphere_username") || "";
    const pRaw = localStorage.getItem("sphere_profiles") || "[]";

    if (!loggedIn || !u) {
      window.location.href = "/sign-in";
      return;
    }

    setUsername(u);

    try {
      setProfiles(JSON.parse(pRaw));
    } catch {
      setProfiles([]);
    }
  }, []);

  function handleLogout() {
    localStorage.removeItem("sphere_logged_in");
    localStorage.removeItem("sphere_username");
    localStorage.removeItem("sphere_profiles");
    window.location.href = "/sign-in";
  }

  return (
    <div className="dash-page">
      <div className="dash-card">
        <div className="dash-top">
          <div>
            <h1 className="dash-title">Dashboard</h1>
            <p className="dash-subtitle">
              Welcome, <span className="dash-username">{username}</span>
            </p>
          </div>

          <button className="dash-logout" onClick={handleLogout}>
            Log out
          </button>
        </div>

        <div className="dash-actions">
          <a className="dash-btn" href="/profiles">
            View Profiles
          </a>
          <a className="dash-btn" href="/news">
            Sustainability News
          </a>
        </div>

        <div className="dash-section">
          <h2 className="dash-h2">Your saved profiles</h2>

          {profiles.length === 0 ? (
            <p className="dash-muted">
              No saved profiles yet. Create a calculation, then save it as a
              profile.
            </p>
          ) : (
            <ul className="dash-list">
              {profiles.map((name) => (
                <li key={name} className="dash-item">
                  <span className="dash-item-name">{name}</span>
                  <a className="dash-open" href={`/profiles/${encodeURIComponent(name)}`}>
                    Open
                  </a>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
