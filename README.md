# Mobile FinAI Nusantara

[add description here]

## Getting Started

### Local Environment

    - Flutter version 3.27.3 

Use FVM for better flutter sdk management :
[FVM (Flutter Version Management) : Manage multiple Flutter SDK versions](https://fvm.app/)

## Project Structure

```
finai_frontend/
├── lib/
│ ├── app/                      --> Application Layer
│ │ ├── data/                   --> Data Layer
│ │ │ ├── data_sources/         --> External data sources (API)
│ │ │ ├── models/               --> Data models
│ │ │ └── repositories/         --> Repository implementations
│ │ ├── domain/                 --> Domain Layer
│ │ │ ├── entities/             --> Business entities
│ │ │ ├── repositories/         --> Repository interfaces
│ │ │ └── use_cases/            --> Business logic use cases
│ │ └── presentation/           --> Presentation Layer
│ │ ├── cubit/                  --> State management (Cubit)
│ │ ├── pages/                  --> UI pages/screens
│ │ └── widgets/                --> Reusable UI components
│ ├── core/                     --> Core/Shared Layer
│ │ ├── config/                 --> App configuration
│ │ ├── database/               --> Database utilities
│ │ ├── exceptions/             --> Custom exceptions
│ │ ├── helper/                 --> Helper utilities
│ │ ├── services/               --> Core services
│ │ ├── static_data/            --> Static data
│ │ ├── translator/             --> Localizations
│ │ ├── use_cases/              --> Base use case classes
│ │ └── util/                   --> Utility classes
│ └── main.dart                 --> App entry point
├── assets/                     --> Static assets
├── fonts/                      --> Custom fonts
└── pubspec.yaml                --> Dependencies configuration
```

## Architecture Overview

### Clean Architecture

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer** (`app/presentation/`)
   - Contains UI components, pages, and state management
   - Uses BLoC / Cubit pattern for state management
   - Handles user interactions and displays data

2. **Domain Layer** (`app/domain/`)
   - Contains business logic and rules
   - Defines entities, repository interfaces, and use cases
   - Independent of external frameworks and libraries

3. **Data Layer** (`app/data/`)
   - Implements repository interfaces from domain layer
   - Handles data sources (API, local database)
   - Contains data models and data source implementations

### Dependency Injection

The project uses **GetIt** and **Injectable** for dependency injection:

- **GetIt**: Service locator for dependency injection
- **Injectable**: Code generation for automatic dependency registration

## Usages

### Translator

    Translator use .arb file in core/translator/arb, after edit using plugin "i18n arb editor",
    the translator will be generate automaticly from plugin "Flutter Intl". These plugin you 
    can download on VS Code. After download these plugin, you can edit translator by right click
    in core/translator/arb folder then click "i18n arb editor" to show page translator, after 
    page translator showed you can add new item and click save. If plugin not generated after 
    save, you should save manually (Ctrl + S) on core/translator/arb/int_en.arb file.
    
    If translator not generate automaticly, you can manually run this command :
    ```dart    
    flutter pub run intl_utils:generate
    ```

##### i18n arb editor 

[VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=innwin.i18n-arb-editor)

##### Flutter Intl 

[VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl)

### Asset Images

    Image save in assets folder will be generate automatic in core/util/assets.dart file, 
    in that file dont edit manually, but you can use plugin "Flutter Assets Gen" from VSCode. 
    After donwload plugin, you can add assets image in assets/images, after that "Ctrl+Shift+P" 
    to show option on VSCode then select "Flutter Assets : Generate" to generate path image 
    on core/util/assets.dart file

##### Flutter Assets Gen 

[VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=weekit.flutter-assets-gen2)

### Build runner

    This project using build_runner for automatic dependency registration, after you create 
    feature with impelements injectable **@lazySingleton** in usecase (lib/app/domain/use_cases), 
    domain repositories (lib/app/domain/repositories), data repositories (lib/app/data/repositories)
    and service datasource (lib/app/data/data_sources), you can run this command in terminal 

```dart    
flutter pub run build_runner build --delete-conflicting-outputs
```


