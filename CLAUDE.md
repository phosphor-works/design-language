<!-- SPDX-FileCopyrightText: 2026 Phosphor Works Team -->
<!-- SPDX-License-Identifier: LGPL-2.1-or-later -->

<!-- BEGIN shared: tools/sync writes this block from workspace/sync/claude-header.md. Change it there. -->
# design-language

This file has two parts. The rules that every phosphor-works repository follows come first, from the conventions of
the workspace repository, imported below. The sections after them belong to this repository only: what it is, its
layout, how to build and test it, and its own rules, code, skills and agents, and links to the other repositories.
A section here does not repeat a convention. When a section and the conventions disagree, change one of them so
that they agree.

The Claude Code tooling comes from the plugins that `.claude/settings.json` enables and `workspace/tools/setup`
installs. The `phosphor-works` plugin has the command guard, the shared skills (`phosphor-works:build`, `debug`,
`code-audit`, `record-lesson`, `new-repo`), the shared reviewers, and the lesson index, which adds the lessons that
fit each prompt.

@../workspace/claude/conventions.md
<!-- END shared -->

## Overview

The design language of the Phosphor suite. Its README gives the planned scope: color, type, space and motion tokens,
a Qt Quick Controls style, QML components and a storybook that runs them live. The repository holds only that
README now.

## Layout

The repository holds only `README.md`, its license (`COPYING.LESSER`) and this file. There is no source yet.

## Build and test

There is no build, no CI and no tests yet.

## Rules

- The license is `LGPL-2.1-or-later` (`COPYING.LESSER`), as for the suite's libraries: apps link the tokens,
  the Qt Quick Controls style and the components. Every file that can hold a comment carries the SPDX header.
- Component documentation and storybook text are user-facing text.
- When the first code lands, add its layout, its build and test commands and its CI to this file.

## Other repositories

- workspace: `workspace.repos` lists the repository, so `vcs import` clones it beside the others.
- branding: the canonical palette is `palette/phosphor.toml` in phosphor-works/branding. The website, PlasmaZones
  and Lambent pin a branding release, and the bots copy its colors. How the color tokens here relate to that palette
  is not decided yet. Ask before you define one.
- phosphor-components: its README names the design language's storybook as one of the consumers of the
  `Phosphor.Components` QML module.
