+++
Categories = []
Tags = []
date = "2016-01-09T16:45:02-08:00"
title = "Auto-run PyPy Service on Pi"
draft = false

+++

Today I wanted to have an example [NATS](http://nats.io/) client worker service 
written in Python utilizing my [txnats](https://github.com/johnwlockwood/txnats)
and run by the PyPy interpreter on my Raspberry PI 2 auto run upon bootup.

One way to do this is with [systemd](https://wiki.archlinux.org/index.php/Systemd),
which is built into Rasbian jessie. You define a service file that defines 
the application launch command to run and things like its working directory.
[How To Autorun A Python Script On Boot Using systemd](http://www.raspberrypi-spy.co.uk/2015/10/how-to-autorun-a-python-script-on-boot-using-systemd/)
was a helpful reference.

With a fresh install of Raspbian jessie, I downloaded pypy and got pip installed.
My other Raspberry Pi 2 had Rasbian wheezy on it, so began the 
[upgrade](https://www.raspberrypi.org/forums/viewtopic.php?t=121880).

Because [txnats](https://github.com/johnwlockwood/txnats) depends on [Twisted](http://twistedmatrix.com/trac/), I initially followed 
[Deploying Twisted with systemd](https://twistedmatrix.com/documents/current/core/howto/systemd.html), 
ran into trouble where the service failed to start. Wrong permissions, which
the documention doesn't really talk about, were the problem. The service
file they show has the User as nobody and that was not working. I ended up commenting out
the User and Group directive, which is probably the wrong thing to do, but
it allowed the thing to run. Will look into fixing this later.

To go from the example web service to my [distributed responder](https://github.com/johnwlockwood/txnats/blob/master/example/queue_respond.py)
service, I moved the pypy directory to `/usr/local/`, changed the permissions and 
linked the pypy binary to `~/bin/` so I could run pypy without typing 
the full path.

I built a Makefile with the steps I took, so I could easily repeat them 
and build upon this example with less tedium. I hate tedium.

[txnats example distributed responder service](https://github.com/johnwlockwood/txnats/tree/master/example/pi-service) with instructions.

#### Re: upgrading the Pi from wheezy to jessie
This process is somewhat interactive. It stops to ask questions, such as
use the old settings or the new settings... I had begun the upgrade in a tmux
session, so I could disconnect without interupting the process. I had been
checking in with the progress every once and a while this evening and answered
it's queries, but just now, I found the tmux client had been upgraded and was
no longer compatible with the tmux server running my session. The first
solution on SO was to kill all the sessions and start over. Killing a session 
blindly in the middle of an hours long upgrade was not something I wanted.
As SO would have it, more intelligent answers don't always get the vote, but
they're there if you look. [attach](http://unix.stackexchange.com/a/126578)
Back in business. Next time I may just re-image the thing.

-John

#### update: Jan 10:

Reboot the upgraded Pi so `systemd` and other things are properly launched.
I ran into this issue when trying out the instructions from above upon this Pi.
I got `Failed to get D-Bus connection: Unknown error -1` 
when I ran `make add-services`. After a reboot, I tried that last step again
and it worked. I also found a not needed step caused a problem and changed
the [README](https://github.com/johnwlockwood/txnats/blob/master/example/pi-service/README.md) to deal with it.

Now I can unplug one of the two Pis and still have services respond when publishing
messages with [`make_requests.py`](https://github.com/johnwlockwood/txnats/blob/master/example/make_requests.py) 
on my laptop. After plugging it back in, both will start responding again.

