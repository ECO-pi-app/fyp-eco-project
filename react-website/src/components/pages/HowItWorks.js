import React from "react";
import "./HowItWorks.css";

export default function HowItWorks() {
  return (
    <div className="howitworks">
      <div className="howitworks__card">
        <h1 className="howitworks__title">Sign in tutorial</h1>

        <video
          className="howitworks__video"
          src={process.env.PUBLIC_URL + "/videos/log-in.mp4"}
          controls
          playsInline
        />
      </div>
    </div>
  );
}