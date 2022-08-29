import QtQuick 2.15


    Rectangle {
        width: beat_list_computer.button_width
        height: 60
        color: "#00ffffff"
        border.color: "#00000000"
        property int num_index: 0
        property int current_color_id: 0


        function cycle_colors(){
            if(current_color_id < beat_list_computer.color_wheel.length-1)
            {
                current_color_id++
            }
            else{
                current_color_id = 0
            }
            update_color()
        }
        function update_color()
        {
            beat_button.color = beat_list_computer.color_wheel[current_color_id]
        }

        Rectangle {
            objectName: "num"
            id: beat_button
            color: beat_list_computer.color_wheel[current_color_id]
            radius: beat_list_computer.corner_radius
            border.color: "#c1c1c1"
            border.width: 6
            anchors.fill: parent
            anchors.rightMargin: beat_list_computer.margin_side
            anchors.leftMargin: beat_list_computer.margin_side
            anchors.bottomMargin: beat_list_computer.margin_top_bottom
            anchors.topMargin: beat_list_computer.margin_top_bottom


            MouseArea {
                anchors.fill: parent
                onClicked: parent.parent.cycle_colors()
            }

            Text {
                text: parent.parent.num_index + 1
                anchors.fill: parent
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

