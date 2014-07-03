# GPS data extraction for MAP-CAM videos

I've recently bought a bike camera on the cheap at your favourite online warehouse, it's a ["Hyundai MAP CAM"](http://www.my-hyundai.de/map-cam.html) and I've bought it mainly because it was very cheap and also because it's also saving GPS data which I find fascinating.

The problem of course beeing that the only way of looking at the videos with map data is the bundled, Windows only software.

With a few evenings of work, I was able to at least decode the most important parts of the GPS records in the AVI files the camera saves. My findings are documented in the [format description](FORMAT.md).

## Requirements

A standard Ruby 1.9+ installation.

## Usage

    $ ruby extract.rb <video_file.AVI> <csv_file.csv>

You can now use the resulting CSV file which contains data for all known and unknown data fiels in the GPS records.

As the GPS records in the video files contain full duplicates, I've build a simple deduplicator that throws away lines that are 100% duplicates.


## BEWARE


This is alpha software and provided AS IS under the MIT license. See [LICENSE](LICENSE.md) for details.

