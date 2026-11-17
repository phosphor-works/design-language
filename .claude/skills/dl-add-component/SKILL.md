---
name: dl-add-component
description: "Add or change a component, a control, a token or an icon of the Phosphor design language, with its story. Contains the qmldir entry, the import rules, the tokens and the motion rules. Also contains the accessibility rules and the variants that a story needs. Use when: add a component, new control, style a Qt Quick Controls type, add a token, add an icon, write a story, restyle."
---

<!--
SPDX-FileCopyrightText: 2026 fuddlesworth
SPDX-License-Identifier: GPL-3.0-or-later
-->

# Add a component

A component is complete when it has its file, its `qmldir` line and a story with a variant for each state.

## Select the module

| The item | Its location | Its base |
| --- | --- | --- |
| A type that Qt Quick Controls has (`Button`, `Dialog`, `SpinBox`) | `qml/Phosphor/Style/<Type>.qml`, with the exact name of the type | `import QtQuick.Templates as T` and `T.<Type>` |
| An item that Controls does not have (a tile, a segmented control) | `qml/Phosphor/Design/<Name>.qml` | `Item`, or a `T.` template when the item is a button or a slider |
| A value that more than one component reads | `Theme.qml`, `Metrics.qml` or `Motion.qml` | |
| An icon | `Icons.qml` | |

A type with no file in `Phosphor.Style` uses the Basic style of Qt and looks wrong. The Controls stories show such
a type.

## Procedure

1. Write the file. Start with the SPDX header (`LGPL-2.1-or-later` in `qml/`).
2. Write a comment at the top that tells the purpose of the component and its use.
3. Add the file to the `qmldir` of its module: `Name 1.0 Name.qml`. For a singleton, write
   `singleton Name 1.0 Name.qml`.
4. Write the story in `storybook/stories/NN-Group/Name.qml` (`GPL-3.0-or-later`).
5. Render the story in the two schemes (`dl-verify-render`).
6. Check the text (`dl-write`).

The storybook loads modules from the source tree. A file that is not in the `qmldir` gives the error "Name is not
a type" only when a different file uses it. The directory name of a story is its group, and the number sets its
position in the sidebar. A new story file appears in the storybook without a restart.

## Imports

| Module | It can import | It cannot import |
| --- | --- | --- |
| `Phosphor.Design` | `QtQuick`, `QtQuick.Templates`, `QtQuick.Shapes`, `QtQuick.Effects` | `QtQuick.Controls`, a phosphor library, Kirigami, a KDE Framework |
| `Phosphor.Style` | `Phosphor.Design`, `QtQuick.Templates`, `QtQuick.Controls.impl` (for `IconLabel` and `PlaceholderText`) | A phosphor library, Kirigami, a KDE Framework |

Controls loads the style, and the style imports `Phosphor.Design`. Thus an import of Controls in `Phosphor.Design`
is a loop. Use `T.AbstractButton`, `T.Button` or `T.Slider`.

If a component must contain a styled control, give it a slot: a `default property alias`. For example,
`SettingRow` and `NotificationCard` accept a real `Button` through a slot.

## Tokens

The guide is the reference. The Color, Typography, Spacing, Layout, Shape and States pages list the tokens and
their uses.

| Kind | Rule |
| --- | --- |
| Color | Use `Theme`. Do not write a color value. `"transparent"` is the one exception |
| An accent fill | Its content uses `Theme.ink` |
| The current row of a list | Use `Theme.selected`. The row keeps `Theme.text` |
| A color with a different opacity | `Theme.tint(color, alpha)` |
| A new color pair | Measure it with `Theme.contrast(a, b)`. Text must have 4.5 |
| Space | Use `Metrics` by name: `gap`, `gapLoose`, `gapSection`, `pad`, `padCard`, `padControl`, `padRow`, `iconGap`. If no name applies, use a step, `space2` to `space48` |
| A distance that is not on the ramp | It is a dimension of the component. Keep it in the component |
| Type | `Metrics.fontUi` or `fontMono`. One of `textCaption`, `textLabel`, `textBody`, `textRow`, `textHeading`, `textTitle`. `weightBody` or `weightStrong` |
| A paragraph | Also set the `line*` height that agrees with the size, with `lineHeightMode: Text.FixedHeight` |
| Radius | `radiusInner`, `radiusControl`, `radiusCard`, `radiusSurface`. A radius immediately inside a second radius is the outer radius minus the padding. A pill is `height / 2` |
| Height | Use `controlHeight`, `fieldHeight`, `rowHeight`, `listRowHeight`, `navRowHeight`, `tileHeight` or `barHeight`. The compact density then applies |
| Icon size | `iconSmall`, `iconSize` or `iconLarge` |
| A target | The minimum size is `targetMin` |
| Disabled | `opacity: enabled ? 1 : Theme.disabled` |
| A line | `Metrics.lineWidth` in `Theme.line` |

