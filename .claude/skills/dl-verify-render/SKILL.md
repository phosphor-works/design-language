---
name: dl-verify-render
description: "Check a change to a Phosphor component or story with a render that needs no display. Contains the --shot option, the --set values and the variations to render. Also tells how to read load errors, how to measure a spring, and what a render cannot prove. Use when: does this look right, verify the component, render the story, check the two schemes, before you tell the user that a visual change is correct."
---

<!--
SPDX-FileCopyrightText: 2026 fuddlesworth
SPDX-License-Identifier: GPL-3.0-or-later
-->

# Verify a change with a render

The build compiles no QML. Thus the build cannot tell you that a component is correct. A render of its story can.

## Render one story

```sh
build-standalone/storybook/phosphor-storybook --story controls-tile --shot shots/controls-tile.png
```

1. Run the command.
2. Check the exit status. The status is 0 only when the host wrote the frame and `Main.qml` loaded.
3. Read stderr. No output on stderr is a condition for a pass.
4. Open the PNG and examine it. A frame that exists is not always a frame that is correct.

| Fact | Detail |
| --- | --- |
| Story ids | `--list` prints them. An id is the group and the file name in lower case: `02-Controls/ListRow.qml` is `controls-list-row` |
| Display | `--shot` and `--list` need no display. The host selects the offscreen platform when `QT_QPA_PLATFORM` is not set |
| A window | A run without `--shot` and without `--list` opens a window on the desktop of the user |
| A story that does not load | The host prints the QML error to stderr, and the canvas shows a short red message |
| A binding with an error | The host prints a warning. The frame renders, but that value is missing |
| Log output | The host makes Qt write to stderr. A different Qt program (`qml6`, a test) needs `QT_FORCE_STDERR_LOGGING=1` in its command. Without it, Qt writes to the journal and a defective story looks correct |
| Output directory | Git ignores `shots/`. Put renders there |

## Set the toolbar values

`--set key=value` sets a toolbar value. You can use the option more than one time. A capture starts from the
defaults, so two captures with the same arguments give the same picture.

| Key | Values | Default |
| --- | --- | --- |
| `scheme` | `dark`, `light` | `dark` |
| `accent` | `blue`, `cyan`, `purple`, `rose` | `blue` |
| `corners` | 0 to 24 | 16 |
| `density` | `comfortable`, `compact` | `comfortable` |
| `motion` | `calm`, `fluid`, `lively` | `fluid` |
| `slow` | 1, 4 | 1 |
| `glow` | `true`, `false` | `true` |

`--size 1360x860` sets the size of the window. `--wait 900` sets the time before the capture, in milliseconds. Use
a larger height for a long guide page, for example `--size 1360x1700`.

## What to render for a change

| The change | Render |
| --- | --- |
| A component | Its story with `scheme=dark` and with `scheme=light`. A color that is not a token shows when the scheme changes |
| An item with a radius | `corners=0` and `corners=24`. An inner radius that does not use `Metrics` shows at the limits |
| An item with a height or a padding | `density=compact` |
| A token | Each story that reads the token. Use the script below |

```sh
python3 storybook/tests/render_stories.py build-standalone/storybook/phosphor-storybook --out shots
python3 storybook/tests/render_stories.py build-standalone/storybook/phosphor-storybook --set scheme=light
ctest --preset standalone
```

The script renders each story and fails when a story does not load or prints a warning. `--out` keeps the frames.
`--set` has the same values as the storybook. CTest runs the script for the two schemes.

The script proves that each story loads. It does not prove that a frame is correct. Open the frames of the stories
that your change affects.

## What a render cannot show

| Item | Reason |
| --- | --- |
| Motion | A render is one frame after the story stops. It cannot show a spring, an overshoot, a stretch or a fade |
| Hover, press and keyboard focus | No program moves the pointer or presses a key |
| Blur and round pictures | The offscreen platform renders without a GPU. The glow of `ShellBody` is a `MultiEffect` and is absent. `Artwork` then shows its picture with square corners. Render with the GPU to see them (see below) |
| An icon behind a clip | The software renderer draws an icon that a clip hides. The scrolling strip of the Stage story shows such icons at its sides. A render with the GPU does not |
| The correct fonts | `Metrics` uses a different font when Manrope and JetBrains Mono are not installed. The Typography page shows the fonts that it found |

`Session.capture` is true during a capture. A story uses it to start in the state that the capture must show. For
example, the Desktop story opens its drawer. That shows the end of a move, not the move.

When a change affects motion or interaction, tell the user that the render does not show it. Then ask the user to
examine it in the storybook at the quarter speed. Do not report motion as verified from one frame.

## Measure a spring

A spring can render correctly and be wrong. The first conversion from omega and zeta was 46% too slow, and no
frame showed it. `spring-probe.qml`, in the directory of this skill, moves a value from 0 to 1000 on a spring. It
prints the time when the value first gets to the target, and the peak value.

```sh
QT_QPA_PLATFORM=offscreen QT_FORCE_STDERR_LOGGING=1 qml6 -I "$PWD/qml" \
    .claude/skills/dl-verify-render/spring-probe.qml
```

For `flow` (omega 18, zeta 0.8), the correct values are approximately 231 ms and a peak of 1015. The comment at the
top of the probe gives the formulas. Run the probe after each change to `Motion.qml` or to a spring wrapper.

## Measure how long a story takes to open

A render starts a new process for each story. Thus it cannot show that a story is slow to open in a window that
already shows a different story. The tour opens each story in one window and prints three times for it.

```sh
build-standalone/storybook/phosphor-storybook --tour 700
```

| Column | Meaning |
| --- | --- |
| `load` | The time until the story exists. The window of the user loads a story in parts, so this is work and not a stop |
| `frame` | The time until the window shows the first frame of the story |
| `stall` | The longest time that the window did not respond while the story was open |

The tour needs no display. Without a display, Qt Quick uses the software renderer, which has no effects and no
GPU. To measure with the GPU, and to render a `MultiEffect`, run the storybook in a compositor that has no screen:

```sh
env -u WAYLAND_DISPLAY -u DISPLAY WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 cage -- \
    env -u QT_WAYLAND_SHELL_INTEGRATION QT_QPA_PLATFORM=wayland \
    build-standalone/storybook/phosphor-storybook --tour 700
```

The same command with `--story ID --shot "$PWD/shots/ID.png"` renders one story with the GPU. Use an absolute path
for the file.

Before you compare times, read the load of the computer with `uptime`. A different build on the same computer
makes each time longer. On a computer with eight processors and a load of 50, a story that opens in 0.3 seconds
stopped the window for seconds.

## A reload is not a restart

The storybook reloads QML when a file changes. It does not reload `storybook/*.cpp`. After a change to the host,
build it and start it again.
