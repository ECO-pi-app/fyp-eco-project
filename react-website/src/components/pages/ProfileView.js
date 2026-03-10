import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import "./ProfileView.css";

const API_BASE = "http://127.0.0.1:8000";

function ProfileView() {
  const { name } = useParams();
  const [profile, setProfile] = useState(null);
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loggedIn = localStorage.getItem("sphere_logged_in") === "true";
    const username = localStorage.getItem("sphere_username");

    if (!loggedIn || !username) {
      window.location.href = "/sign-in";
      return;
    }

    (async () => {
      try {
        const res = await fetch(
          `${API_BASE}/profiles/${encodeURIComponent(name)}?username=${encodeURIComponent(username)}`
        );
        const data = await res.json().catch(() => ({}));
        if (!res.ok) throw new Error(data.detail || "Failed to load profile");

        setProfile(data);
      } catch (e) {
        setErr(e.message);
      } finally {
        setLoading(false);
      }
    })();
  }, [name]);

  return (
    <div className="pview-page">
      <div className="pview-card">
        <div className="pview-top">
          <div>
            <h1 className="pview-title">{decodeURIComponent(name)}</h1>
            {profile?.description ? (
              <p className="pview-desc">{profile.description}</p>
            ) : (
              <p className="pview-desc muted">No description.</p>
            )}
          </div>
          <a className="pview-back" href="/profiles">Back</a>
        </div>

        {loading && <p className="muted">Loading...</p>}
        {err && <p className="error">{err}</p>}

        {!loading && !err && profile && (
          <>
            <h2 className="pview-h2">Saved data</h2>
            <pre className="pview-pre">
              {JSON.stringify(profile.data || {}, null, 2)}
            </pre>
          </>
        )}
      </div>
    </div>
  );
}

export default ProfileView;
