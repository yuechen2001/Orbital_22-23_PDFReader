# PDF Reader
 
## Emulation instructions
### 1. Prerequisites (skip if any step has been completed already)
- Download the repo.
- Install Flutter SDK. 
- Install IDE which can run Flutter SDK.
- run `flutter doctor` in terminal and install all required software.
> If you run into this error "Unable to find suitable Visual Studio toolchain. Please run `flutter doctor` for more details", Visual Studio needs to be installed. <br />
> For detailed instructions on how to install these dependencies, install Visual Studio Community then visit https://stackoverflow.com/questions/60334570/unable-to-find-suitable-visual-studio-toolchain-please-run-flutter-doctor-for <br />
> Note: It is sufficient to install `Desktop Development with C++` and `Universal Windows Platform development` through Visual Studio Installer. 
- Install all required dependencies by running "flutter pub get" (See below):
> Note: Just run the above command to install all the required dependencies for our application. The specified dependencies below are just for reference.
```
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.5
  google_fonts: ^4.0.4
  syncfusion_flutter_pdfviewer: ^21.2.6
  file_picker: ^5.3.1
  intl: ^0.18.1
  get: ^4.6.5
  ```
  
### 2. Running the application on emulator
- Ensure that your file path is set to the location where you downloaded the repository.
- Execute "flutter run" in the terminal.
> If the error "Expected to find project root in current working directory" shows up, right click on the project file and select "open in integrated terminal" and execute the command again.
- Select option 1 (Windows).
- Try out the app!
