// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// Measures the step response of a spring: when a move from 0 to 1000 first reaches
// its target, and how far it overshoots. Compare with what omega and zeta predict.
//
//   QT_QPA_PLATFORM=offscreen QT_FORCE_STDERR_LOGGING=1 qml6 -I "$PWD/qml" \
//       .claude/skills/dl-verify-render/spring-probe.qml
//
// For zeta below 1 the first crossing is at (pi - acos(zeta)) / (omega * sqrt(1 - zeta^2))
// seconds, and the peak is 1000 * (1 + exp(-zeta * pi / sqrt(1 - zeta^2))).
// Change FlowSpring below to probe another spring.
Item {
    id: probe

    width: 100
    height: 100

    property real x1: 0
    property real peak: 0
    property real peakAt: 0
    property real started: 0
    property real crossedAt: 0

    Behavior on x1 {
        FlowSpring {}
    }
    onX1Changed: {
        const t = Date.now() - started;
        if (crossedAt === 0 && x1 >= 1000)
            crossedAt = t;
        if (x1 > peak) {
            peak = x1;
            peakAt = t;
        }
    }

    Timer {
        interval: 300
        running: true
        onTriggered: {
            probe.started = Date.now();
            probe.x1 = 1000;
        }
    }
    Timer {
        interval: 2300
        running: true
        onTriggered: {
            console.log("omega", Motion.flowOmega, "zeta", Motion.flowZeta, "spring", Motion.flowSpring.toFixed(3), "damping", Motion.flowDamping.toFixed(3));
            console.log("crossed target at ms", probe.crossedAt, "peak", probe.peak.toFixed(1), "at ms", probe.peakAt, "final", probe.x1.toFixed(2));
            Qt.quit();
        }
    }
}
