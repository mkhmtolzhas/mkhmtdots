import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth
import QtQuick
import "../../config"
import "../../services"

Grid {
    id: root

    readonly property bool vertical: Appearance.bar.vertical

    rows: vertical ? -1 : 1
    columns: vertical ? 1 : -1
    rowSpacing: Appearance.spacing.large
    columnSpacing: Appearance.spacing.large
    verticalItemAlignment: Grid.AlignVCenter
    horizontalItemAlignment: Grid.AlignHCenter

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    // ── Brightness ──
    Row {
        id: brightness
        spacing: Appearance.spacing.small

        HoverHandler { id: brHover }
        Tooltip {
            target: brightness
            show: brHover.hovered
            text: I18n.s.brightness + " " + Math.round(Brightness.value * 100) + "%"
        }
        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => Brightness.setValue(Brightness.value + (event.angleDelta.y > 0 ? 0.05 : -0.05))
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: Appearance.icon.size
            verticalAlignment: Text.AlignVCenter
            text: ""
            color: Colours.text
            font.family: Appearance.font.family
            font.pixelSize: Appearance.icon.size
        }
        Text {
            visible: !root.vertical
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(Brightness.value * 100) + "%"
            color: Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.font.size
        }
    }

    // ── Audio ──
    Row {
        id: audio
        spacing: Appearance.spacing.small

        readonly property var sink: Pipewire.defaultAudioSink
        readonly property real vol: sink?.audio?.volume ?? 0
        readonly property bool muted: sink?.audio?.muted ?? false

        HoverHandler { id: volHover }
        Tooltip {
            target: audio
            show: volHover.hovered
            text: audio.muted ? I18n.s.muted : (I18n.s.volume + " " + Math.round(audio.vol * 100) + "%")
        }
        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => {
                const a = Pipewire.defaultAudioSink?.audio;
                if (a) a.volume = Math.max(0, Math.min(1, a.volume + (event.angleDelta.y > 0 ? 0.05 : -0.05)));
            }
        }
        TapHandler {
            onTapped: { const a = Pipewire.defaultAudioSink?.audio; if (a) a.muted = !a.muted; }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: Appearance.icon.size
            verticalAlignment: Text.AlignVCenter
            text: parent.muted ? "" : (parent.vol > 0.5 ? "" : "")
            color: parent.muted ? Colours.subtext : Colours.text
            font.family: Appearance.font.family
            font.pixelSize: Appearance.icon.size
        }
        Text {
            visible: !root.vertical
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(parent.vol * 100) + "%"
            color: Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.font.size
        }
    }

    // ── Network (WiFi) ──
    Row {
        id: network
        spacing: Appearance.spacing.small

        readonly property string statusText:
            !Network.wifiEnabled && !Network.ethernet ? I18n.s.wifiOff
            : Network.connected ? (Network.ssid + " · " + Network.signal + "%")
            : Network.ethernet ? "Ethernet"
            : I18n.s.disconnected

        HoverHandler { id: netHover }
        Tooltip {
            target: network
            show: netHover.hovered
            text: network.statusText
        }
        TapHandler {
            onTapped: Quickshell.execDetached(["kitty", "nmtui"])
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: Appearance.icon.size
            verticalAlignment: Text.AlignVCenter
            text: {
                if (!Network.wifiEnabled && !Network.ethernet) return "󰖪";
                if (Network.ethernet && !Network.connected) return "󰈀";
                if (!Network.connected) return "󰤫";
                return ["󰤟", "󰤟", "󰤢", "󰤥", "󰤨"][Network.bars];
            }
            color: (!Network.wifiEnabled && !Network.ethernet) ? Colours.subtext
                   : (Network.connected || Network.ethernet) ? Colours.text : Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.icon.size
        }
        Text {
            visible: !root.vertical && Network.connected
            anchors.verticalCenter: parent.verticalCenter
            text: Network.signal + "%"
            color: Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.font.size
        }
    }

    // ── Bluetooth ──
    Row {
        id: bluetooth
        spacing: Appearance.spacing.small
        visible: Bluetooth.defaultAdapter !== null

        readonly property bool on: Bluetooth.defaultAdapter?.enabled ?? false
        readonly property int connected: (Bluetooth.devices?.values ?? []).filter(d => d.connected).length

        HoverHandler { id: btHover }
        Tooltip {
            target: bluetooth
            show: btHover.hovered
            text: !bluetooth.on ? I18n.s.btOff
                  : (bluetooth.connected > 0 ? (I18n.s.connected + ": " + bluetooth.connected) : I18n.s.btOn)
        }
        TapHandler {
            onTapped: { if (Bluetooth.defaultAdapter) Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled; }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: Appearance.icon.size
            verticalAlignment: Text.AlignVCenter
            text: ""
            color: parent.on ? Colours.primary : Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.icon.size
        }
        Text {
            visible: !root.vertical && parent.connected > 0
            anchors.verticalCenter: parent.verticalCenter
            text: parent.connected.toString()
            color: Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.font.size
        }
    }

    // ── Battery ──
    Row {
        id: battery
        spacing: Appearance.spacing.small
        visible: UPower.displayDevice?.isLaptopBattery ?? false

        readonly property var bat: UPower.displayDevice
        readonly property real pct: (bat?.percentage ?? 0) * 100
        readonly property bool charging: (bat?.state ?? 0) === 1

        HoverHandler { id: batHover }
        Tooltip {
            target: battery
            show: batHover.hovered
            text: (battery.charging ? I18n.s.charging : I18n.s.battery) + " " + Math.round(battery.pct) + "%"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: Appearance.icon.size
            verticalAlignment: Text.AlignVCenter
            text: parent.charging ? "" :
                  parent.pct > 80 ? "" :
                  parent.pct > 60 ? "" :
                  parent.pct > 40 ? "" :
                  parent.pct > 20 ? "" : ""
            color: parent.pct <= 20 && !parent.charging ? Colours.error : Colours.text
            font.family: Appearance.font.family
            font.pixelSize: Appearance.icon.size
        }
        Text {
            visible: !root.vertical
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(parent.pct) + "%"
            color: Colours.subtext
            font.family: Appearance.font.family
            font.pixelSize: Appearance.font.size
        }
    }
}
