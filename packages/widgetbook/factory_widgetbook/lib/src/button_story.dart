import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final WidgetbookComponent buttonStory = WidgetbookComponent(
  name: 'FactoryButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: FactoryButton(
          label: context.knobs.string(label: 'Label', initialValue: 'Click me'),
          onPressed: () {},
          isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => Center(
        child: FactoryButton(
          label: context.knobs.string(label: 'Label', initialValue: 'Save'),
          onPressed: () {},
          icon: Icons.save,
        ),
      ),
    ),
  ],
);
