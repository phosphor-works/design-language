// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>

namespace PhosphorStorybook {

/// The data that a reload keeps: the current story and the values of the toolbar. The host discards
/// the QML tree each time a file changes. It does not discard this object.
class Session : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString story READ story WRITE setStory NOTIFY storyChanged)
    Q_PROPERTY(QVariantMap globals READ globals NOTIFY globalsChanged)
    Q_PROPERTY(QVariantList stories READ stories NOTIFY storiesChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(bool capture READ capture CONSTANT)
    Q_PROPERTY(bool blocking READ blocking CONSTANT)

public:
    explicit Session(const QStringList& storyRoots, bool capture, QObject* parent = nullptr);

    QString story() const
    {
        return m_story;
    }
    void setStory(const QString& id);

    QVariantMap globals() const
    {
        return m_globals;
    }
    Q_INVOKABLE void setGlobal(const QString& key, const QVariant& value);

    QVariantList stories() const
    {
        return m_stories;
    }
    Q_INVOKABLE QString storyUrl(const QString& id) const;

    QString error() const
    {
        return m_error;
    }
    void setError(const QString& text);

    /// True for a `--shot` run. A story then does not play its first animation and does not show
    /// content that changes with time.
    bool capture() const
    {
        return m_capture;
    }

    /// True when a story must load before the next line of the host runs. A `--shot` run has a
    /// fixed time before the capture, and a `--tour` run measures the load. In a window for the
    /// user, a story loads in parts between frames, so the window continues to respond. Set it
    /// before the QML loads.
    bool blocking() const
    {
        return m_capture || m_blocking;
    }
    void setBlocking(bool blocking)
    {
        m_blocking = blocking;
    }

    /// Reads the story directories again. A new file becomes a story without a restart.
    void rescan();
    void save() const;

Q_SIGNALS:
    void storyChanged();
    void globalsChanged();
    void storiesChanged();
    void errorChanged();

private:
    QStringList m_roots;
    QString m_story;
    QVariantMap m_globals;
    QVariantList m_stories;
    QString m_error;
    bool m_capture = false;
    bool m_blocking = false;
};

} // namespace PhosphorStorybook
