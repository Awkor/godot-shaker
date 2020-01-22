# godot-shaker

This plugin adds a `Shaker` node that will modify the target's position and rotation to achieve a _shaking_ effect.

## How to use

1. Add the node to the scene tree.
2. Select which node will the `Shaker` shake through the `Node Path` variable. # redo
3. Adjust the rest of the exported variables to your heart's desire.
4. Call the [add_trauma()](https://github.com/Awkor/godot-shaker/blob/master/addons/shaker/source/ShakerNode.gd#L89) function to shake things up.

## How does it work

The main logic comes from the first half of this [talk](https://www.youtube.com/watch?v=tu-Qe66AvtY), so if you want to understand how it works, I recommend you to check out that link.

## Little caveats

Currently, if you want to change the position or rotation of the `Shaker`'s target while it's shaking, you'll need to update the `original_position` (or `original_rotation`, depending on what property you modify) so that the `Shaker` doesn't reset the property to an erroneous value.
