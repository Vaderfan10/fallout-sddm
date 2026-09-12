import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.VirtualKeyboard 2.3
import QtMultimedia

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#000000"

    property color phosphor: "#44ff44"
    property var lines: [
        "ROBCO INDUSTRIES (TM)",
        "",
        "CHECKING MEMORY........OK",
        "LOADING OPERATING SYSTEM........OK",
        "INITIALIZING SECURITY SUBSYSTEM........OK",
        "AUTHORIZATION SYSTEM ONLINE",
        "",
        "USER LOGIN REQUIRED",
        ""
    ]
    property string visibleText: ""
    property int currentLine: 0
    property int currentChar: 0
    property bool bootComplete: false
    property bool usernameDone: false
    property bool passwordDone: false
    property bool authenticating: false
    property bool keyboardVisible: false
    property real keyVolume: 0.5
    property real systemVolume: 1.00

    SoundEffect {
        id: powerOnSound
        source: "Sounds/poweron.wav"
        volume: root.systemVolume
        }

    SoundEffect {
        id: powerOffSound
        source: "Sounds/poweroff.wav"
        volume: root.systemVolume
    }

    SoundEffect {
        id: keySound
        volume: root.keyVolume
    }

    Component.onCompleted: {
        powerOnSound.play()
        startupTimer.start()
    }

    function playKeySound() {
        var sounds = [
            "Sounds/ui_hacking_charsingle_01.wav",
            "Sounds/ui_hacking_charsingle_02.wav",
            "Sounds/ui_hacking_charsingle_03.wav",
            "Sounds/ui_hacking_charsingle_04.wav",
            "Sounds/ui_hacking_charsingle_05.wav",
            "Sounds/ui_hacking_charsingle_06.wav",
            "Sounds/ui_hacking_charenter_01.wav",
            "Sounds/ui_hacking_charenter_02.wav",
            "Sounds/ui_hacking_charenter_03.wav"
        ]

        keySound.source = sounds[Math.floor(Math.random() * sounds.length)]
        keySound.play()
    }

    Rectangle {
        anchors.fill: parent
        color: "#002200"
        opacity: 0.15
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.6

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#000000" }
            GradientStop { position: 0.15; color: "#00000000" }
            GradientStop { position: 0.85; color: "#00000000" }
            GradientStop { position: 1.0; color: "#000000" }
        }
    }

    Item {
        anchors.fill: parent

        Repeater {
            model: Math.ceil(root.height / 4)

            Rectangle {
                width: root.width
                height: 1
                y: index * 4
                color: "#00ff00"
                opacity: 0.08
            }
        }
    }

    Rectangle {
        id: scanBeam
        z: 2
        width: parent.width
        height: 8
        color: "#66ff66"
        opacity: 0.08
        y: 0

        SequentialAnimation on y {
            loops: Animation.Infinite

            NumberAnimation {
                from: 0
                to: root.height
                duration: 6000
            }
        }
    }

    Rectangle {
        z: 3
        anchors.fill: parent
        color: "#00ff00"
        opacity: flickerOpacity
        property real flickerOpacity: 0.02

        SequentialAnimation on flickerOpacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.03; duration: 80 }
            NumberAnimation { to: 0.01; duration: 40 }
            NumberAnimation { to: 0.025; duration: 70 }
            NumberAnimation { to: 0.02; duration: 90 }
        }
    }

    Timer {
        id: startupTimer
        interval: 1000
        repeat: false

        onTriggered: {
            typeTimer.start()
            }
    }

    Timer {
        id: typeTimer
        interval: 65
        repeat: true
        running: false

        onTriggered: {
            if (root.currentLine >= root.lines.length) {
                stop()
                root.bootComplete = true
                usernameField.forceActiveFocus()
                return
            }

            var line = root.lines[root.currentLine]
            
            if (root.currentChar < line.length) {
                root.visibleText += line.charAt(root.currentChar)
                playKeySound()
                root.currentChar++
            } else {
                root.visibleText += "\n"
                stop()
                pauseTimer.start()
            }
        }
    }

    Timer {
        id: pauseTimer
        interval: 500
        repeat: false

        onTriggered: {
            root.currentLine++
            root.currentChar = 0

            if (root.currentLine >= root.lines.length) {
                root.bootComplete = true
                usernameField.forceActiveFocus()
            } else {
                typeTimer.start()
            }
        }
    }

    Column {
        z: 4

        anchors {
            left: parent.left
            top: parent.top
            margins: 80
        }

        spacing: 8

        Text {
            text: root.visibleText + (!root.bootComplete ? "_" : "")
            color: root.phosphor
            font.family: "ShureTechMono Nerd Font"
            font.pixelSize: 22
            wrapMode: Text.Wrap
        }

        Column {
            visible: root.bootComplete
            spacing: 8

            Row {
                spacing: 10

                Text {
                    text: "USERNAME:"
                    color: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                }

                TextField {
                    id: usernameField
                    onTextChanged: {
                        playKeySound()
                    }
                    width: 300
                    visible: !root.usernameDone
                    color: root.phosphor
                    selectionColor: "#226622"
                    selectedTextColor: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                    padding: 4

                    cursorDelegate: Text {
                        text: "_"
                        color: root.phosphor
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation {
                            to: 0
                            duration: 500
                            }
                            NumberAnimation {
                            to: 1
                            duration: 500
                            }
                        }
                    }
                    background: Item {}

                    onAccepted: {
                        if (text.length > 0) {
                            root.usernameDone = true
                            passwordField.forceActiveFocus()
                        }
                    }
                }

                Text {
                    visible: root.usernameDone
                    text: usernameField.text
                    color: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                }
            }

            Row {
                visible: root.usernameDone
                spacing: 10

                Text {
                    text: "PASSWORD:"
                    color: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                }

                TextField {
                    id: passwordField
                    onTextChanged: {
                        playKeySound()
                    }
                    width: 300
                    visible: !root.passwordDone
                    echoMode: TextInput.Password
                    passwordCharacter: "*"
                    color: root.phosphor
                    selectionColor: "#226622"
                    selectedTextColor: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                    padding: 4
                    cursorDelegate: Text {
                        text: "_"
                        color: root.phosphor
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation {
                            to: 0
                            duration: 500
                            }
                            NumberAnimation {
                            to: 1
                            duration: 500
                            }
                        }
                    }

                    background: Item {}

                    onAccepted: {
                        if (text.length > 0) {
                            root.passwordDone = true
                            authenticateField.forceActiveFocus()
                        }
                    }
                }

                Text {
                    visible: root.passwordDone
                    text: "*".repeat(passwordField.text.length)
                    color: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                }
            }

            Column {
                visible: root.passwordDone
                spacing: 8

                Text {
                    text: authenticating
                    ? "STATUS: AUTHENTICATING..."
                    : "STATUS: READY"
                    color: root.phosphor
                    font.family: "ShureTechMono Nerd Font"
                    font.pixelSize: 22
                }

                TextField {
                    id: authenticateField
                    visible: passwordDone
                    width: 1
                    height: 1
                    opacity: 0
                    focus: false
                    onAccepted: {
                        authenticating = true
                        powerOffSound.play()
                        sddm.login(
                            usernameField.text,
                            passwordField.text,
                            sessionModel.lastIndex
                        )
                    }
                }
                
                Row {
                    spacing: 0

                    Text {
                        text: "> AUTHENTICATE"
                        color: root.phosphor
                        font.family: "ShureTechMono Nerd Font"
                        font.pixelSize: 22
                    }

                    Text {
                        text: "_"
                        color: root.phosphor
                        font.family: "ShureTechMono Nerd Font"
                        font.pixelSize: 22

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { to: 0; duration: 500 }
                            NumberAnimation { to: 1; duration: 500 }
                        }
                    }
                }
            }
        }
    }
    
    Text {
        id: keyboardToggle

        z:101

        anchors {
            right: parent.right
            bottom: virtualKeyboard.active
                ? virtualKeyboard.top
                : parent.bottom
            rightMargin: 30
            bottomMargin: 20
        }

        text: virtualKeyboard.active
            ? "> HIDE KEYBOARD"
            : "> SHOW KEYBOARD"

        color: root.phosphor
        font.family: "ShureTechMono Nerd Font"
        font.pixelSize: 22

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (virtualKeyboard.active) {
                    virtualKeyboard.active = false
                    Qt.inputMethod.hide ()
                } 
                
                else {
                    virtualKeyboard.active = true
                    Qt.inputMethod.show ()
                }
            }
        }
    }

    InputPanel {
    id: virtualKeyboard

    z: 100
    width: parent.width
    anchors.bottom: parent.bottom

    visible: active
    }
}