// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

#include "session.h"

#include <QDir>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSettings>
#include <QUrl>

#include <utility>

namespace PhosphorStorybook {

namespace {

/// "02-Controls" becomes "Controls", and "QuickSettings" becomes "Quick settings".
QString displayName(const QString& fileName)
{
    static const QRegularExpression order(QStringLiteral("^\\d+-"));
    static const QRegularExpression hump(QStringLiteral("(?<=[a-z0-9])(?=[A-Z])"));
    QString name = fileName;
    name.remove(order);
    QStringList words = name.split(hump);
    for (int i = 1; i < words.size(); ++i) {
        // An acronym keeps its capital letters: "QML", "OSD".
        if (words.at(i).size() > 1 && words.at(i).at(1).isLower()) {
            words[i] = words.at(i).toLower();
        }
    }
    return words.join(QLatin1Char(' '));
}

QString slug(const QString& text)
{
    static const QRegularExpression junk(QStringLiteral("[^a-z0-9]+"));
    QString out = text.toLower();
    out.replace(junk, QStringLiteral("-"));
    return out;
}

QVariantMap defaultGlobals()
{
    return {
        {QStringLiteral("scheme"), QStringLiteral("dark")},
        {QStringLiteral("accent"), QStringLiteral("blue")},
        {QStringLiteral("corners"), 16},
        {QStringLiteral("density"), QStringLiteral("comfortable")},
        {QStringLiteral("motion"), QStringLiteral("fluid")},
        {QStringLiteral("slow"), 1},
        {QStringLiteral("glow"), true},
        {QStringLiteral("material"), QStringLiteral("glass")},
    };
}

} // namespace

Session::Session(const QStringList& storyRoots, bool capture, QObject* parent)
    : QObject(parent)
    , m_roots(storyRoots)
    , m_globals(defaultGlobals())
    , m_capture(capture)
{
    // A capture gives the same result each time. It starts from the defaults and not from the last
    // session.
    if (!m_capture) {
        const QSettings settings;
        m_story = settings.value(QStringLiteral("story")).toString();
        const QVariantMap stored = settings.value(QStringLiteral("globals")).toMap();
        for (auto it = stored.constBegin(); it != stored.constEnd(); ++it) {
            if (m_globals.contains(it.key())) {
                m_globals.insert(it.key(), it.value());
            }
        }
    }
    rescan();
}

void Session::setStory(const QString& id)
{
    if (m_story == id) {
        return;
    }
    m_story = id;
    Q_EMIT storyChanged();
}

void Session::setGlobal(const QString& key, const QVariant& value)
{
    if (m_globals.value(key) == value) {
        return;
    }
    m_globals.insert(key, value);
    Q_EMIT globalsChanged();
}

QString Session::storyUrl(const QString& id) const
{
    for (const QVariant& entry : m_stories) {
        const QVariantMap story = entry.toMap();
        if (story.value(QStringLiteral("id")).toString() == id) {
            return story.value(QStringLiteral("url")).toString();
        }
    }
    return {};
}

void Session::setError(const QString& text)
{
    if (m_error == text) {
        return;
    }
    m_error = text;
    Q_EMIT errorChanged();
}

void Session::rescan()
{
    QVariantList found;
    for (const QString& root : std::as_const(m_roots)) {
        const QDir rootDir(root);
        const QStringList groups = rootDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
        for (const QString& group : groups) {
            const QDir groupDir(rootDir.filePath(group));
            const QStringList files = groupDir.entryList({QStringLiteral("*.qml")}, QDir::Files, QDir::Name);
            for (const QString& file : files) {
                const QString base = QFileInfo(file).completeBaseName();
                const QString groupName = displayName(group);
                const QString name = displayName(base);
                found.append(QVariantMap{
                    {QStringLiteral("id"), slug(groupName + QLatin1Char('-') + name)},
                    {QStringLiteral("group"), groupName},
                    {QStringLiteral("name"), name},
                    {QStringLiteral("url"), QUrl::fromLocalFile(groupDir.filePath(file)).toString()},
                });
            }
        }
    }
    if (found != m_stories) {
        m_stories = found;
        Q_EMIT storiesChanged();
    }
    if (storyUrl(m_story).isEmpty() && !m_stories.isEmpty()) {
        setStory(m_stories.constFirst().toMap().value(QStringLiteral("id")).toString());
    }
}

void Session::save() const
{
    if (m_capture) {
        return;
    }
    QSettings settings;
    settings.setValue(QStringLiteral("story"), m_story);
    settings.setValue(QStringLiteral("globals"), m_globals);
}

} // namespace PhosphorStorybook
