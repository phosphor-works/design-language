#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later
"""Cases for guard.py. Run: python3 .claude/hooks/test_guard.py"""

import os
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
# The guard reads the project directory from this variable, and uses the current directory without it. Set it, so
# that the cases give the same result from each directory. CTest runs them from the build directory.
os.environ['CLAUDE_PROJECT_DIR'] = str(REPO)
sys.path.insert(0, str(HERE))
import guard  # noqa: E402


class BashRules(unittest.TestCase):
    def blocked(self, command):
        self.assertIsNotNone(guard.check_bash(command, str(REPO)), f'not blocked: {command!r}')

    def allowed(self, command):
        self.assertIsNone(guard.check_bash(command, str(REPO)), f'blocked: {command!r}')

    def test_privilege(self):
        self.blocked('sudo pacman -S qt6-declarative')
        self.blocked('timeout 5 sudo true')

    def test_install(self):
        self.blocked('cmake --install build')
        self.blocked('cmake --build build --target install')
        self.allowed('cmake --install build --prefix /tmp/stage')
        self.allowed('DESTDIR=/tmp/stage cmake --install build')

    def test_kill_by_name(self):
        self.blocked('pkill phosphor-storybook')
        self.blocked('killall phosphor-storybook')
        self.blocked('kill $(pgrep -f storybook)')
        self.allowed('pgrep -a phosphor-storybook')
        self.allowed('kill 12345')

    def test_git(self):
        self.blocked('git add -A')
        self.blocked('git add .')
        self.blocked('git commit -am "wip"')
        self.blocked('git push --force origin feature')
        self.blocked('git push origin main')
        self.allowed('git add qml/Phosphor/Design/Tile.qml')
        self.allowed('git push -u origin add-tile')

    def test_the_everyday_commands(self):
        self.allowed('cmake --preset dev')
        self.allowed('cmake --build --preset dev --parallel 6')
        self.allowed('QT_QPA_PLATFORM=offscreen build/storybook/phosphor-storybook --story controls-button --shot shots/button.png')

    def test_heredoc_bodies_are_text(self):
        self.allowed("git commit -F - <<'EOF'\nDescribe why sudo is never used\nEOF")


class EditRules(unittest.TestCase):
    def test_build_tree(self):
        self.assertIsNotNone(guard.check_edit(str(REPO / 'build' / 'CMakeCache.txt')))

    def test_other_repositories(self):
        for name in ('PlasmaZones', 'phosphor-libs', 'phosphor-shell-libs'):
            path = str(REPO.parent / name / 'CMakeLists.txt')
            self.assertIsNotNone(guard.check_edit(path), name)
        # A repository with a name that starts with the name of a protected repository is not protected.
        self.assertIsNone(guard.check_edit(str(REPO.parent / 'phosphor-libs-notes' / 'a.txt')))

    def test_sources(self):
        self.assertIsNone(guard.check_edit(str(REPO / 'qml' / 'Phosphor' / 'Design' / 'Tile.qml')))
        self.assertIsNone(guard.check_edit(str(REPO / 'storybook' / 'main.cpp')))


if __name__ == '__main__':
    unittest.main()
