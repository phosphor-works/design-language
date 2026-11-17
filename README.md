<!-- SPDX-FileCopyrightText: 2026 fuddlesworth -->
<!-- SPDX-License-Identifier: GPL-3.0-or-later -->

# Phosphor design language

The design language of the [phosphor-works](https://github.com/phosphor-works) apps. It gives one appearance and
one motion to the Lambent shell, Facet, Afterglow, and the editor and settings of PlasmaZones.

| Part | Purpose |
| --- | --- |
| `Phosphor.Design` | The tokens for color, type, space, shape and motion, and the components that Qt Quick Controls does not have |
| `Phosphor.Style` | A Qt Quick Controls style that uses the tokens |
| `phosphor-storybook` | A tool that shows each component in each of its states, with the design guide |

The two modules are QML files in `qml/`. They import only Qt, so an app with a different license can use them.

The repository is not released, and no app uses it at this time.

## Build

The build needs CMake 3.25, Ninja, a C++20 compiler, Python 3 and Qt 6.10 (Quick and Quick Controls).

```sh
cmake --workflow --preset standalone
```

That command configures into `build-standalone/`, builds the storybook and runs the tests. The tests render each
story without a display, in the dark scheme and in the light scheme.

The `dev` preset also builds the phosphor libraries from a PlasmaZones checkout at `../PlasmaZones`. The storybook
then shows the components that ship there next to the components of this repository. When there is no checkout,
the `dev` preset builds the same targets as the `standalone` preset. To use a different checkout, set
`-DPHOSPHOR_DESIGN_PHOSPHOR_DIR=/path/to/PlasmaZones`.

## The storybook

```sh
build-standalone/storybook/phosphor-storybook
```

The storybook loads the QML from the source tree. When you save a file, the storybook loads the QML again and
keeps the current story. The toolbar changes the scheme, the accent, the corner radius, the density and the speed
of motion.

The Foundations group is the design guide: principles, color, typography, spacing, layout, shape, icons, motion,
states, writing and accessibility. Each table in the guide reads its values from the tokens.

```sh
build-standalone/storybook/phosphor-storybook --list
build-standalone/storybook/phosphor-storybook --story controls-button --shot button.png
```

The first command prints the id of each story. The second command renders one story to a file and opens no window.

## Use from an app

`cmake --install` copies the two modules into the QML directory of Qt. An app then selects the style before it
loads its QML:

```cpp
QQuickStyle::setStyle(QStringLiteral("Phosphor.Style"));
```

A QML file gets the tokens and the components with `import Phosphor.Design`.

## License

The modules in `qml/` use LGPL-2.1-or-later. The storybook, the build files and the mockup use GPL-3.0-or-later.
Each file identifies its license. `REUSE.toml` identifies the license of a file that has no header.
The [LICENSES directory](LICENSES) contains the license texts.
