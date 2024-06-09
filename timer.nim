import std/[times, os]
from std/strutils import parseInt
from strformat import fmt

var threads: array[10, Thread[int]]
var t_startpoint: array[10, Time]
var t_running: int = 0

proc ShowMenu() =
    echo "------ MENU -------"
    echo "1. Set timer"
    echo "2. Show timers"
    echo "3. Exit"
    echo "-------------------"

proc ShowTimers() =
    var dif_time: Duration
    echo "--- TIMER TABLE ---"
    echo "TIMERS ", t_running
    for i in 0..t_running:
        if threads[i].running():
            dif_time = getTime() - t_startpoint[i]
            echo fmt"Timer {threads[i].data / 1000}s / {inSeconds(dif_time)}.{inNanoseconds(dif_time)}s"
    echo "-------------------"

proc ThreadTimer(time_to_wait: int) {.thread.} =
    let t_index = t_running
    t_running.inc
    t_startpoint[t_index] = getTime()
    sleep(time_to_wait)
    echo "----- FINISHED ----"
    echo fmt"Finished timer of {time_to_wait / 1000}s"
    echo "-------------------"
    t_running.dec

var entry: string
var running: bool = true
ShowMenu()
while running:
    entry = readLine(stdin)

    case entry
    of "1":
        stdout.write "Set the seconds: "
        entry = readLine(stdin)
        echo fmt"Set a timer of {entry}s"
        createThread(threads[t_running], ThreadTimer, parseInt(entry) * 1000)

    of "2":
        ShowTimers()
    
    of "3":
        echo "Exiting..."
        break         