import React, { useState } from 'react';
import './Footer.css';
import { Link } from 'react-router-dom';

const API_BASE = "http://127.0.0.1:8000"; // change when deployed

function Footer() {
  const [email, setEmail] = useState("");
  const [msg, setMsg] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubscribe(e) {
    e.preventDefault(); // stops page nav/reload
    setMsg("");
    setLoading(true);

    try {
      const res = await fetch(`${API_BASE}/subscribe`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      const data = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(data.detail || data.error || "Subscribe failed");

      setMsg("Subscribed successfully!");
      setEmail("");
    } catch (err) {
      setMsg(err.message || "Subscribe failed");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className='footer-container'>
      <section className='footer-subscription'>
        <p className="footer-subscription-heading">
          Subscribe for the best deals in the future.
        </p>
        <p className='footer-subscription-text'>
          You can unsubscribe at any time.
        </p>

        <div className="input-areas">
          <form onSubmit={handleSubscribe}>
            <input
              type="email"
              name="email"
              placeholder="Your Email"
              className='footer-input'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />

            {/* IMPORTANT: native button so it submits, not navigates */}
            <button
              type="submit"
              className="btn btn--outline"
              disabled={loading}
            >
              {loading ? "Subscribing..." : "Subscribe"}
            </button>
          </form>

          {msg && (
            <p
              className="footer-message"
              style={{
                marginTop: 10,
                fontSize: 14,
                color: msg.toLowerCase().includes("success") ? "#8fff8f" : "crimson",
                textAlign: "center"
              }}
            >
              {msg}
            </p>
          )}
        </div>
      </section>

      <div className='footer-links'>
        <div className="footer-link-wrapper">
          <div className="footer-link-items">
            <h2>About Us</h2>
            <Link to='/how-it-works'>How it works</Link>
            <Link to='/'>Terms of Service</Link>
          </div>

          <div className="footer-link-items">
            <h2>Contact Us</h2>
            <Link to='/contact'>Contact</Link>
            <Link to='/support'>Support</Link>
          </div>
        </div>

        <div className="footer-link-wrapper">
          <div className="footer-link-items">
            <h2>Social Media</h2>

            <a href="https://www.instagram.com/ecopi.help/" target="_blank" rel="noopener noreferrer">
              Instagram
            </a>
            <a href="https://www.facebook.com/profile.php?id=61587670057719" target="_blank" rel="noopener noreferrer">
              Facebook
            </a>
            <a href="https://www.youtube.com" target="_blank" rel="noopener noreferrer">
              YouTube
            </a>
            <a href="https://x.com/ECOPi_sp" target="_blank" rel="noopener noreferrer">
              Twitter (X)
            </a>
          </div>
        </div>
      </div>

      <section className='social-media'>
        <div className='social-media-wrap'>
          <Link to="/" className="social-logo">
            <img
              src={`${process.env.PUBLIC_URL}/images/App_logo.svg`}
              alt="ECO-Pi logo"
            />
            ECO-Pi
          </Link>

          <small className='website-rights'>ECO-Pi ©2025</small>

          <div className="social-icons">
            <a
              className="social-icon-link facebook"
              href="https://www.facebook.com/profile.php?id=61587670057719"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="Facebook"
            >
              <i className="fab fa-facebook-f"></i>
            </a>

            <a
              className="social-icon-link instagram"
              href="https://www.instagram.com/ecopi.help/"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="Instagram"
            >
              <i className="fab fa-instagram"></i>
            </a>

            <a
              className='social-icon-link youtube'
              href="https://www.youtube.com"
              target="_blank"
              rel="noopener noreferrer"
              aria-label='Youtube'
            >
              <i className='fab fa-youtube' />
            </a>

            <a
              className='social-icon-link twitter'
              href='https://twitter.com/ECOPi_sp'
              target='_blank'
              rel='noopener noreferrer'
              aria-label='Twitter'
            >
              <i className='fab fa-twitter' />
            </a>

            <a
              className="social-icon-link linkedin"
              href="https://www.linkedin.com/in/eco-pi-sp-608bb23ab/"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="LinkedIn"
            >
              <i className="fab fa-linkedin" />
            </a>
          </div>
        </div>
      </section>
    </div>
  );
}

export default Footer;
