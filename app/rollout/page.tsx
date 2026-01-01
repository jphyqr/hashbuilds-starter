import { promises as fs } from 'fs';
import path from 'path';

// Parse markdown checkboxes into structured data
function parseRollout(content: string) {
  const phases: Array<{
    name: string;
    status: string;
    tasks: Array<{ name: string; done: boolean; notes: string }>;
  }> = [];

  const lines = content.split('\n');
  let currentPhase: (typeof phases)[0] | null = null;

  for (const line of lines) {
    // Phase header: ## Phase N: Name
    if (line.startsWith('## Phase')) {
      if (currentPhase) phases.push(currentPhase);
      const match = line.match(/## Phase \d+: (.+)/);
      currentPhase = {
        name: match ? match[1] : line.replace('## ', ''),
        status: 'Not Started',
        tasks: [],
      };
    }

    // Task line: | Task | [x] or [ ] | Notes |
    if (line.startsWith('|') && !line.includes('---') && !line.includes('Task')) {
      const parts = line.split('|').map((p) => p.trim()).filter(Boolean);
      if (parts.length >= 2 && currentPhase) {
        const done = parts[1].includes('[x]');
        currentPhase.tasks.push({
          name: parts[0],
          done,
          notes: parts[2] || '',
        });
      }
    }

    // Phase status line
    if (line.includes('**Phase Status:**') && currentPhase) {
      currentPhase.status = line.replace('**Phase Status:**', '').trim();
    }
  }

  if (currentPhase) phases.push(currentPhase);
  return phases;
}

export default async function RolloutPage() {
  // Read the rollout markdown file
  let phases: ReturnType<typeof parseRollout> = [];
  let lastUpdated = '';

  try {
    const filePath = path.join(process.cwd(), 'deliverables', 'rollout.md');
    const content = await fs.readFile(filePath, 'utf-8');
    phases = parseRollout(content);

    // Extract last updated date
    const dateMatch = content.match(/\*\*Last Updated:\*\* (.+)/);
    if (dateMatch) lastUpdated = dateMatch[1];
  } catch {
    // File doesn't exist yet
  }

  const completedPhases = phases.filter((p) => p.status === 'Complete').length;
  const totalPhases = phases.length;
  const progress = totalPhases > 0 ? Math.round((completedPhases / totalPhases) * 100) : 0;

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950 py-12 px-4">
      <div className="max-w-3xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-3xl font-bold mb-2">Project Rollout</h1>
          <p className="text-gray-600 dark:text-gray-400">
            Track our progress toward launch
          </p>
          {lastUpdated && (
            <p className="text-sm text-gray-500 mt-2">
              Last updated: {lastUpdated}
            </p>
          )}
        </div>

        {/* Progress Bar */}
        <div className="mb-12">
          <div className="flex justify-between text-sm mb-2">
            <span>Overall Progress</span>
            <span>{progress}%</span>
          </div>
          <div className="h-3 bg-gray-200 dark:bg-gray-800 rounded-full overflow-hidden">
            <div
              className="h-full bg-green-500 transition-all duration-500"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>

        {/* Phases */}
        <div className="space-y-6">
          {phases.length === 0 ? (
            <div className="text-center py-12 text-gray-500">
              <p>No rollout data yet.</p>
              <p className="text-sm mt-2">
                Update deliverables/rollout.md to see progress here.
              </p>
            </div>
          ) : (
            phases.map((phase, i) => (
              <div
                key={i}
                className="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 overflow-hidden"
              >
                <div className="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center">
                  <h2 className="font-semibold">{phase.name}</h2>
                  <span
                    className={`text-xs px-2 py-1 rounded-full ${
                      phase.status === 'Complete'
                        ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
                        : phase.status === 'In Progress'
                        ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
                        : 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400'
                    }`}
                  >
                    {phase.status}
                  </span>
                </div>
                <div className="px-6 py-4">
                  <ul className="space-y-3">
                    {phase.tasks.map((task, j) => (
                      <li key={j} className="flex items-start gap-3">
                        <span
                          className={`mt-0.5 ${
                            task.done ? 'text-green-500' : 'text-gray-300'
                          }`}
                        >
                          {task.done ? '✓' : '○'}
                        </span>
                        <div>
                          <span
                            className={
                              task.done
                                ? 'text-gray-500 line-through'
                                : 'text-gray-900 dark:text-gray-100'
                            }
                          >
                            {task.name}
                          </span>
                          {task.notes && (
                            <span className="text-sm text-gray-500 ml-2">
                              — {task.notes}
                            </span>
                          )}
                        </div>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Footer */}
        <div className="mt-12 text-center text-sm text-gray-500">
          <p>
            Questions?{' '}
            <a href="mailto:hello@example.com" className="underline">
              Contact us
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}
