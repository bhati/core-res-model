import { useAuth } from '../contexts/AuthContext'

export default function You() {
    const { user } = useAuth()

    return (
        <div className="text-center pt-12">
            <h1 className="text-text-primary text-xl font-bold mb-2">You</h1>
            <p className="text-text-secondary text-sm">Your profile, goals, and settings.</p>
            {user && (
                <p className="text-text-tertiary text-xs mt-4">
                    {user.is_anonymous ? 'Anonymous user' : user.email}
                </p>
            )}
        </div>
    )
}
