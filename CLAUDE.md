<!-- SPDX-FileCopyrightText: 2026 fuddlesworth -->
<!-- SPDX-License-Identifier: GPL-3.0-or-later -->

# Phosphor design language

This repository gives one appearance and one motion to each Phosphor app: the Lambent shell, Facet, Afterglow,
and the editor and settings of PlasmaZones. It contains two QML modules and one tool.

| Part | Purpose |
| --- | --- |
| `Phosphor.Design` | The tokens (`Theme`, `Metrics`, `Motion`, `Icons`) and the components that Qt Quick Controls does not have |
| `Phosphor.Style` | A Qt Quick Controls style. An app calls `QQuickStyle::setStyle("Phosphor.Style")` to use it |
| `phosphor-storybook` | Shows each component in each of its states. It loads the QML from this source tree and reloads when a file changes |

The repository is not released, and no app uses it at this time. The apps use Kirigami, plain Qt Quick Controls or
`Phosphor.Widgets`. Each app moves to this repository separately.

This file contains the rules that a session gets wrong. The skills contain the procedures.

## Rules

- **The library uses only Qt.** A file in `qml/` imports `QtQuick`, `QtQuick.Templates`, `QtQuick.Shapes`,
  `QtQuick.Effects`, `QtQuick.Controls.impl` and the two modules of this repository. It does not import a phosphor
  library, Kirigami or a KDE Framework. The phosphor-libs repository and each app will depend on this repository,
  so the opposite dependency makes a cycle. Only the storybook builds the phosphor libraries.
- **`Phosphor.Design` does not import `QtQuick.Controls`.** Controls loads the style, and the style imports
  `Phosphor.Design`. Thus that import is a loop. For a button in a component, use `QtQuick.Templates`.
- **Use only tokens.** A component reads `Theme`, `Metrics` and `Motion`. It contains no color, radius, font size,
  gap or duration. If a token is missing, add the token. The one exception is a dimension of the component itself.
  For example, a switch is 44 by 26. Keep such a dimension in the component.
- **The guide reads the tokens.** The Foundations stories are the design guide. Their tables show values from
  `Theme`, `Metrics` and `Motion`. When you add, rename or redefine a token, change its guide page in the same
  commit. Do not type the value of a token into a guide page.
- **Each component has a story, and each state has a variant.** The user examines a change in the storybook. A
  component without a story is not complete (`dl-add-component`).
- **A build is not a test.** The build compiles no QML, so a build without errors tells nothing about the QML.
  Render the stories that a change affects, in the two schemes (`dl-verify-render`). A render shows one frame and
  cannot show motion. Tell the user when motion is not verified. Run the tests before you complete a change. They
  render each story in the two schemes, and CI runs the same tests.
- **Change a different repository only through its own pull request.** The storybook builds libraries from
  phosphor-libs and phosphor-shell-libs. Do not edit a checkout of those repositories or of PlasmaZones from a
  session here. If a shipped component needs a change, tell the user the change and the reason.
- **Do not install, and do not use `sudo`.** Do not run an install target. Do not install system packages. Tell
  the user what is necessary and why. The one exception is `cmake --install` into a temporary directory, to check
  the install layout.
- **Do not write compatibility code.** The repository is not released. Rename a token or a component directly, and
  change its users in the same commit.
- **Use a pull request.** Start each change on a branch from `main`. Do not push to `main`. The user merges.
  Stage files by name.
- **Licenses.** Each file that can contain a comment starts with `SPDX-FileCopyrightText: 2026 fuddlesworth` and
  an `SPDX-License-Identifier`. `qml/**` is `LGPL-2.1-or-later`, so that an app with a different license can use
  it. The storybook, `cmake/`, `mockup/` and the Claude setup are `GPL-3.0-or-later`. `REUSE.toml` gives the
  license of a file that cannot contain a comment.
- **Ask only about real decisions.** When the next step is clear, do it.

## The design language

The Foundations stories contain the full guide. Review a component against these rules.

