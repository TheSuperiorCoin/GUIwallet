#include <QCoreApplication>
#include <QStandardPaths>
#include <QFileInfo>
#include <QString>
#include <QDir>
#include <QDebug>

#include "Logger.h"
#include "wallet/api/wallet2_api.h"

// default log path by OS (should be writable)
static const QString defaultLogName = "superior-wallet-gui.log";
#if defined(Q_OS_IOS)
    //AppDataLocation = "<APPROOT>/Library/Application Support"
    static const QString osPath = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).at(0);
    static const QString appFolder = "superior-wallet-gui";
#elif defined(Q_OS_WIN)
    //AppDataLocation = "C:/Users/<USER>/AppData/Roaming/<APPNAME>"
    static const QString osPath = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).at(0);
    static const QString appFolder = "superior-wallet-gui";
#elif defined(Q_OS_ANDROID)
    //AppDataLocation = "<USER>/<APPNAME>/files"
    static const QString osPath = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).at(1);
    static const QString appFolder = "";
#elif defined(Q_OS_MAC)
    //HomeLocation = "~"
    static const QString osPath = QStandardPaths::standardLocations(QStandardPaths::HomeLocation).at(0);
    static const QString appFolder = "Library/Logs";
#else // linux + bsd
    //HomeLocation = "~"
    static const QString osPath = QStandardPaths::standardLocations(QStandardPaths::HomeLocation).at(0);
    static const QString appFolder = ".bitsuperior";
#endif


// return the absolute path of the logfile and ensure path folder exists
const QString getLogPath(const QString logPath)
{
    const QFileInfo fi(logPath);

    if(!logPath.isEmpty() && !fi.isDir())
        return fi.absoluteFilePath();
    else {
        QDir appDir(osPath + "/" + appFolder);
        if(!appDir.exists())
            if(!appDir.mkpath("."))
                qWarning() << "Logger: Cannot create log directory " + appDir.path();
        return appDir.path() + "/" + defaultLogName;
    }
}


// custom messageHandler that foward all messages to easylogging
void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &message)
{
    (void) context; // context isn't used in release builds
    const std::string cat = "frontend"; // category displayed in the log
    const std::string msg = message.toStdString();
    switch(type)
    {
        case QtDebugMsg: Superior::Wallet::debug(cat, msg); break;
        case QtInfoMsg: Superior::Wallet::info(cat, msg); break;
        case QtWarningMsg: Superior::Wallet::warning(cat, msg); break;
        case QtCriticalMsg: Superior::Wallet::error(cat, msg); break;
        case QtFatalMsg: Superior::Wallet::error(cat, msg); break;
    }
}

