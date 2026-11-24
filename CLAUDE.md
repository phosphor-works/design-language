<!-- SPDX-FileCopyrightText: 2026 fuddlesworth -->
<!-- SPDX-License-Identifier: LGPL-2.1-or-later -->

# design-language

The design language of the Phosphor suite. Its README gives the planned scope: color, type, space and motion tokens,
a Qt Quick Controls style, QML components and a storybook that runs them live. The repository holds only that
README now.

The rules every phosphor-works repository follows come from the workspace repository, imported below. This file adds
design-language's own. The shared Claude Code tooling (the command guard, `phosphor-works:code-audit`, the shared
reviewers, the lesson index) comes from the `phosphor-works` plugin, which `.claude/settings.json` enables and
`workspace/tools/setup` installs.

@../workspace/claude/conventions.md

## State

- The repository holds only `README.md`, its license and this file. There is no source, no build, no CI and no tests.
- The license is `LGPL-2.1-or-later` (`COPYING.LESSER`), as for the suite's libraries: apps link the tokens,
  the Qt Quick Controls style and the components. Every file that can hold a comment carries the SPDX header.
- `workspace.repos` lists the repository, so `vcs import` clones it beside the others.

When the first code lands, add its layout, its build and test commands and its CI to this file.

## Other repositories

- branding: the canonical palette is `palette/phosphor.toml` in phosphor-works/branding. The website, PlasmaZones
  and Lambent pin a branding release, and the bots copy its colors. How the color tokens here relate to that palette
  is not decided yet. Ask before you define one.
- phosphor-components: its README names the design language's storybook as one of the consumers of the
  `Phosphor.Components` QML module.

## Writing

Component documentation and storybook text are user-facing text.