- **Color shows a state.** A surface is dark and does not move. Use color only for focus, selection, activity or
  an error. The accent is one of the four brand colors. Cyan always shows focus (`FocusRing`, the focused window,
  a cursor). Rose shows an error, a destructive action or an unread item. Use the spectrum only in `Visualizer`,
  on the edge of `ShellBody` and in the logos.
- **An accent fill uses `Theme.ink`.** When a small control is on, its fill is the accent. The current row of a
  list has the `Theme.selected` tint and keeps `Theme.text`.
- **Space is one ramp.** Each gap, inset and margin is a step of `Metrics.spaceRamp`. Use the name when a name
  applies: `gap`, `gapLoose`, `gapSection`, `pad`, `padCard`, `padControl`, `padRow`, `iconGap`, `pageMargin`.
  Related items are near each other. Use space between groups. Use a line only between rows in one card.
- **There are six text sizes and two weights.** The sizes are `textCaption`, `textLabel`, `textBody`, `textRow`,
  `textHeading` and `textTitle`. The weights are 500 and 600. Use sentence case. Do not use uppercase labels or
  letter spacing. `textDisplay` is a seventh size, and only the clock of the lock screen uses it.
- **The states are a fixed set.** Hover is `Theme.hover`. Pressed is `Metrics.pressScale` and not a color. Focus
  is `FocusRing`. On is the accent with ink. Current is `Theme.selected`. Disabled is `Theme.disabled`.
- **A panel opens from its control.** A shell panel opens from the control that the user pressed, and closes into
  it. Use `ShellBody`. Do not use a popup next to the bar.
- **A detail is a page of the same panel.** A Wi-Fi list and the menu of a tray app are pages (`PanelPage`) of the
  panel that the user opened. The details of a resource are an open row. The panel changes size. A second popup
  does not open.
- **A panel has one header or none.** The header (`PanelHeader`) is the name of the page and its main control. A
  first page that needs no name has no header. Do not write a line above the name or a sentence below it.
- **Empty is a state.** Show it with one dim icon in the position of the content. Do not write a sentence.
- **A change shows immediately, and a bar applies it.** In the settings app, the interface is the preview. A bar
  with "Discard" and "Apply" appears while there is a change. Do not write a sentence in that bar.
- **A palette replaces roles, not components.** A preset or a wallpaper sets `Theme.palette` with the role names of
  matugen. A component reads only `Theme`, so it needs no change for a new palette.
- **Springs move, fades color.** A position, a size, a radius or a scale moves on `SnapSpring`, `FlowSpring` or
  `TrailSpring`. A color uses `Tint`, and an opacity uses `Fade`. Do not use a `NumberAnimation` with a duration on
  geometry.
- **Name, value or action.** Each string gives the name of an item, shows a value or tells what a control does.
  Do not write an eyebrow above a title, a tagline, a helper sentence below a control, or a status sentence. Use
  an icon when the icon gives the same information. Put an explanation in a tooltip.
- **Show the state.** Use a fill level, a position or a shape. Do not write a sentence that describes the state.
- **Shape uses `Metrics`.** An inner radius is the outer radius minus the padding. A control that is on is
  rounder.

## Code

- A QML file has the name `PascalCase.qml`. Ids, properties and functions are `camelCase`. A property or a
  function that is not API starts with `_`.
- Each module has a `qmldir` that you edit by hand. A file that is not in the `qmldir` gives the error "is not a
  type" when a different file uses it. List a singleton with `singleton`.
- Use a binding where an assignment is not necessary. Use a typed property, not `var`. Use `required property` in
  a delegate.
- A control that shows no text sets `Accessible.name`. A control shows `FocusRing` for keyboard focus.
- The storybook host (`storybook/*.cpp`) is C++20 with `QT_NO_KEYWORDS` and `QT_NO_CAST_FROM_ASCII`. Use `Q_EMIT`,
  `Q_SIGNALS`, `QStringLiteral` and `QLatin1String`. A member has the name `m_camelCase`.
- A comment tells why, not what. The comment at the top of a component tells its purpose and its use.

