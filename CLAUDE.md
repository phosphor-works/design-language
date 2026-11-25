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

The design language of the Phosphor suite. It gives one appearance and one motion to each Phosphor app: the Lambent
shell, Facet, Afterglow, and the editor and settings of PlasmaZones. It contains two QML modules and one tool.

| Part | Purpose |
| --- | --- |
| `Phosphor.Design` | The tokens (`Theme`, `Metrics`, `Motion`, `Icons`) and the components that Qt Quick Controls does not have |
| `Phosphor.Style` | A Qt Quick Controls style. An app calls `QQuickStyle::setStyle("Phosphor.Style")` to use it |
| `phosphor-storybook` | Shows each component in each of its states. It loads the QML from this source tree and reloads when a file changes |

The repository is not released, and no app uses it at this time. The apps use Kirigami, plain Qt Quick Controls or
`Phosphor.Widgets`. Each app moves to this repository separately.

## Layout

- `qml/Phosphor/Design/` and `qml/Phosphor/Style/` are the two modules. Each module is QML files and a `qmldir`
  that a person writes. The build compiles none of these files.
- `storybook/` is the tool: the host (`*.cpp`), its QML (`qml/`), the stories (`stories/`) and the tests
  (`tests/`). It also has the stories of shipped components (`stories-phosphor/`) and sample pictures (`assets/`).
- `cmake/` pins the phosphor libraries and adds them to the storybook.
- `mockup/index.html` is the first sketch of this language.
- `.claude/` has the skills and the reviewers of this repository.

## Build and test

| Task | Command |
| --- | --- |
| Configure, build and test with only Qt | `cmake --workflow --preset standalone` |
| Run the tests again | `ctest --preset standalone` |
| Configure with the pinned phosphor libraries | `cmake --preset dev` |
| Configure with the checkouts next to this repository | `cmake --preset local` |
| Build | `systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0 cmake --build --preset dev` |
| Run | `build/storybook/phosphor-storybook` |
| List the stories | `build/storybook/phosphor-storybook --list` |
| Render one story | `build/storybook/phosphor-storybook --story ID --shot shots/ID.png` |
| Check the text | `python3 .claude/skills/dl-write/check_prose.py` |

- The `dl-build` skill gives the details. The `standalone` preset builds in seconds and is sufficient for work in
  `qml/`.
- The tests are `prose` (the text checker) and `stories-render-dark` and `stories-render-light`. The render tests
  load each story without a display and fail on a QML error or a warning.
- CI is the shared C++ CI of the workspace repository (`cpp-ci.yml`), with the `standalone` preset on Arch. No job
  builds the `dev` preset. There is no flake, so the Nix jobs are off.
- Git ignores `shots/`. Put renders there.

## Rules

### Layers

- **The library uses only Qt.** A file in `qml/` imports `QtQuick`, `QtQuick.Templates`, `QtQuick.Shapes`,
  `QtQuick.Effects`, `QtQuick.Controls.impl` and the two modules of this repository. It does not import a phosphor
  library, Kirigami or a KDE Framework. The phosphor-libs repository and each app will depend on this repository,
  so the opposite dependency makes a cycle. Only the storybook builds the phosphor libraries.
- **`Phosphor.Design` does not import `QtQuick.Controls`.** Controls loads the style, and the style imports
  `Phosphor.Design`. Thus that import is a loop. For a button in a component, use `QtQuick.Templates`.

### Tokens and stories

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
  cannot show motion. Tell the user when motion is not verified. Run the tests before you complete a change.
- **Do not write compatibility code.** The repository is not released. Rename a token or a component directly, and
  change its users in the same commit.

### The design language

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
- **The shell has a material.** A surface of the shell uses `Theme.shellSurface`, which is glass or solid
  (`Theme.material`). A window of an app uses `Theme.surface` and is always solid. Do not put an opacity on a
  surface in a component.
