# Pegasus Notes

- "metadata.pegasus.txt" and "theme.cfg" files are in a yaml-ish file format. For vim `:set filetype=yaml` for syntax highlighting
- To show files with no scraped metadata add `skipped="true"` to Skyscraper config.ini or add an "extensions" line to the platforms metadata.pegasus.txt:
    - eg for c64: `extensions: cmd,crt,d64,d71,d80,d81,g64,prg,t64,tap,vsf,x64,zip`
    - If the "metadata.pegasus.txt" is not in the roms directory a "directories" line is needed to provide a file search path:
        - eg for c64: `directories: {env.HOME}/Games/c64`
- In "metadata.pegasus.txt" `launch:` doesn't expand `~` or `$HOME` need to use `{env.HOME}`
    - eg: `launch: retroarch --libretro "{env.HOME}/.config/retroarch/cores/vice_x64sc_libretro.so" "{file.path}"`
- [Installing themes](https://pegasus-frontend.org/docs/user-guide/installing-themes/)
    - On android 11+ no on device access to <storage>/Android/data/org.pegasus\_frontend.android/files/pegasus-frontend/themes/
        - Needed to connect my tablet to my laptop to access the folder and install the themes from my laptop
        - Apparently some android filemanagers can provide access but I had no luck
    - Android doesn't like "css styles" in svg images
        - Needed to convert them to line atrributes using "svgo" and plugin "convertStyleToAttrs"
        - Some svg still had remaining syle/class definitions.
            Had to grep "\<style" and "class=" and manually convert to line attributes

