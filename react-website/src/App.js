import React from 'react';
import Navbar from './components/Navbar';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
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
import ExcelEditor from "./components/pages/ExcelEditor";
import Support from './components/pages/Support';



function App() {
  return (
    <>
      <Router>
        <Navbar />
        <Switch>
          <Route path='/' exact component={Home} />
          <Route path='/methodology' component={Methodology} />
          <Route path='/contact' component={Contact} />
          <Route path='/about' component={About_us} />
          <Route path='/sign-up' component={SignUp} />
          <Route path="/sign-in" component={SignIn} />
          <Route path="/dashboard" component={Dashboard} />
          <Route path="/profiles" exact component={Profiles} />
          <Route path="/profiles/:name" component={ProfileView} />
          <Route path='/how-it-works' component={HowItWorks} />
          <Route path="/excel" component={ExcelEditor} />
          <Route path='/support' component={Support} />
        </Switch>
      </Router>
    </>
  );
}

export default App;

