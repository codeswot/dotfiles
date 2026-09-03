import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "codeswot.menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "{C}"
    foreground: Color.accent
    horizontalMargin: 7.5
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("omarchy-shell shell toggle codeswot.menu '{\"menu\":\"root\"}'")
      else root.bar.run("xdg-terminal-exec")
    }
  }
}

