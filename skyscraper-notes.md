# Skyscraper Notes

- Using this maintained fork: [Skyscraper - Gemba fork](https://github.com/Gemba/skyscraper)
- Skyscraper directory contains:
    - my Skyscraper config.ini
        - my games are in: ~/Games
        - using retroarch cores
        - linux and android 'launch' entries (android commented out)
    - adjusted artwork.xml to use textures (cartridge/disk/tape images) when generating mixed image screenshots
    - added "fbneo" and "genesis" systems in peas\_local.json
- Command to fetch data: Skyscraper -p PLATFORM -s SCRAPER
    - eg: Skyscraper -p fbneo -s screenscraper
- Command to make metadata.pegasus.txt files once data is cached: Skyscraper -p PLATFORM
    - eg: Skyscraper -p fbneo

