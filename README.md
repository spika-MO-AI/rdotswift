# rdotswift

### Define

```swift
public final class ResourceCenter {
    
}

let R = ResourceCenter()
```

### Resource type

```swift
private enum ResourceType {
    case String
    case Bool
    case Color
    case Integer
    case Drawable
}
```

### Format

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <{type} name="{define}">{value}</{type}>
</resources>
```

### Image

| Format | Filename extensions |
| --- | --- |
| Tagged Image File Format (TIFF) | .tiff, .tif |
| Joint Photographic Experts Group (JPEG) | .jpg, .jpeg |
| Graphic Interchange Format (GIF) | .gif |
| Portable Network Graphic (PNG) | .png |
| Windows Bitmap Format (DIB) | .bmp, .BMPf |
| Windows Icon Format | .ico |
| Windows Cursor | .cur |
| X Window System bitmap | .xbm |
****