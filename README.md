# dump-minecolonies-resources
Dump required resources for a minecolonies structure

# PLEASE NOTE:

  !!! This is written specifically for MineColonies structure nbt files.<br />
  !!! There are no checks for invalid data.<br />
  !!! Use at your own peril!

  Use my version of Minecraft::NBTReader found at
  https://github.com/harleypig/Minecraft-NBTReader

  I've added support for the TAG_Int_Array type and removed a block for nbt
  files that end with two nulls.

# Install
Nothing to install, except as noted above.

# Use
Unzip the jar file somewhere and then run `dump-resources` like so:

    dump-resources /pathto/unzipped/jarfile/assets/minecolonies/schematics/stone/Builder1.nbt

and you'll see something like this

```
stone Builder1

  Size (xyz): 15 x  8 x 13

----------------------------------------

             cobblestone: 24
  cobblestone stone slab: 32
        cobblestone wall: 42
                    dirt: 63
                 oak log:  3
                   torch: 12

```

I've added a directory that contains the output of all nbt files in the schematics directory. Look in 'resources.list'.

## Todos, when I get tuits ...
* Send output to a file instead of stdout.
* Add an option to print cumulative resources for a building if it has levels.

## Todos, maybe ...
* Do I need to include the location of the hut block in the output?
