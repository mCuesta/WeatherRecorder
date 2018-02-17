#ifndef PLUGINNAMEPLUGIN_H
#define PLUGINNAMEPLUGIN_H

#include <QQmlExtensionPlugin>

class PluginNamePlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif
