#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later
"""Render each story without a display. Fail when a story does not load or prints a warning.

    python3 storybook/tests/render_stories.py build-standalone/storybook/phosphor-storybook
    python3 storybook/tests/render_stories.py BINARY --set scheme=light --out shots

The build compiles no QML, so this script is the test of the QML. It gets the story ids from `--list` and renders
each story with `--shot`. A story passes when the exit status is 0, the output is empty and the frame exists.
The script turns off the debug and info messages of Qt, so the output contains only warnings and errors.

A render is one frame. This script cannot find a defect in motion, hover, press or keyboard focus.

The exit status is 1 when a story fails, and when the storybook lists no stories.
"""

import argparse
import os
import pathlib
import subprocess
import sys
import tempfile

SECONDS_FOR_ONE_STORY = 120


def run(command, env):
    """The exit status and the full output of one run of the storybook."""
    try:
        done = subprocess.run(command, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                              timeout=SECONDS_FOR_ONE_STORY)
    except subprocess.TimeoutExpired:
        return 1, f'no result after {SECONDS_FOR_ONE_STORY} seconds'
    return done.returncode, done.stdout.strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n', 1)[0])
    parser.add_argument('binary', type=pathlib.Path, help='the phosphor-storybook program')
    parser.add_argument('--set', action='append', default=[], metavar='KEY=VALUE', dest='values',
                        help='a toolbar value for each render, for example scheme=light')
    parser.add_argument('--out', type=pathlib.Path, help='a directory that keeps the frames')
    arguments = parser.parse_args()

    # The storybook selects the offscreen platform only when the variable is not set. Set it here, so that no
    # environment makes a render open a window.
    env = dict(os.environ, QT_QPA_PLATFORM='offscreen', QT_FORCE_STDERR_LOGGING='1')
    # A debug or info message is not a defect. For example, Phosphor.Theme prints the fonts that it found. A later
    # rule has priority, so these two go last.
    rules = [os.environ.get('QT_LOGGING_RULES', ''), '*.debug=false', '*.info=false']
    env['QT_LOGGING_RULES'] = ';'.join(rule for rule in rules if rule)
    binary = str(arguments.binary)

    status, listing = run([binary, '--list'], env)
    stories = listing.split()
    if status != 0 or not stories:
        print(f'{binary} --list gave no stories (exit status {status})\n{listing}', file=sys.stderr)
        return 1

    values = [word for value in arguments.values for word in ('--set', value)]
    failed = []
    with tempfile.TemporaryDirectory() as temporary:
        out = arguments.out or pathlib.Path(temporary)
        out.mkdir(parents=True, exist_ok=True)
        for story in stories:
            frame = out / f'{story}.png'
            frame.unlink(missing_ok=True)
            status, output = run([binary, '--story', story, '--shot', str(frame), *values], env)
            reason = None
            if status != 0:
                reason = f'exit status {status}'
            elif output:
                reason = 'printed a warning'
            elif not frame.is_file() or frame.stat().st_size == 0:
                reason = 'wrote no frame'
            if reason:
                failed.append(story)
                print(f'FAILED {story}: {reason}\n{output}', file=sys.stderr)

    print(f'{len(stories) - len(failed)} of {len(stories)} stories rendered {" ".join(arguments.values)}'.rstrip())
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
