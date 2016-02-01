+++
Categories = []
Tags = []
date = "2016-01-31T21:50:30-08:00"
title = "Robot on the Move"

+++

The hard part of making something look easy is knowing what the easy way is.
For instance, I didn't know the easy way to run DC motors from an Arduino
motor shield that is compatible with Adafruit Motor Shield was to use
the [Adafruit Motor Shield Library](https://github.com/adafruit/Adafruit-Motor-Shield-library), which has high level functions to control
said motors. I started from the wrong place. I started by wanting to issue
instructions to the Arduino UNO via the serial port with Python running on
my laptop or a Raspberry Pi. That lead me to pyFirmata, which is designed
to make the serial control easy. You could address and control individual
pins of the UNO. This lead me to try to run the motors via the low level
pin settings, and that was unfortunate because how to do this through the 
motor shield is not well documented, you don't know which pin settings
correspond to the four motor connectors on the board. The creators assume
one would be using the Library. After reading the code for a while and not
making progress, I went to sleep.

How about skipping the idea of remote control for now and get some practice
writing [Processing code with the Motor Shield Library](https://learn.adafruit.com/adafruit-motor-shield/using-dc-motors) and make sure I have 
the wiring setup properly. I also noted any processing code can [send and
receive serial port data](http://playground.arduino.cc/Interfacing/Python), so that's how I could send higher level commands
to the Arduino, and it could translate to the lower level pin operations.

Now I'm cooking. My little bot is rolling back and forth on it's own.

<iframe width="560" height="315" src="https://www.youtube.com/embed/0rJXJY-54lA" frameborder="0" allowfullscreen></iframe>

