import React, { useState, useEffect } from 'react';
import './Navbar.css';
import { Link, useHistory } from 'react-router-dom';

/* 🔹 MOVE SEARCH INDEX OUTSIDE COMPONENT */
const SEARCH_INDEX = [
  {
    title: "Carbon Calculator",
    route: "/calculator",
    keywords:
      "calculator calculate carbon co2 co2e emissions footprint materials transport distance mass energy electricity grid intensity machining power time",
  },
  {
    title: "Methodology",
    route: "/methodology",
    keywords:
      "methodology method formulas calculation assumptions ghg gwp refrigerant leakage scope 1 scope 2 scope 3 reporting emission factors factors",
  },
  {
    title: "Services",
    route: "/services",
    keywords:
      "services tools transport manufacturing materials reporting sustainability features breakdown categories",
  },
  {
    title: "About Us",
    route: "/about",
    keywords:
      "about eco-pi project team mission sustainability final year fyp overview",
  },
  {
    title: "Contact",
    route: "/contact",
    keywords: "contact email feedback support help",
  },
];

function Navbar() {
  const history = useHistory();

  const [click, setClick] = useState(false);
  const [button, setButton] = useState(true);

  // dropdown states
  const [openTools, setOpenTools] = useState(false);
  const [openAbout, setOpenAbout] = useState(false);

  // search states (VS Code style)
  const [showSearch, setShowSearch] = useState(false);
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  const handleClick = () => setClick((v) => !v); // ✅ mobile hamburger toggle

  const closeMobileMenu = () => {
    setClick(false);            // ✅ close mobile menu
    setOpenTools(false);
    setOpenAbout(false);
  };

  const showButton = () => {
    setButton(window.innerWidth > 960);
  };

  useEffect(() => {
    showButton();
    window.addEventListener('resize', showButton);
    return () => window.removeEventListener('resize', showButton);
  }, []);

  // ✅ close dropdowns when clicking outside
  useEffect(() => {
    const onDocClick = () => {
      setOpenTools(false);
      setOpenAbout(false);
    };
    document.addEventListener('click', onDocClick);
    return () => document.removeEventListener('click', onDocClick);
  }, []);

  /* 🔍 VS-CODE STYLE SEARCH (NO AUTO NAVIGATE) */
  useEffect(() => {
    const q = query.trim().toLowerCase();

    if (q.length < 2) {
      setResults([]);
      return;
    }

    const matches = SEARCH_INDEX
      .map((item) => {
        let score = 0;
        const title = item.title.toLowerCase();
        const text = item.keywords.toLowerCase();

        if (title.includes(q)) score += 6;
        if (text.includes(q)) score += 4;

        q.split(/\s+/).forEach((token) => {
          if (!token) return;
          if (title.includes(token)) score += 2;
          if (text.includes(token)) score += 1;
        });

        return { ...item, score };
      })
      .filter((x) => x.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 6);

    setResults(matches);
  }, [query]);

  const goTo = (route) => {
    history.push(route);
    setShowSearch(false);
    setQuery("");
    setResults([]);
    closeMobileMenu(); // ✅ important: close menu + dropdowns after navigation
  };

  const toggleTools = (e) => {
    e.stopPropagation();
    setOpenTools((v) => !v);
    setOpenAbout(false);
  };

  const toggleAbout = (e) => {
    e.stopPropagation();
    setOpenAbout((v) => !v);
    setOpenTools(false);
  };

  return (
    <>
      <nav className="navbar">
        <div className="navbar-container">
          <Link to="/" className="navbar-logo" onClick={closeMobileMenu}>
            <div className="logo-wrapper">
              <span className="logo-text">ECO-Pi</span>
              <img src="/images/App_logo.svg" alt="ECO-Pi logo" className="navbar-logo-img" />
            </div>
          </Link>

          {/* ✅ hamburger now actually toggles click */}
          <div className="menu-icon" onClick={handleClick}>
            <i className={click ? 'fas fa-times' : 'fas fa-bars'} />
          </div>

          {/* ✅ click now controls nav-menu */}
          <ul className={click ? 'nav-menu active' : 'nav-menu'} onClick={(e) => e.stopPropagation()}>
            <li className="nav-item">
              <Link to="/" className="nav-links" onClick={closeMobileMenu}>Home</Link>
            </li>

            <li className="nav-item dropdown">
              <button type="button" className="nav-links nav-dropbtn" onClick={toggleTools}>
                Tools <i className="fas fa-caret-down" />
              </button>
              <ul className={openTools ? 'dropdown-menu show' : 'dropdown-menu'} onClick={(e) => e.stopPropagation()}>
                <li><Link to="/calculator" className="dropdown-link" onClick={closeMobileMenu}>Calculator</Link></li>
                <li><Link to="/methodology" className="dropdown-link" onClick={closeMobileMenu}>Methodology</Link></li>
              </ul>
            </li>

            <li className="nav-item dropdown">
              <button type="button" className="nav-links nav-dropbtn" onClick={toggleAbout}>
                About <i className="fas fa-caret-down" />
              </button>
              <ul className={openAbout ? 'dropdown-menu show' : 'dropdown-menu'} onClick={(e) => e.stopPropagation()}>
                <li><Link to="/about" className="dropdown-link" onClick={closeMobileMenu}>About Us</Link></li>
                <li><Link to="/services" className="dropdown-link" onClick={closeMobileMenu}>Services</Link></li>
                <li><Link to="/contact" className="dropdown-link" onClick={closeMobileMenu}>Contact</Link></li>
              </ul>
            </li>
          </ul>

          {button && (
            <div className="nav-actions">
              <button className="icon-btn" type="button" onClick={() => setShowSearch(true)}>
                <i className="fas fa-search" />
              </button>
              <Link to="/contact" className="nav-outline-btn" onClick={closeMobileMenu}>Contact us</Link>
              <Link to="/sign-up" className="nav-primary-btn" onClick={closeMobileMenu}>Download</Link>

              {/* ✅ changed to /sign-in (since you want a real sign-in page) */}
              <Link to="/sign-in" className="nav-signin" onClick={closeMobileMenu}>Sign in</Link>
            </div>
          )}
        </div>
      </nav>

      {showSearch && (
        <div
          className="nav-search-overlay"
          onClick={() => {
            setShowSearch(false);
            setQuery("");
            setResults([]);
          }}
        >
          <div className="nav-search-box" onClick={(e) => e.stopPropagation()}>
            <input
              autoFocus
              value={query}
              placeholder="Search (transport, GWP, machining...)"
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter" && results.length > 0) goTo(results[0].route);
                if (e.key === "Escape") {
                  setShowSearch(false);
                  setQuery("");
                  setResults([]);
                }
              }}
            />

            {results.length > 0 && (
              <ul className="nav-search-results">
                {results.map((item) => (
                  <li key={item.route} onClick={() => goTo(item.route)}>
                    <span className="result-title">{item.title}</span>
                    <span className="result-route">{item.route}</span>
                  </li>
                ))}
              </ul>
            )}

            {query.trim().length >= 2 && results.length === 0 && (
              <div className="nav-search-empty">No results</div>
            )}
          </div>
        </div>
      )}
    </>
  );
}

export default Navbar;
