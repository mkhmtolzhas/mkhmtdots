pragma Singleton

import Quickshell
import QtQuick

// Localisation driven by the system locale ($LC_MESSAGES / $LANG).
// Add a new language by adding a dictionary and extending `lang`.
Singleton {
    id: root

    readonly property string lang: {
        const l = (Quickshell.env("LC_MESSAGES") || Quickshell.env("LANG") || "en").toLowerCase();
        return l.startsWith("ru") ? "ru" : "en";
    }

    // Qt locale for date/number formatting (follows the same language).
    readonly property var locale: Qt.locale(lang === "ru" ? "ru_RU" : "en_US")

    readonly property var _en: ({
        "nothingPlaying": "Nothing playing",
        "brightness": "Brightness",
        "volume": "Volume",
        "muted": "Muted",
        "btOff": "Bluetooth off",
        "btOn": "Bluetooth on",
        "connected": "Connected",
        "wifiOff": "WiFi off",
        "disconnected": "Not connected",
        "battery": "Battery",
        "charging": "Charging",
        "posTop": "Top",
        "posBottom": "Bottom",
        "posLeft": "Left",
        "posRight": "Right",
        "wallpapers": "Wallpapers",
        "weekdays": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    })

    readonly property var _ru: ({
        "nothingPlaying": "Ничего не играет",
        "brightness": "Яркость",
        "volume": "Громкость",
        "muted": "Без звука",
        "btOff": "Bluetooth выкл",
        "btOn": "Bluetooth вкл",
        "connected": "Подключено",
        "wifiOff": "WiFi выкл",
        "disconnected": "Нет подключения",
        "battery": "Батарея",
        "charging": "Зарядка",
        "posTop": "Сверху",
        "posBottom": "Снизу",
        "posLeft": "Слева",
        "posRight": "Справа",
        "wallpapers": "Обои",
        "weekdays": ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    })

    readonly property var s: lang === "ru" ? _ru : _en

    // Locale-aware date string, e.g. fmtDate(new Date(), "dddd, d MMMM")
    function fmtDate(date, format) {
        return root.locale.toString(date, format);
    }
}
