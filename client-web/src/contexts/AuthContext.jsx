import { createContext, useContext, useEffect, useRef, useState } from 'react'
import { supabase } from '../lib/supabase'

const AuthContext = createContext(null)

const TURNSTILE_SITE_KEY = import.meta.env.VITE_TURNSTILE_SITE_KEY

function getCaptchaToken() {
    return new Promise((resolve, reject) => {
        if (!window.turnstile) {
            reject(new Error('Turnstile not loaded'))
            return
        }

        const container = document.createElement('div')
        container.style.display = 'none'
        document.body.appendChild(container)

        window.turnstile.render(container, {
            sitekey: TURNSTILE_SITE_KEY,
            size: 'invisible',
            callback: (token) => {
                document.body.removeChild(container)
                resolve(token)
            },
            'error-callback': () => {
                document.body.removeChild(container)
                reject(new Error('Turnstile challenge failed'))
            },
        })
    })
}

export function AuthProvider({ children }) {
    const [session, setSession] = useState(null)
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        supabase.auth.getSession().then(async ({ data: { session } }) => {
            if (!session) {
                try {
                    const captchaToken = await getCaptchaToken()
                    const { data, error } = await supabase.auth.signInAnonymously({
                        options: { captchaToken }
                    })
                    if (!error) {
                        setSession(data.session)
                    }
                } catch (err) {
                    console.error('Anonymous sign-in failed:', err)
                }
            } else {
                setSession(session)
            }
            setLoading(false)
        })

        const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
            setSession(session)
        })

        return () => subscription.unsubscribe()
    }, [])

    return (
        <AuthContext.Provider value={{ session, loading, user: session?.user ?? null }}>
            {children}
        </AuthContext.Provider>
    )
}

export function useAuth() {
    const context = useContext(AuthContext)
    if (!context) throw new Error('useAuth must be used within AuthProvider')
    return context
}
