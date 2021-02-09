# godot-shaker

This plugin adds a `Shaker` node that will modify the target's position and rotation to achieve a _shaking_ effect.

## Credits

The core logic comes from [this talk](https://www.youtube.com/watch?v=tu-Qe66AvtY) given by Squirrel Eiserloh at GDC.

If you want to understand how it works, I recommend you to check it out.

## How to use it

1. Add the node to the scene tree.
2. Select which node will the `Shaker` shake through the `Node Path` variable.
3. Adjust the rest of the exported variables to your heart's desire.
4. Call the [add_trauma()](https://github.com/Awkor/godot-shaker/blob/master/addons/shaker/source/ShakerNode.gd#L94) function to shake things up.

## Little caveats

Currently, if you want to change the position or rotation of the `Shaker`'s target while it's shaking, you'll need to update the `original_position` (or `original_rotation`, depending on what property you modify) so that the `Shaker` doesn't reset the property to an erroneous value.

Another way to work around this limitation is to add a node to the `Shaker`'s target as a parent. When you want move the targeted node, instead of modifing `original_position` (or `original_rotation`), you could simply move the newly added node instead.

So you would change this:

```
Root
├───Shaker
└───Target
```

To this:

```
Root
├───Shaker
└───Node
    └───Target
```
