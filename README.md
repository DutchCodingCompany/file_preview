# file_preview

Can generate an preview image based on the file extension. Uses the native files previewer on iOS.

## Getting Started

Generate a preview Widget by calling `await FilePreview.getThumbnail(file.path)`.

* An image file
<img src="images/screenshot1.png">

* A pdf file
<img src="images/screenshot2.png">

* A pdf file where a preview cannot be rendered
<img src="images/screenshot3.png">

## Usage

```dart
final File file = await FilePicker.getFile();
try {
    final thumbnail = await FilePreview.getThumbnail(file.path);
    setState(() {
        image = thumbnail;
    });
} catch (e) {
    image = Image.asset("");
}
```