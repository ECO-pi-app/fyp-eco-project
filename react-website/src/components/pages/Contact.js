import React from 'react';
import '../../App.css';
import './SimplePage.css';

export default function Contact() {
  return (
    <div className="page">
      <div className="page__container">
        <h1>Contact</h1>
        <p className="page__muted">Ask anything below.</p>

        <div className="page__card">
          <form onSubmit={(e) => e.preventDefault()}>
            <label className="page__label">Name</label>
            <input className="page__input" placeholder="Your name" />

            <label className="page__label" style={{ marginTop: 10 }}>Email</label>
            <input className="page__input" placeholder="your@email.com" />

            <label className="page__label" style={{ marginTop: 10 }}>Message</label>
            <textarea className="page__input" rows="5" placeholder="How can we help?" />

            <button className="page__btn" type="submit">Send</button>
          </form>
        </div>
      </div>
    </div>
  );
}