- **Springs move, fades color.** A position, a size, a radius or a scale moves on `SnapSpring`, `FlowSpring` or
  `TrailSpring`. A color uses `Tint`, and an opacity uses `Fade`. Do not use a `NumberAnimation` with a duration on
  geometry.
- **Name, value or action.** Each string gives the name of an item, shows a value or tells what a control does.
  Do not write an eyebrow above a title, a tagline, a helper sentence below a control, or a status sentence. Use
  an icon when the icon gives the same information. Put an explanation in a tooltip.
- **Show the state.** Use a fill level, a position or a shape. Do not write a sentence that describes the state.
- **The user sets three values of shape.** The corner radius (`Metrics.corners`), the density (`Metrics.density`)
  and the space between windows (`Metrics.spread`) are inputs. Each radius, height and gap follows them. A preset
  sets them together with a palette.
- **Shape uses `Metrics`.** An inner radius is the outer radius minus the padding. A control that is on is
  rounder.

### License

- Every file is `LGPL-2.1-or-later` (`COPYING.LESSER`), the storybook and the tests included. Apps link the tokens,
  the style and the components.
- `REUSE.toml` gives the license of a file that cannot contain a comment.

### Text

- Component documentation and storybook text are user-facing text.
- The `dl-write` skill has the checker for the writing rules of the conventions. Run it before you complete a
  change that adds text.
- A string in a component follows the Writing page of the guide.

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
- `icon` is a final property of the Qt Quick Controls button template. A `T.AbstractButton` that declares
  `property string icon` does not load. Use a different name, for example `iconName`.

## Skills and agents

The shared skills and reviewers come from the `phosphor-works` plugin. The skills of this repository are in
`.claude/skills/`.

| Skill | Contents |
| --- | --- |
| `dl-build` | The three presets, the pinned phosphor libraries, how to use a branch of them, the memory limit |
| `dl-add-component` | The files that a component changes: the QML, the `qmldir`, the story |
| `dl-verify-render` | How to render a story without a display, what to render, what a render cannot show |
| `dl-write` | The checker for the writing rules, and examples |

The reviewers of this repository are in `.claude/agents/review/`. Each reviewer reports findings for one area. A
reviewer does not build and does not edit.

| Reviewer | Area |
| --- | --- |
| `dl-design-reviewer` | Does a component obey the design language? |
| `dl-qml-reviewer` | Is the QML correct? |
| `dl-build-reviewer` | CMake, the host, the licenses, the Claude setup |

## Other repositories

- workspace: `workspace.repos` lists the repository, so `vcs import` clones it beside the others.
- branding: the canonical palette is `palette/phosphor.toml` in phosphor-works/branding. `Theme.qml` holds a copy of
  its values in `palettes`. Whether a pinned branding release must generate them is not decided. Ask before you
  change how the tokens relate to that palette.
- phosphor-components: its README names the design language's storybook as one of the consumers of the
  `Phosphor.Components` QML module. Its components use Kirigami now, and this language will restyle them.
- phosphor-libs and phosphor-shell-libs: `cmake/DesignDependencies.cmake` pins one commit of each, and only the
  storybook builds them. The `local` preset uses the sibling checkouts. A shipped component that needs a change
  gets a pull request there.
- phosphor-shell-libs makes the real shell surfaces. The surfaces in `storybook/qml/Phosphor/Storybook/Shell/` are
  reference designs. The Paper preset and the Ember preset of the Settings story are the values of phosphor-theme.
- phosphor-libs has `PhosphorMotionAnimation`, which installs a spring as a Bézier approximation with a fixed
  duration. This library uses `SpringAnimation`, because a spring here must accept a new target during a move.

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
| CI | `.github/workflows/ci.yml` calls the shared C++ CI. Its packages are in `.github/ci/arch-packages.txt` |
| The phosphor libraries | `cmake/DesignDependencies.cmake` pins one commit of phosphor-libs and one of phosphor-shell-libs. `cmake/DesignPhosphor.cmake` adds the libraries in dependency sequence |
| Browser mockup | `mockup/index.html`: the first sketch of this language, kept for reference. The QML is the authority |
