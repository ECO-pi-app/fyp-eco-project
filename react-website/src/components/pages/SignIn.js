import React, { useState } from "react";
import "./SignIn.css";

const API_BASE = "http://127.0.0.1:8000";

const bgStyle = {
  backgroundImage: "url(/images/Leaves.png)",
  backgroundSize: "cover",
  backgroundPosition: "center",
  backgroundRepeat: "no-repeat",
};

function SignIn() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    setErr("");
    setLoading(true);

    try {
      const res = await fetch(`${API_BASE}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }),
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) {
        throw new Error(data.detail || "Login failed");
      }

      // Save "logged in" info 
      localStorage.setItem("sphere_username", data.username);
      localStorage.setItem("sphere_logged_in", "true");
      localStorage.setItem("sphere_profiles", JSON.stringify(data.profiles || []));

      // go to page after sign in
      window.location.href = "/dashboard"; // change if your route is different
    } catch (e) {
      setErr(e.message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="signin-page">
      <div className="signin-left">
        <div className="signin-form-wrap">
          <h1>Sign in</h1>
          <p className="signin-subtitle">Track. Reduce. Sustain.</p>

          {err && (
            <p style={{ color: "crimson", marginBottom: 12, fontSize: 14 }}>
              {err}
            </p>
          )}

          <form className="signin-form" onSubmit={handleSubmit}>
            <input
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />

            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />

            <button type="submit" disabled={loading}>
              {loading ? "Signing in..." : "Sign in"}
            </button>
          </form>

          <div className="signin-footer">
            <a href="/">Forgotten password?</a>
            <a href="/sign-up">Create account</a>
          </div>
        </div>
      </div>

      <div className="signin-curve" />
      <div className="signin-right" style={bgStyle} />
    </div>
  );
}

export default SignIn;
