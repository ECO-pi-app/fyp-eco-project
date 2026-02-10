import React, { useState } from "react";
import "./SignUp.css";

const API_BASE = "http://127.0.0.1:8000";

const bgStyle = {
  backgroundImage: `url(${process.env.PUBLIC_URL}/images/Leaves.png)`,
  backgroundSize: "cover",
  backgroundPosition: "center",
  backgroundRepeat: "no-repeat",
};

function SignUp() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    setErr("");

    if (password !== confirm) {
      setErr("Passwords do not match");
      return;
    }

    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/auth/signup`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }),
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) throw new Error(data.detail || "Signup failed");

      // after signup -> go sign in
      window.location.href = "/sign-in";
    } catch (e) {
      setErr(e.message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="signup-page">
      <div className="signup-left">
        <div className="signup-form-wrap">
          <h1>Create account</h1>
          <p className="signup-subtitle">Track. Reduce. Sustain.</p>

          {err && (
            <p style={{ color: "crimson", marginBottom: 12, fontSize: 14 }}>
              {err}
            </p>
          )}

          <form className="signup-form" onSubmit={handleSubmit}>
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

            <input
              type="password"
              placeholder="Confirm password"
              value={confirm}
              onChange={(e) => setConfirm(e.target.value)}
              required
            />

            <button type="submit" disabled={loading}>
              {loading ? "Creating..." : "Sign up"}
            </button>
          </form>

          <div className="signup-footer">
            <a href="/sign-in">Already have an account? Sign in</a>
          </div>
        </div>
      </div>

      <div className="signup-curve" />
      <div className="signup-right" style={bgStyle} />
    </div>
  );
}

export default SignUp;
