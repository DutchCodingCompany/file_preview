# file_previewer

Can generate an preview image based on the file extension. Uses the native files previewer on iOS.

## Getting Started

Generate a preview Widget by calling `await FilePreview.getThumbnail(file.path)`.

* An image file

<img src="https://raw.githubusercontent.com/DutchCodingCompany/file_preview/7d8f6ce6ddd27befc4506c077592ff55d56c63e6/images/screenshot1.png" height="800">

* A pdf file

<img src="https://raw.githubusercontent.com/DutchCodingCompany/file_preview/7d8f6ce6ddd27befc4506c077592ff55d56c63e6/images/screenshot2.png" height="800">

* A pdf file where a preview cannot be rendered

<img src="https://raw.githubusercontent.com/DutchCodingCompany/file_preview/7d8f6ce6ddd27befc4506c077592ff55d56c63e6/images/screenshot3.png" height="800">

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