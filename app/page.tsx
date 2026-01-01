import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-8">
      <main className="max-w-2xl text-center space-y-8">
        {/* Project Name - Update after filling out project-origin.md */}
        <h1 className="text-4xl font-bold tracking-tight">
          Project Name
        </h1>

        {/* Tagline - Update after filling out business-context.md */}
        <p className="text-xl text-gray-600 dark:text-gray-400">
          Your project tagline here
        </p>

        {/* Status Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-200 text-sm">
          <span className="w-2 h-2 rounded-full bg-yellow-500 animate-pulse" />
          Setting Up Infrastructure
        </div>

        {/* Quick Links */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center pt-4">
          <Link
            href="/rollout"
            className="px-6 py-3 bg-black dark:bg-white text-white dark:text-black rounded-lg font-medium hover:opacity-90 transition"
          >
            View Rollout Status
          </Link>
          <a
            href="https://hashbuilds.com/patterns"
            target="_blank"
            rel="noopener noreferrer"
            className="px-6 py-3 border border-gray-300 dark:border-gray-700 rounded-lg font-medium hover:bg-gray-50 dark:hover:bg-gray-900 transition"
          >
            Design Inspiration
          </a>
        </div>

        {/* Next Steps */}
        <div className="pt-8 text-left bg-gray-50 dark:bg-gray-900 rounded-lg p-6">
          <h2 className="font-semibold mb-4">Next Steps (in order)</h2>
          <ol className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
            <li className="flex gap-2">
              <span className="text-green-500">✓</span>
              Project initialized
            </li>
            <li className="flex gap-2">
              <span className="text-yellow-500">→</span>
              docs/01-project-origin.md
            </li>
            <li className="flex gap-2">
              <span className="text-gray-400">○</span>
              docs/02-business-context.md
            </li>
            <li className="flex gap-2">
              <span className="text-gray-400">○</span>
              docs/03-design-system.md
            </li>
            <li className="flex gap-2">
              <span className="text-gray-400">○</span>
              docs/services/01-database.md
            </li>
            <li className="flex gap-2">
              <span className="text-gray-400">○</span>
              docs/services/02-auth.md
            </li>
          </ol>
          <p className="mt-4 text-xs text-gray-500">
            Each file has embedded prompts. Just ask Claude to read it.
          </p>
        </div>
      </main>

      <footer className="mt-16 text-sm text-gray-500">
        Built with{" "}
        <a
          href="https://hashbuilds.com/claude-code-starter"
          className="underline hover:text-gray-700"
          target="_blank"
          rel="noopener noreferrer"
        >
          hashbuilds-starter
        </a>
      </footer>
    </div>
  );
}
