import QtQuick 2.15
import QtQuick.Controls 6.3

Rectangle {
    id: manual_tempo_clicker
    height: 88
    color: "#c1c1c1"
    radius: 12
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 8
    anchors.leftMargin: 8

    focus: true

    Keys.onPressed: (event)=> {
                        console.log(event.key)
                        if (event.key === 32)
                        {
                            clicked()
                        }
                    }

    property var times: [1,1,1]
    property int number_of_preses: 0
    property double last_press_time: 0
    property int computed_bpm: 120

    function clicked(){

        let time = new Date().getTime()
        if(time - last_press_time < 3000 ){
            number_of_preses++
            times[0] = times[1]
            times[1] = times[2]
            times[2] = time-last_press_time

            console.log(times)
            //check if we can compute bpm
            if(number_of_preses >= 3)
            {
                let average_time = (times[2]*2 + times[1] + times[0]*0.5)/3.5
                computed_bpm = Math.round(60000/average_time)
                manual_tempo_clicker_bpm_display_text.text = computed_bpm + " BPM"
                console.log(average_time + " computed bpm: " + computed_bpm)


            }
        }
        else{

            //reset everything
            times[0]=0
            times[1]=0
            times[2]=0
            number_of_preses = 0

            console.log("to long between clicks")
        }
        last_press_time = time


    }

    Rectangle {
        id: manual_tempo_clicker_button
        height: 40
        color: "#ffffff"
        radius: 8
        border.width: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.topMargin: 8



        Text {
            id: manual_tempo_clicker_button_text
            text: qsTr("Naklikej si tempo (mezernik)")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: manual_tempo_clicker_button_mousearea
            anchors.fill: parent
            onClicked: manual_tempo_clicker.clicked()

        }
    }

    Rectangle {
        id: manual_tempo_clicker_bpm_display
        width: 80
        color: "#ffffff"
        radius: 8
        anchors.left: parent.left
        anchors.top: manual_tempo_clicker_button.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.leftMargin: 8
        anchors.topMargin: 8

        Text {
            id: manual_tempo_clicker_bpm_display_text
            text: qsTr("120 BPM")
            anchors.fill: parent
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: manual_tempo_clicker_apply
        color: "#ffffff"
        radius: 8
        anchors.left: manual_tempo_clicker_bpm_display.right
        anchors.right: parent.right
        anchors.top: manual_tempo_clicker_button.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.topMargin: 8

        Text {
            id: manual_tempo_clicker_apply_text
            text: qsTr("Aplikovat")
            anchors.fill: parent
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: manual_tempo_clicker_apply_mousearea
            anchors.fill: parent

            onClicked: {
                logic.update_bpm(manual_tempo_clicker.computed_bpm)
            }
        }
    }
}

