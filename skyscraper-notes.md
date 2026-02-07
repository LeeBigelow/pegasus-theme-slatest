# Skyscraper Notes

- Using this maintained fork: [Skyscraper - Gemba fork](https://github.com/Gemba/skyscraper)
- Skyscraper directory contains:
    - my Skyscraper config.ini
        - usefully commented?
        - using retroarch cores
        - linux and android 'launch' entries (android commented out)
    - adjusted artwork.xml to use textures (cartridge/disk/tape images) when generating mixed image screenshots. Also set a fixed gamebox width and preserved aspect (Snes boxart wider than tall. Restricting only height generated too large gameboxes).
    - added "fbneo" and "genesis" systems in peas\_local.json
- Command to fetch data: Skyscraper -p PLATFORM -s SCRAPER
    - eg: Skyscraper -p fbneo -s screenscraper
- Command to generate media and metadata.pegasus.txt files once data is cached: Skyscraper -p PLATFORM
    - eg: Skyscraper -p fbneo
- Better to tweak, or fix, the cache than the generated metadata.pegasus.txt file since tweak will
    be over-written if regenerated
    - Cached info found in: $HOME/.skyscraper/cache/PLATFORM/db.xml
    - fix description errors or typos in the db.xml then regenerate the metadata files.
