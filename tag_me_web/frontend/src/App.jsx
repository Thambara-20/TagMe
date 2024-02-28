import "./App.css";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import Hero from "./pages/Hero";
import About from "./pages/About";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

function App() {
	return (
		<>
			<div className="App">
				<Router>
					<Navbar />
					<Switch>
						<Route path="/" exact component={Hero} />
						<Route path="/about" exact component={About} />
					</Switch>
					<Footer />
				</Router>
			</div>
		</>
	);
}

export default App;