## Text

- Write documents, guide pages and comments with the ASD-STE100 principles in the `dl-write` skill. Run its
  checker before you complete a change that adds text.
- A string in a component follows the Writing page of the guide.
- Do not put plans, audit reports or session summaries in the repository.
- A commit subject is an imperative sentence in sentence case, with no prefix and no full stop ("Add the segmented
  control"). The body tells what changed, why, and what you rendered to check it.

## Environment

- The Bash tool runs zsh. Put quotes around a glob that can match nothing. Do not start a word with `=`.
- Put temporary files in the session scratchpad, not in the repository. Git ignores `shots/`. Put renders there.
- Do not use `pkill`, `killall` or `kill $(pgrep -f ...)`. Use `pgrep -a NAME` to list processes. Then use
  `kill PID` for a process that you started from `build/`.
- A session frequently runs inside the Afterglow of the user, in its cgroup. Run the first build of the `dev`
  preset with a memory limit (see the table). Run one build at a time.

## Build and verify

| Task | Command |
| --- | --- |
| Configure, build and test with only Qt | `cmake --workflow --preset standalone` |
| Run the tests again | `ctest --preset standalone` |
| Configure the library only | `cmake --preset standalone` |
| Configure with the pinned phosphor libraries | `cmake --preset dev` |
| Configure with the checkouts next to this repository | `cmake --preset local` |
| Build | `systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0 cmake --build --preset dev --parallel 6` |
| Run | `build/storybook/phosphor-storybook` |
| List the stories | `build/storybook/phosphor-storybook --list` |
| Render one story | `build/storybook/phosphor-storybook --story ID --shot shots/ID.png` |
| Check the text | `python3 .claude/skills/dl-write/check_prose.py` |
| Test the guard | `python3 .claude/hooks/test_guard.py` |

The `dl-build` skill gives the details. The `standalone` preset builds in seconds and is sufficient for work in
`qml/`.

## Where things are

| Area | Files |
| --- | --- |
| Color tokens | `qml/Phosphor/Design/Theme.qml`: the two schemes in `palettes`, the roles, the state colors, `contrast()` |
| Space, size, shape and type tokens | `qml/Phosphor/Design/Metrics.qml`: the space ramp, the sizes, the radii, the lines, the type scale |
| Motion tokens | `qml/Phosphor/Design/Motion.qml`: the springs and the fades |
| Icons | `qml/Phosphor/Design/Icons.qml`: the icons as path data |
| Components | `qml/Phosphor/Design/*.qml`, in the list of `qml/Phosphor/Design/qmldir` |
| Controls style | `qml/Phosphor/Style/*.qml`, one file for each Qt Quick Controls type, in the list of its `qmldir`. A type with no file uses the Basic style |
| The design guide | `storybook/stories/01-Foundations/NN-Name.qml`: principles, color, typography, spacing, layout, shape, icons, motion, states, writing, accessibility. The number sets the sequence in the sidebar |
| Storybook host | `storybook/main.cpp` (the window, the reload, `--shot`), `storybook/session.*` (the data that a reload keeps) |
| Storybook QML | `storybook/qml/Main.qml`, and `storybook/qml/Phosphor/Storybook/` (`Story`, `Variant`, `Doc`, `Spec`, `DoDont`) |
| Stories | `storybook/stories/NN-Group/Name.qml`. The directory is the group and the file is the story |
| Shell surfaces | `storybook/qml/Phosphor/Storybook/Shell/`: each panel, dialog and screen of the shell, made from `Phosphor.Design` with sample data. They are reference designs. The shell libraries make the real surfaces. `storybook/stories/03-Shell/` shows each state, and the Desktop story puts the panels on one bar |
| App windows | `storybook/qml/Phosphor/Storybook/Apps/`: the settings app and the terminal as reference designs in `WindowFrame`. `storybook/stories/04-Apps/` shows them. The settings window changes the real theme of the storybook |
| Sample pictures | `storybook/assets/`: small covers that a script drew from the brand colors |
| Stories of shipped components | `storybook/stories-phosphor/`. Only the `dev` preset builds them |
| Tests | `storybook/tests/render_stories.py` renders each story. `CMakeLists.txt` and `storybook/CMakeLists.txt` register the tests |
| CI | `.github/workflows/ci.yml`, with its packages in `.github/ci/arch-packages.txt` |
| The phosphor libraries | `cmake/DesignDependencies.cmake` pins one commit of phosphor-libs and one of phosphor-shell-libs. `cmake/DesignPhosphor.cmake` adds the libraries in dependency sequence |
| Browser mockup | `mockup/index.html`: the first sketch of this language, kept for reference. The QML is the authority |

## Skills and agents

The skills are in `.claude/skills/`.

| Skill | Contents |
| --- | --- |
| `dl-build` | The three presets, the pinned phosphor libraries, how to use a branch of them, the memory limit |
| `dl-add-component` | The files that a component changes: the QML, the `qmldir`, the story |
| `dl-verify-render` | How to render a story without a display, what to render, what a render cannot show |
| `dl-write` | The writing rules (ASD-STE100 principles) and the checker |
| `code-audit` | The audit and fix loop, with the `dl-*-reviewer` agents |
| `record-lesson` | Where to record a lesson, so that the next session finds it |

The reviewers are in `.claude/agents/review/`. Each reviewer reports findings for one area. A reviewer does not
build and does not edit.

| Reviewer | Area |
| --- | --- |
| `dl-design-reviewer` | Does a component obey the design language? |
| `dl-qml-reviewer` | Is the QML correct? |
| `dl-build-reviewer` | CMake, the host, the licenses, the Claude setup |

## Lessons that cost a session

- phosphor-wayland compiles generated Wayland protocol sources, and these are C. With only C++ enabled, CMake
  ignored them without a message. The last link then failed with `*_interface` symbols that were not defined.
  `cmake/DesignPhosphor.cmake` calls `enable_language(C)` for that reason. When a phosphor library links with
  missing symbols, make sure that the project enables the language of its sources.
- Qt sends its messages to the journal when stderr is not a terminal. Each story rendered with no warnings while
  `Meter.qml` did not load, and its story showed an empty area. The host now sets `QT_FORCE_STDERR_LOGGING`. When
  you run `qml6` or a different Qt program from a script, set that variable in the command. Without it, no output
  proves nothing.
- `SpringAnimation` does not accept omega and zeta. It moves one step each 16 ms with
  `v += spring * distance - damping * v`. The simple conversion (`omega^2 * step`, `2 * zeta * omega * step`)
  rendered correctly and was wrong. A measured step response got to its target in 337 ms, and the correct value is
  231 ms. The overshoot was almost zero. `Motion.springFor` and `Motion.dampingFor` now match the poles, and the
  same measurement gives 226 ms. Measure motion with `spring-probe.qml` in the `dl-verify-render` skill. A render
  cannot show that a spring is wrong.
- `SpringAnimation` moves a maximum of one step each 16 ms on every display. Thus on a 120 Hz or 144 Hz display a
  spring moves approximately 62 times each second. A replacement must be a C++ animation type, because a
  `Behavior` accepts no other type. Only the three wrappers (`SnapSpring`, `FlowSpring`, `TrailSpring`) will
  change.
- `PhosphorMotionAnimation`, in phosphor-animation, installs a spring as a Bézier approximation with a fixed
  duration on a property animation. Its header tells this. This library uses `SpringAnimation`, because a spring
  here must accept a new target during a move.
- The user reported that stories stopped the window for seconds. No story was slow: each opens in less than one
  second. A different build used all the processors, and a story loaded in one step on the interface thread. The
  canvas now loads a story in parts (`asynchronous`), and `--tour` measures each story in one window. When the user
  reports a slow interface, read `uptime` before you look for a slow component.
- `icon` is a final property of the Qt Quick Controls button template. A component that is a `T.AbstractButton`
  and declares `property string icon` does not load. Use a different name, for example `iconName`.
