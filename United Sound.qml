//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2012-2017 Werner Schweer
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
    version:  "3.0"
    description: "This test plugin walks through all elements in a score"
    menuPath: "Plugins.United Sound"
    function food_color(notey, text) {
        var colors = ["#e21c48", "#f26622", "#f99d1c", "#ffcc33", "#fff32b", "#bcd85f", "#62bc47", "#009c95", "#0071bb", "#5e50a1", "#8d5ba6", "#cf3e96" ];
        var note = notey.notes[0];
        if (text.color == "#000000") {
            text.color = colors[note.pitch % 12];
        } else {
            text.color = "#000000";
        }
    }
      function food_notes(duration, text, notey) {
            text.fontFace = "United Sound";
            text.fontSize = 24;
            text.autoplace = false;
            notey.notes[0].visible = false;
            var noteLine = notey.notes[0].line;
            var xOffset =  -1.56
            var yOffset = (noteLine) / 2;
            console.log(text.autoplace);
            if (duration == "1/4") {
                  text.text = qsTranslate("InspectorAmbitus", "$") + text.text;
            } else if (duration == "1/2")  {
                  xOffset = -5.15
                  text.text = qsTranslate("InspectorAmbitus", "!") + text.text;
            }
             text.offset = Qt.point(xOffset, yOffset)
      }
    function color_notes(notey) {
        var colors = ["#e21c48", "#f26622", "#f99d1c", "#ffcc33", "#fff32b", "#bcd85f", "#62bc47", "#009c95", "#0071bb", "#5e50a1", "#8d5ba6", "#cf3e96" ];
        var note = notey.notes[0];
        if (note.color == "#000000") {
            note.color = colors[note.pitch % 12];
        } else {
            note.color = "#000000";
        }

        if (note.accidental) {
            if (note.accidental.color == "#000000") {
                note.accidental.color = colors[note.pitch % 12];
            } else {
                note.accidental.color = "#000000";
            }
        }

        for (var i = 0; i < note.dots.length; i++) {
            if (note.dots[i]) {
                if (note.dots[i].color == "#000000") {
                        note.dots[i].color = colors[note.pitch  % 12];
                } else {
                    note.dots[i].color = "#000000";
                }
            }
        }
    }

    onRun: {
        var cursor = curScore.newCursor();
        var startStaff;
        var endStaff;
        var endTick;
        var fullScore = false;
        cursor.rewind(1);
        if (!cursor.segment) { // no selection
            fullScore = true;
            startStaff = 0; // start with 1st staff
            endStaff  = curScore.nstaves - 1; // and end with last
        } else {
            startStaff = cursor.staffIdx;
            cursor.rewind(2);
            if (cursor.tick === 0) {
                // this happens when the selection includes
                // the last measure of the score.
                // rewind(2) goes behind the last segment (where
                // there's none) and sets tick=0
                endTick = curScore.lastSegment.tick + 1;
            } else {
                endTick = cursor.tick;
            }
        endStaff = cursor.staffIdx;
        }

        for (var staff = startStaff; staff <= endStaff; staff++) {
            for (var voice = 0; voice < 4; voice++) {
                cursor.rewind(1); // beginning of selection
                cursor.voice    = voice;
                cursor.staffIdx = staff;

                if (fullScore)  // no selection
                    cursor.rewind(0); // beginning of score
                while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                    var e = cursor.element;
                    if (e) {
                        if (e.type != Element.REST) {
                            //color_notes(e);
                            var text = newElement(Element.STAFF_TEXT);
                            var dur = e.duration.numerator + "/" + e.duration.denominator;
                            food_notes(dur, text, e);
                            food_color(e, text);
                            cursor.add(text);
                        }
                    }
                    cursor.next();
                }
                Qt.quit();
            }
        }
    }
}