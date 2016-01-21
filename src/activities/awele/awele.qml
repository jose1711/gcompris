/* GCompris - oware
 *
 * Copyright (C) 2014-2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "."
import "awele.js" as Activity
ActivityBase{
    id: activity
    property bool player: false
    property string value: "4"
    onStart:{focus=true
    }
    onStop: {}

    pageComponent:Image{
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        source: Activity.url + "/background.jpg"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        Keys.onPressed: {
            if(firstScreen.visible) {
                // If return, we hide the screen
                firstScreen.visible = false
                return;
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject{
            id:items

            property Item main: activity.main
            property alias learnOware:learnOware
            property alias background: background
            property alias row: rowButton
          //  property alias textOneSource: playerOneText
           // property alias textTwoSource: playerTwoText
            property alias repeator: repeator
        }

        onStart:{ Activity.start(items) }
        onStop: {Activity.stop()}

        Image{
            id:learnOware
            source:Activity.url+"background.jpg"
            anchors.fill:parent
            visible: true
            MouseArea{
                anchors.fill:parent
                onClicked:{
                    parent.visible=false
                }
            }
        }

        Rectangle{
            id:playerOneScore
            anchors{
                left:board.right
                verticalCenter: board.verticalCenter
                leftMargin: 20*ApplicationInfo.ratio
            }
            color: "green"
            Image{
                id:imageOne
                anchors.leftMargin: 5*ApplicationInfo.ratio
                anchors.centerIn: parent
                source:Activity.url+"/score.png"
                GCText {
                    id: playerTwoText
                    color: "white"
                    property var textSource:Activity.playerTwoPoints
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: textSource
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }
            }
            GCText {
                id: south
                color: "white"
                property var textSource:Activity.playerOnePoints
                anchors.top: imageOne.bottom
                anchors.horizontalCenter: imageOne.horizontalCenter
                fontSize: smallSize
                text: "South"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        Image {
            id: board
            source: Activity.url + "/awele_board.png"
            anchors.centerIn: parent
            //anchors.fill:parent
            width:parent.width*0.6
            height:parent.height*0.5
        }

        Rectangle{
            id:playerTwoScore
            anchors{
                rightMargin: 20*ApplicationInfo.ratio
                right:board.left
                verticalCenter: board.verticalCenter
            }
            color: "green"
            Image{
                id:imageTwo
                anchors.centerIn: parent
                anchors.leftMargin: 5*ApplicationInfo.ratio
                source:Activity.url+"/score.png"
                GCText {
                    id: playerOneText
                    color: "white"
                    property var textSource:Activity.playerOnePoints
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: textSource
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }
            }
            GCText {
                id: north
                color: "white"
                property var textSource:Activity.playerOnePoints
                anchors.bottom: imageTwo.top
                anchors.horizontalCenter: imageTwo.horizontalCenter
                fontSize: smallSize
                text: "north"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
            }
        }

        Grid {
            id:boardGrid
            columns:6
            rows:2
            spacing: 10*ApplicationInfo.ratio
            anchors {
                horizontalCenter: board.horizontalCenter
              //  verticalCenter: board.verticalCenter*(1/3)
                top : board.top
                margins: 5*ApplicationInfo.ratio
            }
            Repeater{
                id:repeator
                model:12
                    Rectangle {
                        color: "transparent"
                        height: board.height/2
                        width: board.width*(1/7)
                        property var value: Activity.getValueByIndex(index,player)
                        property var circleRadius: width
                        radius: circleRadius
                        Text{
                            text:value
                            color: "white"
                            font.bold: true
                            font.family: "Helvetica"
                            font.pixelSize:24
                            anchors.bottom: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Repeater {
                            model: value
                            Image {
                                source: Activity.url+"graine1.png"
                                x:circleRadius/2-sourceSize.width/2+Activity.getX(height,index,value)
                                y:circleRadius/2+sourceSize.height/2+Activity.getY(height,index,value)
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                    console.log("value and index",parent.parent.x,parent.parent.y,value,index)
                                    }
                                }
                            }
                        }
                    }
                 }
             }

        Row {
            id:rowButton
            height: boardGrid.height*(1/6)
            width: board.width
            spacing: board.width*(1/10)
            anchors {
                horizontalCenter: board.horizontalCenter
                top: board.bottom
                topMargin: 5*ApplicationInfo.ratio
            }
            Repeater {
                    id:rowButtonRepeator
                    model:6
                    Image {
                       property var sourceString: Activity.url + "bouton"+(index+1)+".png"
                       source: sourceString
                       MouseArea {
                           anchors.fill:parent
                           hoverEnabled: true
                           onClicked:{
                               var level=1;
                                if(Activity.getValueByIndex(index,player)!=0){
                                   //Activity.twoPlayer(index,player);
                                   Activity.newAi(1,index,player)
                                   // player=!player;

                                }
                                else{
                                    console.log("click 0",player,index);
                                }

                                Activity.updateValues();
                                Activity.updateScores();
                                sourceString: Activity.url + "bouton"+(index+1)+".png"
                           }
                           onPressed: {
                               sourceString=Activity.url + "bouton"+(index+1)+"_clic.png";
                           }
                           onReleased: {
                               sourceString=Activity.url + "bouton"+(index+1)+".png";
                           }

                           onEntered: {

                               sourceString=Activity.url + "bouton"+(index+1)+"_notify.png";
                           }
                           onExited: {
                               ;
                               sourceString=Activity.url + "bouton"+(index+1)+".png";

                           }
                        }
                    }
                }
           }

        Image{
            id:firstScreen
            anchors.fill: parent
            //fillMode: Image.PreserveAspectFit
            source:Activity.url+"background.jpg"
            sourceSize.width: parent.width
            GCText {
                id: head
                text:qsTr("Learn Owares")
                fontSize: largeSize
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                anchors.centerIn: parent.Center
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
            }
//            Image {
//                id: introChar
//                source: Activity.url + "holecircle.png"
//                sourceSize.width: parent.width * 0.25
//                fillMode: Image.PreserveAspectFit
//                verticalAlignment: Image.AlignTop
//                anchors {
//                    top: heading.bottom
//                    topMargin: 30 * ApplicationInfo.ratio
//                    bottom: parent.bottom
//                    bottomMargin: 60 * ApplicationInfo.ratio
//                    left: parent.left
//                    leftMargin:  30 * ApplicationInfo.ratio
//                }
//            }
//            ListView {
//                   id: visualModel
//                   model:ListModel{
//                       id:texts
//                       ListElement {TEXT:"To sow you must take all the seeds of  any of your holes and lay its out along the holes against the direction of the clockwise. In every hole you should lay it out one seed.  If you reach the last hole of your ground you must continue in the land of the other player. Remember, you always have to lay out seeds in the direction against the clockwise.";head:" Oware Rule 1 : sowing "}
//                       ListElement {TEXT:"If the last hole where you sow is in the land of the other player and there are two or three seeds in the last hole remove from the board and keep them. If the previous holes also contain two or three seeds also remove them and remove all the seeds of your opponent that contains two or three seeds.";head:" Oware Rule 2 : harvesting "}
//                       ListElement {TEXT:"As the game progresses, is possible that one hole contains more than 12 seeds. This hole is called Kroo and makes possible complete one round. When the harvest starts at the Kroo, this hole must finish empty what means that the player shouldn’t lay out any seed.";head:" Oware Rule 3 :  The Kroo  "}
//                       ListElement {TEXT:"If the other player has only one seed in his field you will have to remove it in order to harvest and continue playing. This situation means that the other player will not be able keep playing.Players must provide in advance to avoid this situation. For example, having at least one seed in the last hole to harvest immediately to our opponent side and allow him to keep playing.If this is impossible, because we only have one seed in our land. The game is finished. Teh winner is the one that harvest more.";head:" Oware Rule 4 :  You can’t permit other players feel hungry "}
//                       ListElement {TEXT:"When there are few seeds left on the counter, the game may be perpetuating and hardly any of the 2 players can capture any new seed. By mutual agreement player can agree the end of the game. In this case every player is the owner of the seeds in his side.  As always, who has garnered more wins the match.";head:" Oware Rule 5 : The final agreement"}
//                   }

//                   delegate:Component{

//                       GCText {
//                           text:head
//                           fontSize: smallSize
//                           font.weight: Font.DemiBold
//                           //horizontalAlignment: Text.AlignJustify
//                           anchors {
//                               topMargin: 30 * ApplicationInfo.ratio

//                               rightMargin: 30 * ApplicationInfo.ratio
//                               leftMargin: 30 * ApplicationInfo.ratio
//                           }
//                           color: "white"
//                           wrapMode: Text.WordWrap
//                       }
//                       GCText {
//                           id: bodyText
//                           text:TEXT
//                           fontSize: smallSize
//                           font.weight: Font.DemiBold
//                           horizontalAlignment: Text.AlignJustify
//                           anchors {
//                               topMargin: 30 * ApplicationInfo.ratio
//                               rightMargin: 30 * ApplicationInfo.ratio
//                               leftMargin: 30 * ApplicationInfo.ratio
//                           }
//                           color: "white"
//                           wrapMode: Text.WordWrap
//                       }
//                    }
//                }
//            ListView{
//                id:textList
//                width:parent.width
//                model: texts
//                delegate: detailDelegate
//                ListModel{
//                    id:texts
//                    ListElement {TEXT:"To sow you must take all the seeds of  any of your holes and lay its out along the holes against the direction of the clockwise. In every hole you should lay it out one seed.  If you reach the last hole of your ground you must continue in the land of the other player. Remember, you always have to lay out seeds in the direction against the clockwise.";head:" Oware Rule 1 : sowing "}
//                    ListElement {TEXT:"If the last hole where you sow is in the land of the other player and there are two or three seeds in the last hole remove from the board and keep them. If the previous holes also contain two or three seeds also remove them and remove all the seeds of your opponent that contains two or three seeds.";head:" Oware Rule 2 : harvesting "}
//                    ListElement {TEXT:"As the game progresses, is possible that one hole contains more than 12 seeds. This hole is called Kroo and makes possible complete one round. When the harvest starts at the Kroo, this hole must finish empty what means that the player shouldn’t lay out any seed.";head:" Oware Rule 3 :  The Kroo  "}
//                    ListElement {TEXT:"If the other player has only one seed in his field you will have to remove it in order to harvest and continue playing. This situation means that the other player will not be able keep playing.Players must provide in advance to avoid this situation. For example, having at least one seed in the last hole to harvest immediately to our opponent side and allow him to keep playing.If this is impossible, because we only have one seed in our land. The game is finished. Teh winner is the one that harvest more.";head:" Oware Rule 4 :  You can’t permit other players feel hungry "}
//                    ListElement {TEXT:"When there are few seeds left on the counter, the game may be perpetuating and hardly any of the 2 players can capture any new seed. By mutual agreement player can agree the end of the game. In this case every player is the owner of the seeds in his side.  As always, who has garnered more wins the match.";head:" Oware Rule 5 : The final agreement"}
//                }
//                Component{
//                    id:detailDelegate
//                    GCText {
//                        id: bodyHead
//                        text:head
//                        fontSize: smallSize
//                        font.weight: Font.DemiBold
//                        //horizontalAlignment: Text.AlignJustify
//                        anchors {
//                            topMargin: 30 * ApplicationInfo.ratio

//                            rightMargin: 30 * ApplicationInfo.ratio
//                            leftMargin: 30 * ApplicationInfo.ratio
//                        }
//                        color: "white"
//                        wrapMode: Text.WordWrap
//                    }
//                    GCText {
//                        id: bodyText
//                        text:TEXT
//                        fontSize: smallSize
//                        font.weight: Font.DemiBold
//                        horizontalAlignment: Text.AlignJustify
//                        anchors {
//                            topMargin: 30 * ApplicationInfo.ratio
//                            rightMargin: 30 * ApplicationInfo.ratio
//                            leftMargin: 30 * ApplicationInfo.ratio
//                        }
//                        color: "white"
//                        wrapMode: Text.WordWrap
//                    }
//                }
//            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }

    }

}

