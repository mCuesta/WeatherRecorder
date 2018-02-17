#ifndef PLUGINNAME_H
#define PLUGINNAME_H

#include <QObject>

class PluginName: public QObject {
    Q_OBJECT

public:
    PluginName();
    ~PluginName() = default;

    Q_INVOKABLE void speak();
};

#endif
