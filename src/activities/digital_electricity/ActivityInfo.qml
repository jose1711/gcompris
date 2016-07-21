/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "digital_electricity/DigitalElectricity.qml"
  difficulty: 1
  icon: "digital_electricity/digital_electricity.svg"
  author: "Pulkit Gupta &lt;pulkitnsit@gmail.com&gt;"
  demo: true
  title: qsTr("Digital Electricity")
  description: qsTr("Create and simulate a digital electric schema")
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("Freely create a digital electric schema with a real time simulation of it.")
  prerequisite: qsTr("Requires some basic understanding of the concept of digital electronics.")
  manual: qsTr("Drag electrical components from the selector and drop them in the working area.You can also move components by dragging them. To delete a component, select the deletion tool on top of the component selector, and select the component. You can click on the component and then on the rotate button to rotate it or info button to get information about it. You can click on the switch to open and close it. The simulation is updated in real time by any user action.")
  credit: ""
  section: "fun"
  createdInVersion: 7000
}
