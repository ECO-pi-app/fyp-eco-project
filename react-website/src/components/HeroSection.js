import React from 'react';
import '../App.css';
import { Button } from './Button';
import './HeroSection.css';

function HeroSection() {
  return (
    <div className='hero-container'>
      <video src="/videos/nature.mp4" autoPlay loop muted />
      <h1> SUSTAINABILITY</h1>
      <p>Small changes. Real impact.</p>
      <div className="hero-btns">
        <Button className='btns' buttonStyle='btn--outline'
        buttonSize='btn--large'
        >
            GET STARTED
            </Button>
            <Button className='btns' 
            buttonStyle='btn--primary' 
            buttonSize='btn--large'>
            WATCH TRAILER <i className='far fa-play-circle' />
            </Button>
      </div>
    </div>
  )
}

export default HeroSection;