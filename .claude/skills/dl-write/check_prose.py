#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later
"""Find prose that breaks the writing rules of this repository (ASD-STE100 principles).

    python3 .claude/skills/dl-write/check_prose.py            # every document, guide page and comment
    python3 .claude/skills/dl-write/check_prose.py CLAUDE.md  # the files that you name

It reads Markdown, the strings of the guide pages and stories, and the comments of QML, C++ and CMake files.
It reports what a rule can decide: a sentence that is too long, a banned mark, a contraction, a word that is not
permitted. It cannot decide whether a sentence is clear. Read the text after the checker passes.

The exit status is 1 when there is an error. A warning does not change the exit status.
"""

import pathlib
import re
import sys

REPO = pathlib.Path(__file__).resolve().parents[3]
LONGEST = 25  # words in a descriptive sentence
LONGEST_INSTRUCTION = 20  # words in a sentence that starts with a verb

# Words that the rules do not permit, with the reason. Lower case.
BANNED = {
    'should': 'write an instruction, or use "must"',
    'may': 'use "can" for ability and "possibly" for doubt',
    'might': 'use "can" or "possibly"',
    'via': 'use "through" or "with"',
    'utilize': 'use "use"',
    'leverage': 'use "use"',
    'simply': 'remove it',
    'just': 'remove it, or use "only"',
    'basically': 'remove it',
    'very': 'remove it',
    'really': 'remove it',
    'actually': 'remove it',
    'whilst': 'use "while"',
    'etc': 'name the items',
}
CONTRACTION = re.compile(r"\b\w+n't\b|\b(?:it|that|there|here|what|who|let)'s\b|\b\w+'(?:re|ve|ll|d)\b", re.I)
# A form of "be" before a past participle. A warning only: an adjective looks the same ("is installed").
PASSIVE = re.compile(r'\b(?:is|are|was|were|be|been|being)\s+(?:\w+ly\s+)?(\w+(?:ed|en|own|ilt|ade|ept|ung|ut))\b', re.I)
# Verbs that start an instruction. A sentence that starts with one of these has the shorter limit.
IMPERATIVE = set(
    'add apply ask build call change check close commit configure copy create delete do edit find follow give '
    'install keep list look make measure move name open point press put read record remove render replace report '
    'run say send set show start stop tell test turn use write'.split()
)


def sentences(text):
    """The sentences of TEXT. Code in backquotes and quoted examples count as one word each."""
    text = re.sub(r'`[^`]*`', 'CODE', text)
    text = re.sub(r'\([^)]*\)', lambda m: m.group(0).replace('.', ' '), text)
    for part in re.split(r'(?<=[.!?])\s+(?=[A-Z`"(])', text.strip()):
        if part.strip():
            yield part.strip()


def check(text, where, problems):
    for sentence in sentences(text):
        plain = re.sub(r'"[^"]*"', 'QUOTE', sentence)
        words = re.findall(r"[A-Za-z0-9_'.%/-]+", plain)
        first = words[0].lower() if words else ''
        limit = LONGEST_INSTRUCTION if first in IMPERATIVE else LONGEST
        short = sentence if len(sentence) < 110 else sentence[:107] + '...'
        if len(words) > limit:
            problems.append(('error', where, f'{len(words)} words (limit {limit}): {short}'))
        if '—' in plain or '–' in plain:
            problems.append(('error', where, f'a dash joins clauses: {short}'))
        if re.search(r'\w; \w', plain):
            problems.append(('error', where, f'a semicolon joins clauses: {short}'))
        if re.search(r'\w - \w', plain):
            problems.append(('error', where, f'a spaced hyphen stands for a dash: {short}'))
        if match := CONTRACTION.search(plain):
            problems.append(('error', where, f'contraction "{match.group(0)}": {short}'))
        for word in set(w.lower().strip('.') for w in words):
            if word in BANNED:
                problems.append(('error', where, f'"{word}" ({BANNED[word]}): {short}'))
        if match := PASSIVE.search(plain):
            problems.append(('warning', where, f'possibly passive ("{match.group(0)}"): {short}'))


