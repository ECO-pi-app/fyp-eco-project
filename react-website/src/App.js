import React from 'react';
import Navbar from './components/Navbar';
import { HashRouter as Router, Switch, Route } from 'react-router-dom';
import './App.css';
import Home from './components/pages/Home';
import About_us from './components/pages/About_us';
import SignUp from './components/pages/SignUp';
import Methodology from './components/pages/Methodology';
import Contact from './components/pages/Contact';
import SignIn from './components/pages/SignIn';
import Dashboard from "./components/pages/Dashboard";
import Profiles from "./components/pages/Profiles";
import ProfileView from "./components/pages/ProfileView";
import HowItWorks from './components/pages/HowItWorks';
import Support from './components/pages/Support';
import ExcelEditor from './components/pages/ExcelEditor';

function App() {
  return (
    <>
      <Router>
        <Navbar />
        <Switch>
          <Route path='/' exact>
            <Home />
          </Route>

          <Route path='/methodology' exact>
            <Methodology />
          </Route>

          <Route path='/contact' exact>
            <Contact />
          </Route>

          <Route path='/about' exact>
            <About_us />
          </Route>

          <Route path='/sign-up' exact>
            <SignUp />
          </Route>

          <Route path='/sign-in' exact>
            <SignIn />
          </Route>

          <Route path='/dashboard' exact>
            <Dashboard />
          </Route>

          <Route path='/profiles' exact>
            <Profiles />
          </Route>

          <Route path='/profiles/:name' exact>
            <ProfileView />
          </Route>

          <Route path='/how-it-works' exact>
            <HowItWorks />
          </Route>

          <Route path='/excel' exact>
            <ExcelEditor />
          </Route>

          <Route path='/support' exact>
            <Support />
          </Route>
        </Switch>
      </Router>
    </>
  );
}

export default App;