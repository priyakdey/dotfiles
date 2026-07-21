# Tooling defaults
Primary stacks — prefer these toolchains unless I say otherwise:
- Java: Spring Boot; Gradle for build.
- Go.
- C.
- Python: FastAPI; uv for project/build tooling; ruff for formatting and linting.
- Web: JavaScript/TypeScript, React, Vite, pnpm.

# Communication
- Terse, expert-level. No hand-holding, no restating my question, no fundamentals unless asked.
- When a task is ambiguous or has multiple valid approaches, ask before choosing.

# Git
- Never commit or push unless I explicitly ask.
- Commit messages: Conventional Commits (feat:/fix:/chore:...), imperative, lowercase subject.
- Always one-line subject + body. Body is precise and concise: the what and the why, no fluff.
- Show me the proposed commit message for review before committing.

# Code
- Doc comments on exported/public APIs; brief comments on non-obvious logic. No comment noise on trivial code.
- Don't over-engineer. No speculative abstractions, no features I didn't ask for.

# Hard rules
- Never force-push. Never edit git history that has been pushed.
- Never touch credentials/secrets files (.env, *.pem, auth.json, .credentials.json).
- Never rm -rf outside the current repo/workspace.
- Never modify CI config unprompted.
- Always run tests before claiming work is done.
