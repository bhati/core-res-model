export default function AppShell({ children }) {
    return (
        <div className="relative bg-surface-bg overflow-hidden w-full h-visual mx-auto max-w-[480px]">
            <div className="h-full w-full overflow-y-auto overflow-x-hidden">
                {children}
            </div>
        </div>
    )
}
