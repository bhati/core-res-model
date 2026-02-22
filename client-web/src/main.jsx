import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import './index.css'
import App from './App'
import { AuthProvider } from './contexts/AuthContext'

// ---------------------------------------------------------------------------
// Smooth keyboard-aware viewport: keeps --vh-visual in sync with the visual
// viewport height by polling via requestAnimationFrame while an input is
// focused. This gives per-frame accuracy during the iOS keyboard animation.
// ---------------------------------------------------------------------------
if (window.visualViewport) {
  const vv = window.visualViewport
  let rafId = null
  let polling = false

  const sync = () => {
    document.documentElement.style.setProperty('--vh-visual', `${vv.height}px`)
  }

  const poll = () => {
    sync()
    if (polling) rafId = requestAnimationFrame(poll)
  }

  const startPolling = () => {
    if (polling) return
    polling = true
    poll()
  }

  const stopPolling = () => {
    polling = false
    if (rafId !== null) { cancelAnimationFrame(rafId); rafId = null }
    sync()
  }

  document.addEventListener('focusin', (e) => {
    const t = e.target
    if (t instanceof HTMLInputElement || t instanceof HTMLTextAreaElement || t instanceof HTMLSelectElement) {
      startPolling()
    }
  })

  document.addEventListener('focusout', (e) => {
    const t = e.target
    if (t instanceof HTMLInputElement || t instanceof HTMLTextAreaElement || t instanceof HTMLSelectElement) {
      setTimeout(stopPolling, 300)
    }
  })

  vv.addEventListener('resize', sync)
  sync()
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <AuthProvider>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </AuthProvider>
  </StrictMode>,
)
