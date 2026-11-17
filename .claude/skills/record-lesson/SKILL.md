---
name: record-lesson
description: "Record a lesson from work on the Phosphor design language in the place where the next session reads it. Use when: a bug needed more than one attempt, the same error occurred two times, a verification method was successful, the user corrects your method or a design decision."
---

<!--
SPDX-FileCopyrightText: 2026 fuddlesworth
SPDX-License-Identifier: GPL-3.0-or-later
-->

# Record a lesson

The next session does not see a lesson that stays in the chat. Put the lesson where a session reads it.

| Lesson | Location | Form |
| --- | --- | --- |
| The reason for code that looks wrong (a Qt Quick behavior, a Controls limit) | A comment at that code | One or two lines that give the reason |
| A design decision: the meaning of a color, when an item moves, what a string can contain | The guide page for that subject, and "The design language" in CLAUDE.md | The rule, so that a reviewer can check a component against it |
| A bug that a later change can cause again | CLAUDE.md, "Lessons that cost a session" | One bullet: the cause and the rule |
| A step of a procedure that a session did not do | The skill for that procedure (`dl-build`, `dl-add-component`, `dl-verify-render`, `dl-write`) | An instruction with its reason |
| An action that must not occur | `.claude/hooks/guard.py`, with a case in `test_guard.py` | A rule for the plain command that a session types, with the message to show |
| A past bug in one area | "Known past-bug shapes" in the `.claude/agents/review/dl-*-reviewer.md` for that area | One bullet: the defect and the check |
| A script that was successful | The directory of the skill that uses it, with a comment that tells its use | The scratchpad does not stay after the session |
| The method that the user prefers | The session memory | Include the reason that the user gave |

The guard is not a security boundary. Do not add rules for unusual spellings of a command.

Prove the lesson first. For a rule from one occurrence, write what that occurrence needed. Do not write a general
rule. Write the general rule only when a second case confirms it. If a lesson is wrong, correct it. Do not add a
second lesson that contradicts the first.

A design decision of the user is not a lesson to make general. Record the decision and the component that it
applies to.

Write each lesson with the rules in the `dl-write` skill.

Commit a lesson with the work that found it. Alternatively, commit it alone with a subject such as "Note how ...".