def markdown_text(source):
    """Yield (line number, paragraph) of the prose of a Markdown file. Code, tables and front matter are left out,
    except the description of the front matter."""
    lines = source.splitlines()
    paragraph, start, fenced, front = [], 0, False, False
    for number, line in enumerate(lines, 1):
        if number == 1 and line == '---':
            front = True
            continue
        if front:
            if line == '---':
                front = False
            elif line.startswith('description:'):
                # The list of triggers of a description is a list, not a sentence.
                text = line[len('description:'):].strip().strip('"')
                yield number, ' '.join(s for s in sentences(text) if not s.startswith(('Use when', 'Use for')))
            continue
        if line.strip().startswith('```'):
            fenced = not fenced
            line = ''
        if fenced or line.lstrip().startswith(('|', '<!--', 'SPDX', '-->', '#')):
            line = '' if not line.lstrip().startswith('|') else line
        if line.lstrip().startswith('|'):
            # A table: each cell is its own text.
            if paragraph:
                yield start, ' '.join(paragraph)
                paragraph = []
            if not re.fullmatch(r'[|\s:-]+', line):
                for cell in line.strip().strip('|').split('|'):
                    if cell.strip():
                        yield number, cell.strip()
            continue
        text = re.sub(r'^\s*(?:[-*]|\d+\.)\s+', '', line).strip()
        starts_item = bool(re.match(r'^\s*(?:[-*]|\d+\.)\s+', line))
        if not text or starts_item:
            if paragraph:
                yield start, ' '.join(paragraph)
                paragraph = []
        if text:
            if not paragraph:
                start = number
            paragraph.append(re.sub(r'\*\*([^*]*)\*\*', r'\1', text))
    if paragraph:
        yield start, ' '.join(paragraph)


def comment_text(source, marker):
    """Yield (line number, block) of each run of comment lines that start with MARKER."""
    block, start = [], 0
    for number, line in enumerate(source.splitlines(), 1):
        stripped = line.strip()
        if stripped.startswith(marker) and 'SPDX' not in stripped:
            body = stripped[len(marker):].lstrip('/!').strip()
            # A drawing, a rule of dashes or a line of code is not prose.
            if re.match(r'^[─=\-]{3,}|^──', body) or re.search(r'[{};]$|^\w+ \{|^[A-Z]\w+ \{', body) or '   ' in body:
                body = ''
            if body:
                if not block:
                    start = number
                block.append(re.sub(r'^──\s*|\s*─+$', '', body))
                continue
        if block:
            yield start, ' '.join(block)
            block = []
    if block:
        yield start, ' '.join(block)


def string_text(source):
    """Yield (line number, string) of each string of a QML file that holds prose: four words or more."""
    for number, line in enumerate(source.splitlines(), 1):
        # A `bad:` line of a DoDont holds an example of incorrect text.
        if line.strip().startswith(('//', 'bad:')):
            continue
        for match in re.finditer(r'"((?:[^"\\]|\\.)*)"', line):
            text = match.group(1).replace('\\"', '"')
            if len(text.split()) >= 4 and not text.startswith(('M', '#')) or text.count(' ') >= 6:
                if re.search(r'[a-z]{3,} [a-z]{2,} [a-z]{2,}', text):
                    yield number, text


def texts(path):
    source = path.read_text()
    if path.suffix == '.md':
        yield from markdown_text(source)
    elif path.suffix == '.qml':
        yield from comment_text(source, '//')
        if 'stories' in path.parts or path.parent.name == 'Storybook':
            yield from string_text(source)
    elif path.suffix in ('.cpp', '.h'):
        yield from comment_text(source, '//')
    elif path.suffix in ('.cmake', '.txt', '.py'):
        yield from comment_text(source, '#')


def default_files():
    patterns = ['CLAUDE.md', 'README.md', '.claude/skills/dl-*/SKILL.md', '.claude/skills/record-lesson/SKILL.md',
                '.claude/agents/review/*.md', 'qml/**/*.qml', 'storybook/**/*.qml', 'storybook/*.cpp', 'storybook/*.h',
                'storybook/tests/*.py', 'CMakeLists.txt', 'storybook/CMakeLists.txt', 'cmake/*.cmake',
                '.github/ci/*.txt']
    for pattern in patterns:
        yield from sorted(REPO.glob(pattern))


def main():
    files = [pathlib.Path(a).resolve() for a in sys.argv[1:] if not a.startswith('-')] or list(default_files())
    quiet = '--errors' in sys.argv
    problems = []
    for path in files:
        for number, text in texts(path):
            try:
                where = f'{path.relative_to(REPO)}:{number}'
            except ValueError:
                where = f'{path}:{number}'
            check(text, where, problems)
    errors = [p for p in problems if p[0] == 'error']
    for kind, where, what in problems:
        if kind == 'error' or not quiet:
            print(f'{kind:7} {where}  {what}')
    print(f'{len(errors)} errors, {len(problems) - len(errors)} warnings in {len(files)} files')
    sys.exit(1 if errors else 0)


if __name__ == '__main__':
    main()
