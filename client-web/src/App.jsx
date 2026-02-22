import { Routes, Route, Navigate } from 'react-router-dom'
import AppShell from './components/AppShell'
import BottomNav from './components/BottomNav'

import Wylo from './pages/Wylo'
import Timeline from './pages/Timeline'
import Browse from './pages/Browse'
import You from './pages/You'

function App() {
  return (
    <div className="min-h-dvh bg-surface-bg">
      <AppShell>
        <div className="flex flex-col h-full">
          <main className="flex-1 px-4 pt-6 pb-4">
            <Routes>
              <Route path="/" element={<Wylo />} />
              <Route path="/timeline" element={<Timeline />} />
              <Route path="/browse" element={<Browse />} />
              <Route path="/you" element={<You />} />
              <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
          </main>
          <BottomNav />
        </div>
      </AppShell>
    </div>
  )
}

export default App
