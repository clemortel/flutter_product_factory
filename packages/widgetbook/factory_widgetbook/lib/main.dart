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
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.android.samsungGalaxyS20,
          ],
        ),
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
