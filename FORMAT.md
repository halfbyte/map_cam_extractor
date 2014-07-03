# The MAP CAM GPS record data format

The AVI files you're finding on the SD card after shooting video with the MAP CAM contain GPS data between video and audio chunks. The GPS chunks don't have a length field (as specified in the RIFF standard), which is a suckage, but they are always exactly 58 bytes long.

Here's what I know about these 58 bytes so far:

All four byte words are little endian, mostly signed, I guess.

1. Bytes 0-3: Counter. I assume it counts video frames, but precision is in seconds, so it counts 30,60,90 etc.
2. Bytes 4-7: Currently unknown. Static value, in my case: 50, 0, 0, 0. I have no idea what that means.
3. Bytes 8-11: Currently unknown. Value suggests that the four bytes have independent meanings, maybe system status?
4. Bytes 12-15: Date. Year: first and second byte, little endian, Month: third byte, Day: fourth byte
5. Bytes 16-19: Time. This is saved in UTC, first byte hour, second byte minute, bytes three and four: milliseconds in minute, little endian. Weirdly, milliseconds are only precise to the second.
6. Bytes 20-23: Latitude. A signed four byte, little endian integer that represents a millionth degree, meaning you have to divide by 1 million to get to the degree value
7. Bytes 24-27: Longitude. Same as lat, of course
8. Bytes 28-31: Altitude. Factor is 10, so divided by ten you get the meters of altitude
9. Bytes 32-35: Speed. This one's a little weird and I'm not sure I have it figured out. Also four byte int little endian, but with a factor of one million I land at "almost" miles per hour. Which is, yes, weird.
10. Bytes 36-39: Currently unknown, could be orientation, but I have not figured out anything.
11. Bytes 40-43: Travelled distance. Factor of 10,000 gives distance in km (so same as altitude, if I think about it)
12. Bytes 44-47: My best guess would be battery voltage, as it seems to drop constantly (with the occasional spike, which is normal for battery voltage)
13. Bytes 48-57: 10 bytes of unknown territory. all constant as far as I can see. Could be software versions and stuff like that.

