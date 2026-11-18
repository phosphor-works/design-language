// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

#include "session.h"

#include <QByteArrayView>
#include <QCommandLineParser>
#include <QDir>
#include <QDirIterator>
#include <QElapsedTimer>
#include <QFileSystemWatcher>
#include <QGuiApplication>
#include <QImage>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlError>
#include <QQuickStyle>
#include <QQuickView>
#include <QTextStream>
#include <QTimer>

using PhosphorStorybook::Session;

namespace {

/// Each directory and file below the roots. A directory watch finds a new file. A file watch finds
/// an editor that writes in the same file.
QStringList watchPaths(const QStringList& roots)
{
    QStringList paths;
    for (const QString& root : roots) {
        paths.append(root);
        QDirIterator it(root, QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            paths.append(it.next());
        }
    }
    return paths;
}

QString describe(const QList<QQmlError>& errors)
{
    QStringList lines;
    for (const QQmlError& error : errors) {
        lines.append(error.toString());
    }
    return lines.join(QLatin1Char('\n'));
}

} // namespace

int main(int argc, char* argv[])
{
    // Qt sends messages to the journal when stderr is not a terminal. That applies to each run from
    // a script or an agent. A QML warning must go to the program that started the storybook. If
    // not, a defective story looks correct.
    qputenv("QT_FORCE_STDERR_LOGGING", "1");

    // A capture or a list needs no display, and must not open a window on the desktop of the user.
    // The decision is necessary before the application object exists, so this code reads the
    // arguments.
    for (int i = 1; i < argc; ++i) {
        const QByteArrayView argument(argv[i]);
        if (argument == "--list" || argument == "--shot" || argument.startsWith("--shot=") || argument == "--tour"
            || argument.startsWith("--tour=")) {
            if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")) {
                qputenv("QT_QPA_PLATFORM", "offscreen");
            }
            break;
        }
    }

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("phosphor-works"));
    QCoreApplication::setApplicationName(QStringLiteral("phosphor-storybook"));

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Shows every Phosphor component in each of its states"));
    parser.addHelpOption();
    const QCommandLineOption shotOption(QStringLiteral("shot"), QStringLiteral("Render one frame to <file> and exit."),
                                        QStringLiteral("file"));
    const QCommandLineOption storyOption(QStringLiteral("story"), QStringLiteral("Open the story with this id."),
                                         QStringLiteral("id"));
    const QCommandLineOption sizeOption(QStringLiteral("size"), QStringLiteral("Window size, as <width>x<height>."),
                                        QStringLiteral("size"), QStringLiteral("1360x860"));
    const QCommandLineOption waitOption(QStringLiteral("wait"),
                                        QStringLiteral("Milliseconds to let a story settle before --shot."),
                                        QStringLiteral("ms"), QStringLiteral("900"));
    const QCommandLineOption setOption(QStringLiteral("set"),
                                       QStringLiteral("Set a toolbar value, as <key>=<value>. May repeat."),
                                       QStringLiteral("key=value"));
    const QCommandLineOption listOption(QStringLiteral("list"), QStringLiteral("Print the story ids and exit."));
    const QCommandLineOption tourOption(
        QStringLiteral("tour"),
        QStringLiteral("Open each story for <ms> in one window, print how long each took to load, and exit."),
        QStringLiteral("ms"));
    parser.addOptions({shotOption, storyOption, sizeOption, waitOption, setOption, listOption, tourOption});
    parser.process(app);

    const QDir source(QStringLiteral(STORYBOOK_SOURCE_DIR));
    QStringList storyRoots{source.filePath(QStringLiteral("storybook/stories"))};
#ifdef STORYBOOK_HAVE_PHOSPHOR
    storyRoots.append(source.filePath(QStringLiteral("storybook/stories-phosphor")));
