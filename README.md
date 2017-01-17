# dump-minecolonies-resources
Dump required resources for a minecolonies structure

# PLEASE NOTE:
  !!! This is written specifically for MineColonies structure nbt files.
  !!! There are no checks for invalid data.
  !!! Use at your own peril!

  Use my version of Minecraft::NBTReader found at
  https://github.com/harleypig/Minecraft-NBTReader

  I've added support for the TAG_Int_Array type and removed a block for nbt
  files that end with two nulls.

## Todos, maybe ...
* Do I need to include the location of the hut block in the output?
* Do I count 'double wooden slabs' as 2 slabs?
