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
Size (xyz): 15x9x13
----------------------------------------

      cobblestone: 11
             dirt: 63
            fence: 42
          oak log:  3
       oak planks: 13
  oak wooden slab: 32
            torch: 12
```

I've added a directory that contains the output of all nbt files in the schematics directory. Look in 'resources.list'.

## Todos, maybe ...
* Do I need to include the location of the hut block in the output?
* Do I count 'double wooden slabs' as 2 slabs?
