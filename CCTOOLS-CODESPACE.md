> **Note for this repo:** the setup files already live here in `nextjs-ai-chatbot` (added 2026-11-26), so skip Setup steps 1-2 below - just create a Codespace on this repo (step 3) and continue from there.

# Canton Devkit — CCTools campaign on GitHub Codespaces

A ready-to-use Codespace setup for the Bit Dynamics **CCTools campaign**
(`canton-devkit` prerelease **v0.18.2-cctools.1**). It spins up a full
local Canton network via Docker, with a web UI, token demos and an
explorer — local development only, not production or real funds.

Campaign doc:
https://github.com/bitdynamics-ab/canton-devkit/blob/v0.18.2-cctools.1/docs%2Fcctools-campaign.md

## What this pack is

- `.devcontainer/devcontainer.json` — Ubuntu base image plus the
  Docker-in-Docker feature (`ghcr.io/devcontainers/features/docker-in-docker:2`),
  so Docker runs inside the Codespace. It runs `setup.sh` on creation.
- `.devcontainer/setup.sh` — installs the **pinned campaign release**
  (`VERSION=0.18.2-cctools.1`), verifies it, and backs up the campaign
  code to `campaign-id-backup.txt` in the workspace.
- `.gitignore` — keeps that backup out of git.

## Setup (about 10 minutes of clicking, then the install runs itself)

1. Create a **new empty repo** on GitHub, e.g. `canton-devkit-codespace`.
   (A repo of your own is needed because Codespaces opens a repo — this
   does not belong in Bit Dynamics' repo, and it keeps the campaign code
   separate from Canton Node.)
2. Upload these files (`.devcontainer/`, `.gitignore`, this README) and commit.
3. On GitHub: **Code → Codespaces → Create codespace on main**.
   Pick the **4-core / 16 GB** machine if your plan offers it — a local
   Canton network (validator, sequencer, mediator, database) is heavy and
   a 2-core box will likely crawl or run out of memory.
4. Wait for the container to build. `setup.sh` runs automatically; check
   its output shows `v0.18.2-cctools.1` and a `campaign code: CCT-…` line.
   If the build finishes before you look, re-run it with
   `bash .devcontainer/setup.sh` — it is safe to run again.

## Run the demo

```bash
canton-devkit localnet doctor
canton-devkit localnet up cctools-demo
canton-devkit localnet status cctools-demo
canton-devkit localnet token demo --instance cctools-demo
canton-devkit localnet token balances --instance cctools-demo
canton-devkit localnet ui
```

Open the loopback URL the last command prints — Codespaces forwards
that port for you. Select `cctools-demo`, inspect Overview / Tokens /
Explorer, and try **Share**. Review any captured image before posting;
share only screenshots from this demo environment, never anything with
credentials or private data. **Report issue** opens GitHub with the
running version prefilled.

Stop the UI with Ctrl+C. Stop the demo while keeping its data:

```bash
canton-devkit localnet down cctools-demo
```

(`localnet down` keeps the data, so you can bring it back up later —
handy, since Codespaces stops after ~30 idle minutes and bills hours
while running. To delete the demo permanently:
`canton-devkit localnet remove cctools-demo`.)

## Watch-outs

- **Storage is tight.** The campaign doc recommends 20 GB free; a free
  Codespace has 32 GB total, and the Docker images plus network data eat
  into that fast. Don't keep other heavy stuff in the same Codespace.
- **Campaign code backup.** `campaign-id-backup.txt` is created in the
  workspace by `setup.sh` and is git-ignored. If the Codespace is ever
  rebuilt, `~/.canton-devkit/campaign-id` is lost — copy the backup
  somewhere safe (or restore it to that path) before rebuilding.
- **No rewards are promised.** The campaign doc frames this purely as
  feedback/testing — treat any payoff as unconfirmed unless Bit Dynamics
  says otherwise elsewhere.
- **PATH note.** The installer puts the binary in `~/.local/bin`. If a
  fresh terminal says `canton-devkit: command not found`, run
  `export PATH="$HOME/.local/bin:$PATH"` first.
