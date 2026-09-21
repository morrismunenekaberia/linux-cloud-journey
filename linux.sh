#!/usr/bin/env bash
#
# create-linux-cloud-journey.sh
# Creates the linux-cloud-journey directory structure with placeholder files.
#
# Usage:
#   ./create-linux-cloud-journey.sh [target-directory]
#
# If no target directory is given, it creates ./linux-cloud-journey in the
# current working directory.

set -euo pipefail

ROOT="${1:-linux-cloud-journey}"

echo "Creating project structure under: $ROOT"

# Top-level
mkdir -p "$ROOT"
touch "$ROOT/README.md"

# 01-linux
mkdir -p "$ROOT/01-linux/commands"
mkdir -p "$ROOT/01-linux/filesystem"
mkdir -p "$ROOT/01-linux/permissions"
mkdir -p "$ROOT/01-linux/networking"
mkdir -p "$ROOT/01-linux/processes"
mkdir -p "$ROOT/01-linux/systemd"

# 02-programming
mkdir -p "$ROOT/02-programming/java"
mkdir -p "$ROOT/02-programming/javascript"
mkdir -p "$ROOT/02-programming/nodejs"
mkdir -p "$ROOT/02-programming/python"
mkdir -p "$ROOT/02-programming/sql"

# 03-development-tools
mkdir -p "$ROOT/03-development-tools/git"
mkdir -p "$ROOT/03-development-tools/github"
mkdir -p "$ROOT/03-development-tools/vscode"
mkdir -p "$ROOT/03-development-tools/terminal"

# 04-containers
mkdir -p "$ROOT/04-containers/docker"
mkdir -p "$ROOT/04-containers/docker-compose"

# 05-cloud
mkdir -p "$ROOT/05-cloud/aws"
mkdir -p "$ROOT/05-cloud/azure"
mkdir -p "$ROOT/05-cloud/gcp"
mkdir -p "$ROOT/05-cloud/cloud-concepts"

# 06-devops
mkdir -p "$ROOT/06-devops/ci-cd"
mkdir -p "$ROOT/06-devops/github-actions"
mkdir -p "$ROOT/06-devops/infrastructure-as-code"
mkdir -p "$ROOT/06-devops/monitoring"

# 07-projects
mkdir -p "$ROOT/07-projects/project-01"
mkdir -p "$ROOT/07-projects/project-02"
mkdir -p "$ROOT/07-projects/project-03"

# 08-troubleshooting
mkdir -p "$ROOT/08-troubleshooting/linux"
mkdir -p "$ROOT/08-troubleshooting/git"
mkdir -p "$ROOT/08-troubleshooting/docker"
mkdir -p "$ROOT/08-troubleshooting/networking"
mkdir -p "$ROOT/08-troubleshooting/general"

# 09-errors
mkdir -p "$ROOT/09-errors"
touch "$ROOT/09-errors/error-log.md"
touch "$ROOT/09-errors/solved-errors.md"

# 10-testing
mkdir -p "$ROOT/10-testing/experiments"
mkdir -p "$ROOT/10-testing/benchmarks"
mkdir -p "$ROOT/10-testing/test-results"

# 11-ideas
mkdir -p "$ROOT/11-ideas"
touch "$ROOT/11-ideas/project-ideas.md"
touch "$ROOT/11-ideas/automation-ideas.md"
touch "$ROOT/11-ideas/things-to-investigate.md"

# 12-notes
mkdir -p "$ROOT/12-notes"
touch "$ROOT/12-notes/concepts.md"
touch "$ROOT/12-notes/definitions.md"
touch "$ROOT/12-notes/useful-resources.md"

# 13-career
mkdir -p "$ROOT/13-career"
touch "$ROOT/13-career/skills.md"
touch "$ROOT/13-career/certifications.md"
touch "$ROOT/13-career/projects.md"

echo "Done. Structure created at: $ROOT"

# Optional: show the tree if the 'tree' command is available
if command -v tree >/dev/null 2>&1; then
  tree "$ROOT"
fi
