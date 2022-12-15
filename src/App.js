import "./App.css";
import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import Navbar from "./components/Navbar/Navbar";
import Home from "./pages/Home/Home";
import Footer from "./components/Footer/Footer";

function App() {
  setTimeout(() => {
    console.log("%cCaptain Unknown | Web3naut", "color:#53900F; border:20px; font-size: 20px; font-weight: bold;");
    console.log('https://Web3naut.com')
  }, 3000);

  return (
    <>

      <div className="body-content">
        <Navbar/>

        <Router>
          <Routes>
            <Route path="/" element={<Home/>} />
          </Routes>
        </Router>

        <Footer/>
      </div>

    </>
  );
}

export default App;
