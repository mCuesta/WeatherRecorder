#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "pluginname.h"

void PluginNamePlugin::registerTypes(const char *uri) {
    //@uri PluginName
    qmlRegisterSingletonType<PluginName>(uri, 1, 0, "PluginName", [](QQmlEngine*, QJSEngine*) -> QObject* { return new PluginName; });
}
