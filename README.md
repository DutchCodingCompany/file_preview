# flutter_file_preview

Can generate an preview image based on the file extension. Uses the native files previewer on iOS.

## Getting Started

Generate a preview Widget by calling `await FilePreview.getThumbnail(file.path)`.

* An image file

<img src="images/screenshot1.png" height="800">

* A pdf file

<img src="images/screenshot2.png" height="800">

* A pdf file where a preview cannot be rendered

<img src="images/screenshot3.png" height="800">

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