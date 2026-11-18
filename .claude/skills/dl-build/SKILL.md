---
name: dl-build
description: "Configure, build and run the Phosphor design language and its storybook. Contains the three presets, the pinned phosphor libraries, the memory limit and the warning rule. Also tells how to use a branch that is not merged and how to move a pin. Use when: build, rebuild, configure, run the storybook, does it compile, the pin, a link error."
---

<!--
SPDX-FileCopyrightText: 2026 fuddlesworth
SPDX-License-Identifier: GPL-3.0-or-later
-->

# Build and run the storybook

Run each command from the root of the repository.

## What the build makes

The library in `qml/` is QML files and two `qmldir` files. The build compiles none of them. The only target is
`phosphor-storybook`. It is a small C++ host that loads the QML from the source tree.

Thus a build without errors proves that the host compiles. It proves nothing about a `.qml` file. A QML error
appears when the storybook loads the file. The error goes to stderr. An error in `Main.qml` also shows a red page.
To check QML, use `dl-verify-render`.

## The three presets

| Preset | Directory | What it builds | Use |
| --- | --- | --- | --- |
| `standalone` | `build-standalone` | The host, with only Qt. The build takes seconds | Work in `qml/` and in `storybook/stories/` |
| `dev` | `build` | The host and nine phosphor libraries from the pinned commits. The first build takes approximately four minutes | The stories in `storybook/stories-phosphor/`, which show `Phosphor.Widgets` |
| `local` | `build-local` | The same, from the checkouts at `../phosphor-libs` and `../phosphor-shell-libs` | A branch of those repositories that is not merged |

```sh
cmake --workflow --preset standalone
cmake --preset dev
systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0 cmake --build --preset dev --parallel 6
ctest --preset dev
```

The `--workflow` command configures, builds and runs the tests. CI runs that command in an Arch container
(`.github/workflows/ci.yml`). There are four tests:

| Test | What it checks |
| --- | --- |
| `stories-render-dark`, `stories-render-light` | Each story loads and prints no warning (`storybook/tests/render_stories.py`) |
| `prose` | The text has no error from the checker of `dl-write` |
| `guard` | The cases of `.claude/hooks/test_guard.py` |

Each preset sets `BUILD_TESTING=ON`. Without a preset, the default is `OFF`, and CTest then finds no tests.

Use the memory limit for the `dev` preset. A session frequently runs inside the Afterglow of the user, in its
cgroup. If a build fills the memory, systemd-oomd stops that unit, and the terminal windows of the user close. Run
one build at a time. The `standalone` preset compiles six files and needs no limit.

The files in `storybook/*.cpp` must compile with zero warnings. A warning from a phosphor library belongs to that
library. Report a warning that shows a real defect. Do not edit the checkout.

Before you use a result from a build directory, check its configuration:

```sh
grep -E "^(CMAKE_BUILD_TYPE|PHOSPHOR_DESIGN_[A-Z_]+):" build*/CMakeCache.txt
```

## The phosphor libraries

phosphor-libs and phosphor-shell-libs are separate repositories. `cmake/DesignDependencies.cmake` pins one commit
of each by commit, URL and SHA-256. CPM downloads the two archives one time into `.cache/cpm` at the root of this
repository. `cmake/DesignPhosphor.cmake` then adds nine libraries with `add_subdirectory`, in dependency sequence.
Their tests and their install rules are off. Afterglow uses the same method.

| Variable | Meaning | Default |
| --- | --- | --- |
| `PHOSPHOR_DESIGN_WITH_PHOSPHOR` | Build the phosphor libraries and their stories | Off. The `dev` preset and the `local` preset set it to on |
| `CPM_phosphor-libs_SOURCE` | A phosphor-libs tree to use in place of the pin | Not set. The `local` preset sets it to `../phosphor-libs` |
| `CPM_phosphor-shell-libs_SOURCE` | A phosphor-shell-libs tree to use in place of the pin | Not set. The `local` preset sets it to `../phosphor-shell-libs` |

To show a branch that is not merged:

1. Check out the branch in `../phosphor-libs` or in `../phosphor-shell-libs`. Alternatively, make a worktree of it.
2. Configure and build the `local` preset. For a worktree, set its path:
   `cmake --preset local -DCPM_phosphor-shell-libs_SOURCE=$PWD/../phosphor-shell-libs-BRANCH`.

To move a pin:

1. Select the phosphor-shell-libs commit. Read the phosphor-libs commit in its
   `cmake/PhosphorShellLibsDependencies.cmake`. Use that commit for the phosphor-libs pin, so that the two agree.
2. Download each archive and calculate its hash: `curl -sSfL URL | sha256sum`.
3. Change the VERSION, the URL and the SHA256 of each pin together.
4. Configure the `dev` preset with `--fresh`, build it and run its tests.

To add a library for a story:

1. Add the library to `design_add_phosphor_libs`, after each library that it depends on.
2. Add its QML module target and its plugin target to `design_link_phosphor`.

Only the storybook builds these libraries. The library does not: `qml/` imports nothing from them.

Do not edit a checkout of a different repository from this repository. A change to phosphor-libs, to
phosphor-shell-libs or to PlasmaZones goes through its own pull request.

A build directory keeps `CPM_SOURCE_CACHE` in its cache. If a build directory is older than the pins, configure
it with `--fresh`. Without that, CPM can download into the cache of a different repository.

## Run the storybook

```sh
build/storybook/phosphor-storybook          # opens a window on the display of the user
build/storybook/phosphor-storybook --list   # prints the story ids and opens no window
```

The host watches `qml/` and `storybook/`. When a file changes, the host reloads the QML and prints `Reloaded`. The
host keeps the current story and the toolbar values during a reload. `QSettings` keeps them between runs.

Open a window on the display of the user only when the user asks to see the storybook. To check your own change,
render it without a display (`dl-verify-render`).

The session of the user sets `QT_WAYLAND_SHELL_INTEGRATION=phosphorwayland`. The `dev` build contains its own copy
of that library. When you open a window with the `dev` build, remove the variable:
`env -u QT_WAYLAND_SHELL_INTEGRATION build/storybook/phosphor-storybook`.

## If the build fails

| Symptom | Cause | Action |
| --- | --- | --- |
| The last link reports `*_interface` symbols that are not defined | The generated protocol sources of phosphor-wayland are C, and the C language is off | Make sure that `DesignPhosphor.cmake` calls `enable_language(C)` |
| The message "has no phosphor-..." | The tree is older than the list in `DesignPhosphor.cmake` | With the `local` preset, update the checkout. With the `dev` preset, move the pin |
| A hash error during the configure | An archive is not the pinned archive | Download the archive again and compare its hash with the pin. Do not change the pin to make the error stop |
| clangd reports that `QObject` is not found | There are no compile commands | Configure a preset. The build directory then contains `compile_commands.json` |
