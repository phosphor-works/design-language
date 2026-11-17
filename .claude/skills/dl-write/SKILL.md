---
name: dl-write
description: "Write and check text for the Phosphor design language with ASD-STE100 principles. Applies to documents, guide pages, skills, agent definitions and code comments. Contains the rules, the terms of the repository and a checker. Use when: write documentation, write a guide page, write a comment, edit CLAUDE.md, check the text, STE, controlled English, simplified technical English."
---

<!--
SPDX-FileCopyrightText: 2026 fuddlesworth
SPDX-License-Identifier: GPL-3.0-or-later
-->

# Write text for this repository

All text in this repository uses the principles of ASD-STE100 (Simplified Technical English), Issue 9. These rules
do not certify full compliance with the dictionary of the standard.

The rules apply to these texts:

- `CLAUDE.md`, the skills and the agent definitions.
- The guide pages and the stories in `storybook/stories/`.
- The comments in QML, C++, CMake and Python files.

The text of an interface (the label of a button, the name of a setting) follows the Writing page of the guide. That
page is stricter: a label is not a sentence.

## Rules

| Rule | Example |
| --- | --- |
| Use active voice | Write "The host reloads the QML." Do not write "The QML is reloaded." |
| Use the simple present tense | Write "A panel opens from its control." |
| Write an instruction as a command | Write "Render the story." Do not write "You should render the story." |
| Keep an instruction to 20 words or fewer | |
| Keep a description to 25 words or fewer | |
| Give one instruction in each sentence | |
| Put the condition before the instruction | Write "If a token is missing, add the token." |
| Keep an action apart from its result | Write "Press Tab. The focus ring appears." |
| Give each term one meaning, and use the same term for the same item | See the terms below |
| Use an article before a noun | Write "the edge of a surface" |
| Do not use a contraction | Write "do not", "it is" |
| Do not join clauses with an em dash or a semicolon. Do not use a spaced hyphen as a dash | Write two sentences |
| Do not use a figure of speech | Write "The color fades slowly." Do not write "The light dies away." |
| Use American spelling | "color", "center" |
| Use a table for fields, choices, limits and comparisons | |
| Give a limit with its unit, and tell what occurs at the limit | "The maximum width is 640 px. A wider window keeps that width." |
| Keep code, commands, paths and identifiers exactly as they are | |

Do not use these words:

| Word | Use |
| --- | --- |
| `should` | An instruction, or "must" |
| `may`, `might` | "can" for ability, "possibly" for doubt |
| `via` | "through" or "with" |
| `utilize`, `leverage` | "use" |
| `simply`, `just`, `basically`, `very`, `really`, `actually` | Remove the word |
| `etc` | Name the items |

## Terms

Use each term with this meaning only.

| Term | Meaning |
| --- | --- |
| accent | The brand color that the user selects. `Theme.accent` |
| accent fill | A fill that has the accent color. Do not write "lit" |
| brand color | One of blue, cyan, purple and rose. Do not write "stop" |
| chosen | The option that applies, in a list of options. It has a check |
| current | The position of the user in a list. It has a tint |
| drawer | The part of the shell body that opens below the bar |
| ground | A background color. There are six grounds |
| guide | The Foundations stories |
| ink | The color of text and icons on an accent fill |
| logo | A brand drawing: Phosphor, Facet, Afterglow. Do not write "mark" |
| on | A setting that is active |
| panel | A surface of the shell that opens from the bar |
| shell body | The bar and its drawer as one shape. `ShellBody` |
| spectrum | The gradient of the four brand colors |
| story | One file in `storybook/stories/` that shows one component |
| surface | An area that contains content: a panel, a popup, a window |
| token | A value in `Theme`, `Metrics` or `Motion` |
| variant | One state of a component in a story |

A technical name stays as it is when a simple word is less accurate. Examples are QML, qmldir, singleton,
binding, delegate, spring, omega, zeta, overshoot, fillet, tooltip and chevron. Explain a new technical name at
its first use.

## Check the text

```sh
python3 .claude/skills/dl-write/check_prose.py              # all text
python3 .claude/skills/dl-write/check_prose.py --errors     # errors only
python3 .claude/skills/dl-write/check_prose.py CLAUDE.md    # the files that you name
```

The checker reads Markdown, the strings of the stories, and comments. It reports these problems:

| Problem | Kind |
| --- | --- |
| A sentence that is longer than its limit | Error |
| An em dash, a semicolon between clauses, a spaced hyphen | Error |
| A contraction | Error |
| A word from the table above | Error |
| A form of "be" before a past participle | Warning |

A warning is not always passive voice. "The font is installed" describes a state and is correct. Read each warning
and change the sentence if an agent does the action.

The checker cannot find a figure of speech, a term with two meanings, or a sentence that is not clear. Read the
text after the checker passes.

In a story, a line that starts with `bad:` contains an example of incorrect text. The checker ignores it.

In the description of a skill or an agent, the sentence that starts with "Use when" or "Use for" is a list of
triggers. The checker ignores it.