If a token is missing, add it to the singleton. Write a comment that tells its use. Add a row to the guide page
for its kind. Do not write a literal value.

## Motion

| The change | Use |
| --- | --- |
| A press, a toggle, a small control | `Behavior on scale { SnapSpring { epsilon: 0.002 } }` |
| A surface, a radius, the size of a fill | `FlowSpring {}` |
| An item that follows a different item | `TrailSpring {}` |
| A color | `Behavior on color { Tint {} }` |
| An opacity | `Behavior on opacity { Fade {} }` |

- Give a spring on `scale` or `opacity` a small `epsilon` (0.002). The default is for pixels and stops a scale
  before its target.
- A fill that follows a drag must not be behind the pointer. Set `enabled: !control.pressed` on its `Behavior`.
- For a selection in a group of items, use a `StretchIndicator`. Set its `target` to the chosen item. Do not write
  a second highlight that moves.
- A control becomes smaller when the user presses it: `scale: down ? Metrics.pressScale : 1`.
- For a spring with different values, use `Motion.springFor(omega, zeta)` and `Motion.dampingFor(omega, zeta)`. Do
  not multiply `spring` or `damping` by a constant.

## Accessibility

- A control that shows no text sets `Accessible.name`. `IconButton` uses its `text`.
- For keyboard focus, put a `FocusRing` in the background. Set `around` to the radius of the background.
- A control that does not use a template sets `Accessible.role` and handles its keys. `Segmented` is an example.

## Words

Each string in a component gives the name of an item, shows a value or tells what a control does. A component has
no subtitle property, no description line and no slot for an explanation. A caller that must explain an item uses
a tooltip. The Writing page of the guide gives the rules.

## The story

```qml
import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Off"
        surface: true          // this component is always on a shell surface

        Tile { icon: "moon"; text: "Do not disturb"; onToggled: checked = !checked }
    }
}
```

- Write one `Variant` for each state that a reviewer must see: each visual state, disabled, the longest
  practical text. Include a state that a press cannot cause in a capture: busy, open, an error.
- The name of a variant is the state, in a small number of words. The title shows the name of the component.
- Use the content that the component will contain: a network name, a real setting. Do not use placeholder text.
- Make a variant operate when the user presses it. Then the user can see the motion in the storybook.
- For a story that is one scene, use an `Item` root with `property bool fill: true`. The Desktop story is an
  example.
- A surface of the shell is not a library component. Put it in `storybook/qml/Phosphor/Storybook/Shell/` with
  sample data, and add it to the `qmldir` there. Give it one property for each state, so that a story can show the
  state. Put a part that two surfaces use in `Phosphor.Design`.
- `Session.capture` is true during a `--shot` run. Use it to start in the state that the capture must show. Also
  use it to stop an item that does not become stable.
- A guide page uses `Doc` with `Heading` and `Para`. Use `Spec` for a table and `DoDont` for a pair of examples.
- A table of tokens reads its values from the singletons. Do not type a value into the guide.
- A setting on a page is a `SettingRow` in a `SettingGroup`.

## An icon

1. Add the icon to `_build()` in `Icons.qml` as SVG path data on the 24 unit grid.
2. Use a stroke of 1.7 units with round caps and round joins.
3. Use `c(cx, cy, r)` for a circle and `r(x, y, w, h, radius)` for a rounded rectangle.
4. Put a shape that has a fill in the `fill` table.

The Icons page of the guide shows the full set, so a new icon appears there.