#endif
    const bool capture = parser.isSet(shotOption);
    Session session(storyRoots, capture);

    QTextStream out(stdout);
    QTextStream err(stderr);
    if (parser.isSet(listOption)) {
        const QVariantList stories = session.stories();
        for (const QVariant& story : stories) {
            out << story.toMap().value(QStringLiteral("id")).toString() << '\n';
        }
        return 0;
    }
    if (parser.isSet(storyOption)) {
        const QString id = parser.value(storyOption);
        if (session.storyUrl(id).isEmpty()) {
            err << "No story has the id " << id << ". Run with --list.\n";
            return 2;
        }
        session.setStory(id);
    }
    const QStringList assignments = parser.values(setOption);
    for (const QString& assignment : assignments) {
        const qsizetype equals = assignment.indexOf(QLatin1Char('='));
        const QString key = assignment.left(equals);
        const QString text = assignment.mid(equals + 1);
        if (equals < 1 || !session.globals().contains(key)) {
            err << "--set takes one of: " << session.globals().keys().join(QStringLiteral(", ")) << '\n';
            return 2;
        }
        // Keep the type that the toolbar writes, so that QML compares values of the same type.
        QVariant value(text);
        const QVariant current = session.globals().value(key);
        if (current.typeId() == QMetaType::Bool) {
            value = text == QLatin1String("true") || text == QLatin1String("1");
        } else if (current.typeId() != QMetaType::QString) {
            value = text.toDouble();
        }
        session.setGlobal(key, value);
    }

    // The style is a module of this repository. The import path below finds it.
    QQuickStyle::setStyle(QStringLiteral("Phosphor.Style"));

    QQuickView view;
    view.setTitle(QStringLiteral("Phosphor Storybook"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.engine()->addImportPath(source.filePath(QStringLiteral("qml")));
    view.engine()->addImportPath(source.filePath(QStringLiteral("storybook/qml")));
#ifdef STORYBOOK_HAVE_PHOSPHOR
    // The phosphor modules are static plugins, and their QML is in resources.
    view.engine()->addImportPath(QStringLiteral("qrc:/qt/qml"));
    view.engine()->addImportPath(QStringLiteral("qrc:/"));
#endif
    view.rootContext()->setContextProperty(QStringLiteral("Session"), &session);

    const QStringList size = parser.value(sizeOption).split(QLatin1Char('x'));
    view.resize(size.value(0).toInt(), size.value(1).toInt());

    const QUrl mainUrl = QUrl::fromLocalFile(source.filePath(QStringLiteral("storybook/qml/Main.qml")));
    const QUrl errorUrl = QUrl::fromLocalFile(source.filePath(QStringLiteral("storybook/qml/LoadError.qml")));

    const auto load = [&]() {
        view.setSource(QUrl());
        view.engine()->clearSingletons();
        view.engine()->clearComponentCache();
        session.rescan();
        session.setError(QString());
        view.setSource(mainUrl);
        if (view.status() == QQuickView::Error) {
            const QString text = describe(view.errors());
            err << text << '\n';
            err.flush();
            // Show the error in the window. An empty window does not tell the user what failed.
            view.setSource(QUrl());
            view.engine()->clearComponentCache();
            session.setError(text);
            view.setSource(errorUrl);
            return false;
        }
        return true;
    };

    const QStringList watched{source.filePath(QStringLiteral("qml")), source.filePath(QStringLiteral("storybook/qml")),
                              source.filePath(QStringLiteral("storybook/stories")),
                              source.filePath(QStringLiteral("storybook/stories-phosphor"))};
    QFileSystemWatcher watcher;
    QTimer settle;
    settle.setSingleShot(true);
    settle.setInterval(120);
    const auto rewatch = [&]() {
        if (!watcher.files().isEmpty()) {
            watcher.removePaths(watcher.files());
        }
        if (!watcher.directories().isEmpty()) {
            watcher.removePaths(watcher.directories());
        }
        watcher.addPaths(watchPaths(watched));
    };
    QObject::connect(&watcher, &QFileSystemWatcher::fileChanged, &settle, qOverload<>(&QTimer::start));
    QObject::connect(&watcher, &QFileSystemWatcher::directoryChanged, &settle, qOverload<>(&QTimer::start));
    QObject::connect(&settle, &QTimer::timeout, &app, [&]() {
        // Print the result in the terminal. The window does not show the difference between a
        // reload and a file that changed nothing.
        err << (load() ? "Reloaded\n" : "Reload failed\n");
        err.flush();
        // An editor that replaces a file removes its watch, so set all watches again.
        rewatch();
    });
    // A tour selects each story. It must not change the story that the user sees at the next start.
    const bool tour = parser.isSet(tourOption);
    session.setBlocking(tour);
    if (!tour) {
        QObject::connect(&session, &Session::storyChanged, &session, &Session::save);
        QObject::connect(&session, &Session::globalsChanged, &session, &Session::save);
    }

    const bool loaded = load();
    view.show();

    if (capture) {
        const QString file = parser.value(shotOption);
        QTimer::singleShot(parser.value(waitOption).toInt(), &app, [&, file, loaded]() {
            const QImage frame = view.grabWindow();
            const bool saved = !frame.isNull() && frame.save(file);
            if (!saved) {
                err << "Could not write " << file << '\n';
            }
            // The host writes a capture of the error page, but the run is a failure.
            QCoreApplication::exit(saved && loaded ? 0 : 1);
        });
    } else if (tour) {
        // A render starts a new process for each story. Thus it cannot find a story that is slow to
        // open in a window that already shows a different story. The tour opens each story in one
        // window and measures three times for it.
        // "Load" is the time until the story exists. "Frame" is the time until the window shows
        // the first frame of the story. "Stall" is the longest time that the window did not
        // respond while the story was open.
        struct Tour
        {
            QStringList ids;
            qsizetype next = 0;
            QString current;
            QElapsedTimer sinceSwitch;
            QElapsedTimer sinceTick;
            qint64 load = 0;
            qint64 frame = -1;
            qint64 stall = 0;
        };
        auto* state = new Tour;
        const QVariantList stories = session.stories();
        for (const QVariant& story : stories) {
            state->ids.append(story.toMap().value(QStringLiteral("id")).toString());
        }
        auto* tick = new QTimer(&app);
        tick->setInterval(5);
        QObject::connect(tick, &QTimer::timeout, &app, [state]() {
            state->stall = qMax(state->stall, state->sinceTick.restart());
        });
        QObject::connect(&view, &QQuickWindow::frameSwapped, &app, [state]() {
            if (state->frame < 0) {
                state->frame = state->sinceSwitch.elapsed();
            }
        });
        auto* step = new QTimer(&app);
        step->setInterval(qMax(50, parser.value(tourOption).toInt()));
        const auto report = [state, &out]() {
            if (!state->current.isEmpty()) {
                out << qSetFieldWidth(6) << state->load << state->frame << state->stall << qSetFieldWidth(0) << "  "
                    << state->current << '\n';
                out.flush();
            }
        };
        QObject::connect(step, &QTimer::timeout, &app, [state, tick, report, &session, loaded]() {
            report();
            if (state->next >= state->ids.size()) {
                QCoreApplication::exit(loaded ? 0 : 1);
                return;
            }
            state->current = state->ids.at(state->next++);
            state->frame = -1;
            state->stall = 0;
            state->sinceSwitch.start();
            session.setStory(state->current);
            state->load = state->sinceSwitch.elapsed();
            // The time of the load is not a stall of the open story.
            state->sinceTick.start();
            tick->start();
        });
        out << "  load frame stall  story (milliseconds)\n";
        step->start();
    } else {
        rewatch();
    }

    return app.exec();
}
