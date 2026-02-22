import { BrowserRouter, Routes, Route, NavLink } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import Wylo from './pages/Wylo'
import Timeline from './pages/Timeline'
import Browse from './pages/Browse'
import You from './pages/You'
import './App.css'

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <div className="app">
          <main className="app-main">
            <Routes>
              <Route path="/" element={<Wylo />} />
              <Route path="/timeline" element={<Timeline />} />
              <Route path="/browse" element={<Browse />} />
              <Route path="/you" element={<You />} />
            </Routes>
          </main>

          <nav className="app-nav">
            <NavLink to="/" end>WYLO</NavLink>
            <NavLink to="/timeline">Timeline</NavLink>
            <NavLink to="/browse">Browse</NavLink>
            <NavLink to="/you">You</NavLink>
          </nav>
        </div>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
