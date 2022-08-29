import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 6.3
import QtQuick.Dialogs
import QtMultimedia




Window {
    id: window
    width: 630
    height: 470
    visible: true
    minimumHeight: 480
    minimumWidth: 480
    title: qsTr("Metronom V1.6")


    Item{
        id:logic

        property int number_of_beats: 4
        property int current_beat: 1
        property int current_bpm: 60

        property var list_of_sounds: ["/sounds/snare_1.wav","/sounds/click_2.wav","/sounds/kick_1.wav","/sounds/kick_2.wav","/sounds/hat_1.wav","/sounds/hat_2.wav",]
        property var list_of_sounds_shortened: []

        property string temp_string: "" //for type conversion to Qstring form Qurl

        function show_next_num() //computes each anymation cycle
        {

            beat_num.text = logic.current_beat + 1 //display current beat (make it start with 1 not zero)
            column.list_sound_color_changers[beat_list_computer.list_of_buttons[current_beat].current_color_id].play_sound() //play soound effect of the right color
            visualiser_anim.to = beat_list_computer.color_wheel[beat_list_computer.list_of_buttons[current_beat].current_color_id] //create a transition from black to chosen color
            visualiser_anim.running = true //start the transition animation
            if(logic.current_beat >= number_of_beats -1){ //add beat num or reset back to zero
                logic.current_beat = 0
            }
            else{
                logic.current_beat++
            }



        }

        function create_shortened_sound_list() //creates a display-only list of sound that is maximum 16 characters long
        {
            //list_of_sounds_shortened = list_of_sounds
            logic.list_of_sounds_shortened = []
            for(let i = 0; i < list_of_sounds.length; i++)
            {
                logic.temp_string = qsTr(String(list_of_sounds[i]))
                if(logic.temp_string.length > 20)
                {
                    logic.temp_string = logic.temp_string.slice(-20)
                    list_of_sounds_shortened[i] = "..." + logic.temp_string.slice(0,16)
                }
                else
                {
                    list_of_sounds_shortened[i] = logic.temp_string.slice(0,logic.temp_string.length-4)
                }


            }

        }

        function bpm_to_ms(bpm) //simple bpm conversion
        {
            return 60/bpm*1000
        }

        function update_bpm(new_bpm_value) //updates bpm value everywhere it is used
        {
            clock.interval = logic.bpm_to_ms(new_bpm_value)
            logic.current_bpm = new_bpm_value
            bpm_display_text_filed.update_text(new_bpm_value)

        }

        function toggle_metronome() //make one button act as a toggle ON and OFF
        {
            if(beat_list_computer.current_num_of_buttons !== logic.number_of_beats){
                beat_list_computer.load_beats(logic.number_of_beats)
            }
            if(clock.running === false){
                clock.start()
                toggle_clock_button_text.text = qsTr("Stop")

            }
            else{
                clock.stop()
                toggle_clock_button_text.text = qsTr("Start")
            }

        }

        Timer{ //metronome clock
            id: clock
            interval: 1000 //default interval for 60 bpm

            repeat: true
            onTriggered: logic.show_next_num()
        }

        Timer{ //loader function it will create all dynamicaly allocated objects after startup and also slightly resize the window to avoid layout bug -CHANGE INTERVAL TO 50 if you dont want to see the bug
            id: load_on_startup
            interval: 50

            repeat: false
            running: true //runs on startup

            onTriggered: {
                console.log("loader activated")
                logic.create_shortened_sound_list()
                beat_list_computer.load_beats(4)

                column.load_sound_color_changers()

                window.width = 640
                window.height = 480



                //fileDialog.open()
            }
        }





    }


    FileDialog { //file dialog for choosing new sounds
        id: fileDialog
        title: "Please choose a file"
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            logic.list_of_sounds.push(fileDialog.selectedFiles[0])
            logic.create_shortened_sound_list()
            for(let i = 0; i < column.list_sound_color_changers.length; i++)
            {
                column.list_sound_color_changers[i]. update_sound_list()
            }

        }
        onRejected: {
            console.log("Canceled")

        }

    }
    Dialog { //custom dialog for choosing beat colors
        id: dialog
        width: 300
        anchors.centerIn: parent
        modal: true

        padding: 3
        title: "Vyber si barvu"
        standardButtons: Dialog.Ok | Dialog.Cancel

        property var colors:[0.5,0.5,0.5]
        property int color_id: 0

        function dialog_update() //updates all the sliders to corext dialog caluese
        {
            red_slider.value= colors[0]
            green_slider.value= colors[1]
            blue_slider.value= colors[2]
        }
        function dialog_open_with_hex(hex_color_value,id) //alows the dialog to open with an hex coded color as a starting value
        {
            //compute
            colors[0] = parseInt(hex_color_value.slice(1, 3), 16)/255
            colors[1] = parseInt(hex_color_value.slice(3, 5), 16)/255
            colors[2] = parseInt(hex_color_value.slice(5, 7), 16)/255
            //update color sliders
            red_slider.value= colors[0]
            green_slider.value= colors[1]
            blue_slider.value= colors[2]
            //set correct color id
            color_id = id
            //open dialog
            dialog.open()

        }

        onAccepted:{
            let hex_color = qsTr(Qt.rgba(colors[0],colors[1],colors[2],1).toString()) //computes back the hex color
            beat_list_computer.color_wheel[color_id] = hex_color //asigns the color to the correct position
            console.log("u have chosen: " + hex_color)
            column.list_sound_color_changers[color_id].update_color() //updates all color indicator in the main column
            beat_list_computer.update_beats_color()

        }

        onRejected: console.log("Cancel clicked")


        Column { //dialog structure
            id: dialog_column
            anchors.fill: parent
            spacing: 4


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

                        value: dialog.colors[0]

                        onValueChanged: {
                            dialog.colors[0] = value
                            color_display_rectangle.color = Qt.rgba(dialog.colors[0],dialog.colors[1], dialog.colors[2],1)

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

                        value: dialog.colors[1]

                        onValueChanged: {
                            dialog.colors[1] = value
                            color_display_rectangle.color = Qt.rgba(dialog.colors[0], dialog.colors[1], dialog.colors[2],1)

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
                    text: qsTr("B")
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

                        value: dialog.colors[2]

                        onValueChanged: {

                            dialog.colors[2] = value

                            color_display_rectangle.color = Qt.rgba(dialog.colors[0], dialog.colors[1], dialog.colors[2],1)
                            console.log(Qt.rgba(dialog.colors[0], dialog.colors[1], dialog.colors[2],1))
                        }


                    }
                }

            }

            Rectangle {
                id: color_display_rectangle
                height: 30
                color: Qt.rgba(dialog.colors[0], dialog.colors[1], dialog.colors[2],1)
                anchors.left: parent.left
                anchors.right: parent.right
                radius: 8
            }

        }




    }



    Column { //main controls column
        id: column
        x: 422
        width: 200
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: add_new_sound_button.top
        spacing: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        anchors.rightMargin: 8

        property var list_sound_color_changers: []
        property var currently_selected_sounds: ["sounds/click_1.wav","sounds/click_1.wav","sounds/click_1.wav"]

        function load_sound_color_changers()
        {
            const component = Qt.createComponent("color_sound_changer.qml");

            for (let i = 0; i<beat_list_computer.color_wheel.length; i++)
            {
                let obj = component.createObject(column)
                obj.sound_color_changer_id = i
                list_sound_color_changers.push(obj)
                console.log(list_sound_color_changers)


            }


        }




        Rectangle {
            id: bpm_display
            height: 100
            color: "#c1c1c1"
            radius: 12
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.leftMargin: 8

            Text {
                id: bpm_display_text_filed
                height: 45
                text: qsTr("60 BPM")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: 40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.topMargin: 8

                function update_text(value) {
                    bpm_display_text_filed.text = value + " BPM"
                }
            }

            Rectangle {
                id: bpm_slider_background
                height: 30
                color: "#ffffff"
                radius: 12
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.rightMargin: 8
                anchors.leftMargin: 8

                Slider {
                    id: dial
                    anchors.fill: parent
                    anchors.rightMargin: 12
                    anchors.leftMargin: 12
                    stepSize: 1
                    snapMode: Slider.SnapAlways
                    value: 60
                    to: 240
                    from: 25

                    onValueChanged: {
                        logic.update_bpm(value)
                    }
                }
            }
        }

        Rectangle {
            id: toggle_clock_button
            height: 50
            color: "#ffffff"
            radius: 12
            border.color: "#c1c1c1"
            border.width: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.leftMargin: 8

            MouseArea{
                id: toggle_clock_button_mousearea
                anchors.fill: parent
                onClicked:logic.toggle_metronome()




            }

            Text {
                id: toggle_clock_button_text
                text: qsTr("Start")
                anchors.fill: parent
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        ManualTempoClicker{}



    }

    Row {
        id: beat_list //creates a dynamicaly alocated beat indicator list inside a row
        y: 372
        height: 60
        anchors.left: parent.left
        anchors.right: column.left
        anchors.bottom: rectangle.top
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.rightMargin: 6
        Item {
            id: beat_list_computer //holds all beat_list logic
            readonly property int button_width: parent.width/current_num_of_buttons
            readonly property int margin_top_bottom: 4
            readonly property int margin_side: 3
            readonly property int corner_radius: 12
            readonly property var color_wheel: ["#f0f8ff","#8b0000","#1e90ff"]


            property int current_num_of_buttons: 0 //number of currently created buttons
            property var list_of_buttons: [] //list of all dynamicaly allocated buttons

            function load_beats(num_of_buttons) //loads beat indicato
            {
                let clock_status = clock.running


                if(clock_status == true)
                {

                    clock.stop()
                }


                const component = Qt.createComponent("num_template.qml");

                if (current_num_of_buttons > num_of_buttons) //destroy some buttons
                {
                    for(let i = 0; i < current_num_of_buttons-num_of_buttons;i++)
                    {
                        let obj = list_of_buttons[--current_num_of_buttons]
                        list_of_buttons.pop()
                        obj.destroy()


                    }
                }
                else{
                    let old_num_of_buttons = current_num_of_buttons
                    for (let i = 0; i<num_of_buttons-old_num_of_buttons; i++)
                    {
                        let obj = component.createObject(beat_list)
                        obj.num_index = current_num_of_buttons++
                        list_of_buttons.push(obj)



                    }


                }

                if(clock_status == true)
                {
                    clock.start()
                }


            }

            function update_beats_color(){
                const component = Qt.createComponent("num_template.qml");
                for(let i = 0; i < list_of_buttons.length; i++)
                {
                    list_of_buttons[i].update_color()
                }
            }


        }
    }





    Rectangle {
        id: beat_visualiser
        color: "#f0f8ff"
        radius: 12
        border.color: "#c1c1c1"
        border.width: 8
        anchors.left: parent.left
        anchors.right: column.left
        anchors.top: parent.top
        anchors.bottom: beat_list.top
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8


        PropertyAnimation {
            id: visualiser_anim
            target: beat_visualiser
            property: "color"
            from: "black"
            to: "red"
            duration: 200
            //easing: easing.InExpo

        }

        Text {
            id: beat_num
            x: 184
            width: 200
            height: 200
            text: qsTr("1")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 200
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }


    }

    Rectangle {
        id: rectangle
        y: 437
        height: 40
        color: "#c1c1c1"
        radius: 12
        anchors.left: parent.left
        anchors.right: column.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.rightMargin: 8

        Text {
            id: napis_pocet_dob
            width: 110
            text: qsTr("Počet dob")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.bottomMargin: 8
            anchors.topMargin: 8
            anchors.leftMargin: 8
        }

        Rectangle {
            id: slider_background
            color: "#ffffff"
            radius: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 34
            anchors.leftMargin: 124
            anchors.bottomMargin: 8
            anchors.topMargin: 8

            Slider {
                id: pocet_dob_slider
                anchors.fill: parent
                snapMode: RangeSlider.SnapAlways
                stepSize: 1
                to: 8
                from: 2
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 4
                anchors.topMargin: 4
                value: 4
                onValueChanged: {
                    logic.current_beat = 0
                    logic.number_of_beats = value
                    beat_list_computer.load_beats(value)
                }
            }
        }

        Text {
            id: pocet_dob_display
            x: 391
            width: 25
            text: pocet_dob_slider.value
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 8
            anchors.bottomMargin: 8
            anchors.topMargin: 8
        }
    }








    Rectangle {
        id: add_new_sound_button
        height: 40
        color: "#ffffff"
        radius: 12
        border.color: "#c1c1c1"
        border.width: 8
        anchors.left: rectangle.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8


        MouseArea{
            id: add_new_sound_button_mousearea
            anchors.fill: parent
            onClicked:{fileDialog.open()}




        }

        Text {
            id: add_new_sound_button_text
            text: qsTr("Přidat nový zvuk")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }


}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}D{i:24}
}
##^##*/
