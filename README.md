# Color Script List
Color-codes the script list in Godot's script editor by folder.

## Features

- **Automatic colors:** script automatically get their own color.
- **Custom colors**: you can optionally manually set custom colors.

## Customization

To manually override a folder color, edit 'FOLDER_OVERRIDES' in 'plugin.gd':

```gdscript
const FOLDER_OVERRIDES := {
    "res://player": Color.BLUE,
    "res://scripts/debug": Color.GREEN,
    ...
```

## Notes

- Renaming or adding folders may change color unless overridden.
- Tested and written for Godot 4.7.2.stable

## License

CC0 - Feel free to use and modify this plugin, no credit needed!
