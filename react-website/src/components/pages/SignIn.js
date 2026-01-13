import React from "react";
import "./SignIn.css";

export default function SignIn() {
  const handleSubmit = (e) => {
    e.preventDefault();

    // TODO: connect to your backend later
    // const email = e.target.email.value;
    // const password = e.target.password.value;

    alert("Sign in clicked (connect backend later)");
  };

  return (
    <div className="signin">
      <div className="signin__left">
        <h1 className="signin__title">Sign in</h1>

        <form className="signin__form" onSubmit={handleSubmit}>
          <label className="signin__label" htmlFor="email">
            Username or email address
          </label>
          <input
            id="email"
            name="email"
            type="text"
            className="signin__input"
            placeholder="Username or email address"
            required
          />

          <label className="signin__label" htmlFor="password">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            className="signin__input"
            placeholder="Password"
            required
          />

          <button type="submit" className="signin__button">
            Sign in
          </button>

          <div className="signin__footer">
            <button
              type="button"
              className="signin__link"
              onClick={() => alert("Add your forgot password page later")}
            >
              Forgotten password?
            </button>

            <button
              type="button"
              className="signin__link"
              onClick={() => alert("Add your create account page later")}
            >
              Create account
            </button>
          </div>
        </form>
      </div>

      <div className="signin__right" aria-hidden="true" />
    </div>
  );
}
