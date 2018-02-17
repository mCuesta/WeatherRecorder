#include <QDebug>

#include "pluginname.h"

PluginName::PluginName() {

}

void PluginName::speak() {
    qDebug() << "hello world!";
}
