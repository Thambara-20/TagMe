import React from "react";
//rotas
import { BrowserRouter, Routes, Route, HashRouter } from "react-router-dom";
//pages
import Home from "./pages/Home";
import Dashboard from "./pages/Dashboard";
import Contact from "./pages/Contact";
//componentes
import Navbar from "./components/Navbar";
import Footer from "./components/Footer/Footer";

function App() {
  return (
    <>
      <HashRouter>
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/contact" element={<Contact />} />
          <Route path="/dashboard" element={<Dashboard/>} />
        </Routes>
      </HashRouter>
      <Footer />
    </>
  );
}

export default App;
