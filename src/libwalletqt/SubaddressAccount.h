#ifndef SUBADDRESSACCOUNT_H
#define SUBADDRESSACCOUNT_H

#include <wallet/api/wallet2_api.h>
#include <QObject>
#include <QList>
#include <QDateTime>

class SubaddressAccount : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QList<Superior::SubaddressAccountRow*> getAll(bool update = false) const;
    Q_INVOKABLE Superior::SubaddressAccountRow * getRow(int index) const;
    Q_INVOKABLE void addRow(const QString &label) const;
    Q_INVOKABLE void setLabel(quint32 accountIndex, const QString &label) const;
    Q_INVOKABLE void refresh() const;
    quint64 count() const;

signals:
    void refreshStarted() const;
    void refreshFinished() const;

public slots:

private:
    explicit SubaddressAccount(Superior::SubaddressAccount * subaddressAccountImpl, QObject *parent);
    friend class Wallet;
    Superior::SubaddressAccount * m_subaddressAccountImpl;
    mutable QList<Superior::SubaddressAccountRow*> m_rows;
};

#endif // SUBADDRESSACCOUNT_H
