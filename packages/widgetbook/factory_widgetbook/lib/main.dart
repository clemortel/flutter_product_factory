import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'src/button_story.dart';
import 'src/card_story.dart';
import 'src/text_field_story.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: FactoryTheme.light()),
            WidgetbookTheme(name: 'Dark', data: FactoryTheme.dark()),
          ],
        ),
        ViewportAddon([
          const ViewportData(
            name: 'iPhone 13',
            width: 390,
            height: 844,
            pixelRatio: 3,
            platform: TargetPlatform.iOS,
          ),
          const ViewportData(
            name: 'Samsung Galaxy S20',
            width: 360,
            height: 800,
            pixelRatio: 3,
            platform: TargetPlatform.android,
          ),
        ]),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Widgets',
          children: [
            buttonStory,
            textFieldStory,
            cardStory,
          ],
        ),
      ],
    );
  }
}
