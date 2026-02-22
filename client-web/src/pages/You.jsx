import { useAuth } from '../contexts/AuthContext'

export default function You() {
    const { user } = useAuth()

    return (
        <div>
            <h1>You</h1>
            <p>Your profile, goals, and settings.</p>
            {user && <p>Logged in as: {user.email}</p>}
        </div>
    )
}
