import QtQuick 2.15
import QtQuick.Controls 6.3

Column {
    id: dialog_column
    anchors.fill: parent
    spacing: 4
    Item
    {
        id:values
        property var colors:[0.5,0.5,0.5]
        property int color_id: 0
    }


    Rectangle {

        height: 40
        color: "#c1c1c1"
        radius: 8
        border.width: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Text {
            id: red
            text: qsTr("R")
            anchors.left: parent.left
            anchors.right: red_slider_background.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            anchors.leftMargin: 8
            anchors.rightMargin: 8
        }

        Rectangle {
            id: red_slider_background
            color: "#ffffff"
            radius: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            anchors.leftMargin: 34
            anchors.bottomMargin: 8
            anchors.topMargin: 8

            Slider {
                id: red_slider
                anchors.fill: parent
                to: 1
                from: 0
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 4
                anchors.topMargin: 4

                value: values.colors[0]

                onValueChanged: {
                    values.colors[0] = value
                    color_display_rectangle.color = Qt.rgba(values.colors[0], values.colors[1], values.colors[2],1)

                }

            }
        }

    }

Rectangle {

    height: 40
    color: "#c1c1c1"
    radius: 8
    border.width: 0
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.leftMargin: 0


    Text {
        id: green
        text: qsTr("G")
        anchors.left: parent.left
        anchors.right: green_slider_background.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8
    }

    Rectangle {
        id: green_slider_background
        color: "#ffffff"
        radius: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 8
        anchors.leftMargin: 34
        anchors.bottomMargin: 8
        anchors.topMargin: 8

        Slider {
            id: green_slider
            anchors.fill: parent
            to: 1
            from: 0
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 4
            anchors.topMargin: 4

            value: values.colors[1]

            onValueChanged: {
                values.colors[1] = value
                color_display_rectangle.color = Qt.rgba(values.colors[0], values.colors[1], values.colors[2],1)

            }


        }
    }

}
Rectangle {

    height: 40
    color: "#c1c1c1"
    radius: 8
    border.width: 0
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.leftMargin: 0


    Text {
        id: blue
        text: qsTr("G")
        anchors.left: parent.left
        anchors.right: blue_slider_background.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8
    }

    Rectangle {
        id: blue_slider_background
        color: "#ffffff"
        radius: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 8
        anchors.leftMargin: 34
        anchors.bottomMargin: 8
        anchors.topMargin: 8

        Slider {
            id: blue_slider
            anchors.fill: parent
            to: 1
            from: 0
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 4
            anchors.topMargin: 4

            value: values.colors[2]

            onValueChanged: {

                values.colors[2] = value

                color_display_rectangle.color = Qt.rgba(values.colors[0], values.colors[1], values.colors[2],1)
                console.log(Qt.rgba(values.colors[0], values.colors[1], values.colors[2],1))
            }


        }
    }

}

Rectangle {
    id: color_display_rectangle
    height: 30
    color: Qt.rgba(values.colors[0], values.colors[1], values.colors[2],1)
    anchors.left: parent.left
    anchors.right: parent.right
    radius: 8
}

}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:14}
}
##^##*/
