import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.3
import QtMultimedia



Rectangle {
    id: sound_color_changer
    height: 40
    color: "#c1c1c1"
    radius: 12
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 8
    anchors.rightMargin: 8

    property int sound_color_changer_id: 0 //coresponds to index in the color_wheel list of colors
    property int sound_id: 0

    function update_color()
    {
        sound_color_changer_button.color = beat_list_computer.color_wheel[sound_color_changer_id]
    }

    function update_sound_list()
    {
        logic.create_shortened_sound_list()
        sound_color_changer_combobox.model = logic.list_of_sounds_shortened
        console.log("updated sound list")
    }

    function play_sound()
    {
        console.log(sound_color_changer_combobox.currentIndex)
        if(sound_color_changer_combobox.currentIndex !== sound_id)
        {
            sound_id = sound_color_changer_combobox.currentIndex
            playSound.source = logic.list_of_sounds[sound_id]
        }

        playSound.play()
        //console.log(playSound.status)
        //console.log(playSound.source)
    }

    SoundEffect {
                    id: playSound
                    source: logic.list_of_sounds[sound_id]
                    //source: "/sounds/snare_1.wav"
                    loops: 1
                }

    Rectangle {
        id: sound_color_changer_button
        width: 30
        color: beat_list_computer.color_wheel[parent.sound_color_changer_id]
        radius: 12
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8

        MouseArea {
            id: sound_color_changer_button_mousearea
            anchors.fill: parent
            onClicked: {
                dialog.dialog_open_with_hex(beat_list_computer.color_wheel[sound_color_changer.sound_color_changer_id],sound_color_changer.sound_color_changer_id)

            }
        }
    }



    ComboBox {
        id: sound_color_changer_combobox
        anchors.left: sound_color_changer_button.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        flat: false
        currentIndex: 0
        font.pointSize: 10
        spacing: 3
        wheelEnabled: true
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        anchors.leftMargin: 4

        //currentIndex: //sound_color_changer.sound_color_changer_id

        model: logic.list_of_sounds_shortened


    }
}
