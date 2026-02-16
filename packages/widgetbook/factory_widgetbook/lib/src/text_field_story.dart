import 'package:factory_ui/factory_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final WidgetbookComponent textFieldStory = WidgetbookComponent(
  name: 'FactoryTextField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(FactorySpacing.md),
        child: FactoryTextField(
          label: context.knobs.string(label: 'Label', initialValue: 'Email'),
          hint: context.knobs.string(label: 'Hint', initialValue: 'you@example.com'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Error',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(FactorySpacing.md),
        child: FactoryTextField(
          label: 'Email',
          hint: 'you@example.com',
          errorText: context.knobs.string(
            label: 'Error text',
            initialValue: 'Invalid email address',
          ),
        ),
      ),
    ),
  ],
);
