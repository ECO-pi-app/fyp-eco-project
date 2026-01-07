import React, { useState } from 'react';
import '../App.css';
import { Button } from './Button';
import './HeroSection.css';
import TrailerModal from './Trailermodal';

function HeroSection() {
  const [open, setOpen] = useState(false);

  return (
    <div className='hero-container'>
      <video src="/videos/nature.mp4" autoPlay loop muted />
      <h1>SUSTAINABILITY</h1>
      <p>Small changes. Real impact.</p>

      <div className="hero-btns">
        <Button className='btns' buttonStyle='btn--outline' buttonSize='btn--large'>
          GET STARTED
        </Button>

        <Button
          className='btns'
          buttonStyle='btn--primary'
          buttonSize='btn--large'
          onClick={() => setOpen(true)}
        >
          WATCH TRAILER <i className='far fa-play-circle' />
        </Button>
      </div>

      <TrailerModal
        open={open}
        onClose={() => setOpen(false)}
        url="https://www.youtube.com/watch?v=Z_M5SYSCOdk"
      />
    </div>
  );
}

export default HeroSection;
