pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// WiFi / network state polled from NetworkManager (`nmcli`).
// LC_ALL=C is forced so the ACTIVE column stays yes/no regardless of locale.
Singleton {
    id: root

    property bool wifiEnabled: true
    property bool connected: false   // connected to a WiFi network
    property bool ethernet: false    // wired link up
    property string ssid: ""
    property int signal: 0           // 0..100

    // Signal bucket 0..4 for picking the strength glyph.
    readonly property int bars: signal >= 80 ? 4
                              : signal >= 55 ? 3
                              : signal >= 35 ? 2
                              : signal >= 15 ? 1 : 0

    function _parse(text) {
        const p = text.trim().split("\t");
        root.wifiEnabled = (p[0] === "enabled");
        root.ethernet = (p[1] === "1");
        root.ssid = p[2] || "";
        root.signal = parseInt(p[3]) || 0;
        root.connected = root.ssid.length > 0;
    }

    Process {
        id: proc
        command: ["sh", "-c",
            "export LC_ALL=C; " +
            "r=$(nmcli radio wifi); " +
            "eth=$(nmcli -t -f TYPE,STATE dev | awk -F: '$1==\"ethernet\" && $2==\"connected\"{print 1; exit}'); " +
            "line=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | awk -F: '$1==\"yes\"{print; exit}'); " +
            "ssid=$(printf '%s' \"$line\" | cut -d: -f2); " +
            "sig=$(printf '%s' \"$line\" | cut -d: -f3); " +
            "printf '%s\\t%s\\t%s\\t%s\\n' \"$r\" \"${eth:-0}\" \"$ssid\" \"$sig\""]
        stdout: StdioCollector {
            onStreamFinished: root._parse(text)
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: { proc.running = false; proc.running = true; }
    }
}
