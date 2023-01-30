## Discription

This library utilises Dart internal isolate to handle all your network calls to Api and on top of that it uses Hive database to cache the api responses and will give the response back even when internet is not available.

## Features

- Send request to your api on seperate isolate
- Cached your responses which enables your app to work in offline mode.
- Helps in saving the work load (network requests) from main isolate which helps it to focus mainly on rendering.

## Getting started

To start using this package, add `smooth_api` dependency to your `pubspec.yaml`

```yaml
dependencies:
    smooth_api: "<latest_release>"
```

## Usage

Example `GET` request using `SmoothApi`

```dart
var client = SmoothApiClient();
  await client.get(Uri.http("google.com"),
      headers: {"auth": "fdfdfd", "isTrue": "true"}, callback: (response) {
    print((response as Response).body);
  });
```
## Bugs or Report

If you encounter any problems feel free to open an [issue](https://github.com/AnonymousAliensX/SmoothApi/issues/new?template=bug_report.md) If you feel the library is missing a feature, please raise a [ticket](https://github.com/AnonymousAliensX/SmoothApi/issues/new?template=feature_request.md) on GitHub and I'll look into it. Pull request are also welcome.

# License

category_navigator is licensed under `MIT license`. View [license](https://github.com/AnonymousAliensX/SmoothApi/blob/main/LICENSE).
