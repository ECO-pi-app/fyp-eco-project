import React from "react";
import "../../App.css";
import "./About_us.css";

export default function About_us() {
  return (
    <div className="about">
      <div className="about__container">
        <header className="about__header">
          <h1 className="about__title">About Us</h1>
          <p className="about__subtitle">
            We build simple tools that help people measure carbon emissions.
          </p>
        </header>

        <section className="about__grid">
          <div className="about__card">
            <h2>Our Mission</h2>
            <p>
              Make sustainability decisions easier by turning complex emissions data into clear,
              actionable insights.
            </p>
          </div>

          <div className="about__card">
            <h2>What We Do</h2>
            <p>
              We provide calculators and dashboards for materials, transport, machining, packaging,
              and end-of-life—so teams can track CO₂e end-to-end.
            </p>
          </div>

          <div className="about__card">
            <h2>Why It Matters</h2>
            <p>
              Small improvements across many processes add up. Our goal is to help you find the
              biggest wins quickly and report them confidently.
            </p>
          </div>
        </section>

        {/* CONTACT CTA ONLY */}
        <section className="about__split">
          <div className="about__panel about__panel--cta">
            <h2>Contact</h2>
            <p>Have questions about the app?</p>
            <a className="about__btn" href="/contact">Get in touch</a>
          </div>
        </section>
      </div>
    </div>
  );
}
