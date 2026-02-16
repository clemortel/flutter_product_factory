import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final WidgetbookComponent cardStory = WidgetbookComponent(
  name: 'FactoryCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(FactorySpacing.md),
        child: FactoryCard(
          child: Text(
            context.knobs.string(
              label: 'Content',
              initialValue: 'This is a card',
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Tappable',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(FactorySpacing.md),
        child: FactoryCard(
          onTap: () {},
          child: const Text('Tap me'),
        ),
      ),
    ),
  ],
);
