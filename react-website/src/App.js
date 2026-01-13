import React from 'react';
import Navbar from './components/Navbar';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import './App.css';

import Home from './components/pages/Home';
import Services from './components/pages/Services';
import About_us from './components/pages/About_us';
import SignUp from './components/pages/SignUp';
import Calculator from './components/pages/Calculator';
import Methodology from './components/pages/Methodology';
import Contact from './components/pages/Contact';
import SignIn from './components/pages/SignIn';

function App() {
  return (
    <>
      <Router>
        <Navbar />
        <Switch>
          <Route path='/' exact component={Home} />
          <Route path='/services' component={Services} />
          <Route path='/calculator' component={Calculator} />
          <Route path='/methodology' component={Methodology} />
          <Route path='/contact' component={Contact} />
          <Route path='/about' component={About_us} />
          <Route path='/sign-up' component={SignUp} />
          <Route path="/sign-in" component={SignIn} />
        </Switch>
      </Router>
    </>
  );
}

export default App;

