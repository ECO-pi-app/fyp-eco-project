import React from "react";
import "./Support.css";

function Support() {
  return (
    <div className="support">
      <div className="support__container">

        {/* TOP FEATURED CARD */}
        <section className="support__featured">
          <h1>Project Support</h1>

          <div className="support__featured-card">
            <img
              src={`${process.env.PUBLIC_URL}/images/singapore_poly_logo.png`}
              alt="Singapore Polytechnic"
              className="support__logo"
            />

            <h2>Singapore Polytechnic</h2>
            <p>
              This project is developed and funded by Singapore Polytechnic.
              The institution provides academic guidance, facilities, and
              project funding to support the development of ECO-Pi.
            </p>
          </div>
        </section>

        {/* COMPANIES */}
        <section className="support__section">
          <h2>Companies</h2>
          <div className="support__cards">
            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/Onn_Wah_Tech_logo.jpg`}
                alt="Onn Wah Tech"
                className="support__card-logo"
              />
              <span>Onn Wah Tech</span>
            </div>
            <div className="support__card"></div>
            <div className="support__card"></div>
          </div>
        </section>

        {/* DATABASES */}
        <section className="support__section">
          <h2>Databases</h2>
          <div className="support__cards">
            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/excel_logo.jpg`}
                alt="Excel"
                className="support__card-logo"
              />
              <span>Excel</span>
            </div>

            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/NewsAPI.png`}
                alt="NewsAPI"
                className="support__card-logo"
              />
              <span>NewsAPI</span>
            </div>

            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/visual_studio_logo.png`}
                alt="Visual Studio"
                className="support__card-logo"
              />
              <span>Visual Studio</span>
            </div>
          </div>
        </section>

        {/* APPS */}
        <section className="support__section">
          <h2>Apps</h2>
          <div className="support__cards">
            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/visual_studio_logo.png`}
                alt="Visual Studio"
                className="support__card-logo"
              />
              <span>Visual Studio</span>
            </div>

            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/dassault systemes.png`}
                alt="Dassault Systèmes"
                className="support__card-logo"
              />
              <span>Eco-Design (Dassault Systèmes)</span>
            </div>

            <div className="support__card support__card--with-logo">
              <img
                src={`${process.env.PUBLIC_URL}/images/GitHub.png`}
                alt="GitHub"
                className="support__card-logo"
              />
              <span>GitHub</span>
            </div>
          </div>
        </section>

      </div>
    </div>
  );
}

export default Support;
