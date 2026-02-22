import { NavLink } from 'react-router-dom'

const tabs = [
    { path: '/', label: 'WYLO', end: true },
    { path: '/timeline', label: 'Timeline' },
    { path: '/browse', label: 'Browse' },
    { path: '/you', label: 'You' },
]

export default function BottomNav() {
    return (
        <nav className="flex justify-around items-center py-3 border-t border-surface-elevated bg-surface-bg safe-bottom">
            {tabs.map((tab) => (
                <NavLink
                    key={tab.path}
                    to={tab.path}
                    end={tab.end}
                    className={({ isActive }) =>
                        `text-xs font-medium transition-colors ${isActive ? 'text-text-primary' : 'text-text-tertiary hover:text-text-secondary'
                        }`
                    }
                >
                    {tab.label}
                </NavLink>
            ))}
        </nav>
    )
}
