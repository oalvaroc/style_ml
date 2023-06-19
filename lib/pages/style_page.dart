import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:style_ml/bloc/auth_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/models/post.dart';

import '../widgets/styledImage/bloc/styled_image_bloc.dart';
import '../widgets/styledImage/styled_image.dart';

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as StylePageArgs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<StyledImageBloc>(
            create: (context) => StyledImageBloc(source: args.image),
          ),
        ],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: const FittedBox(
                      child: StyledImage(),
                    ),
                  ),
                ),
                StyleList(),
                MixSlider(),
                const ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StyleList extends StatelessWidget {
  StyleList({super.key});

  final _box = Hive.box('style');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyledImageBloc, StyledImageState>(
      buildWhen: (previous, current) {
        return previous.style != current.style;
      },
      builder: (context, state) {
        final bloc = BlocProvider.of<StyledImageBloc>(context);

        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Style',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: StyleNames.values.length,
                      itemBuilder: ((context, index) {
                        final style = StyleNames.values[index];

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Material(
                                child: Ink.image(
                                  image: AssetImage(style.path),
                                  width: 150,
                                  fit: BoxFit.cover,
                                  colorFilter: state.style == style
                                      ? const ColorFilter.mode(
                                          Colors.black38,
                                          BlendMode.darken,
                                        )
                                      : null,
                                  child: InkWell(
                                    onTap: () {
                                      bloc.add(
                                        StyledImageStyleChanged(style),
                                      );
                                      _box.put('style-index', index);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                ),
                                child: state.style == style
                                    ? const Icon(Icons.check)
                                    : null,
                              ),
                            ),
                          ],
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MixSlider extends StatelessWidget {
  MixSlider({super.key});

  final _box = Hive.box('style');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyledImageBloc, StyledImageState>(
      buildWhen: (previous, current) {
        return previous.mixRatio != current.mixRatio;
      },
      builder: (context, state) {
        final bloc = BlocProvider.of<StyledImageBloc>(context);

        if (_box.isNotEmpty) {
          final ratio = _box.get('mix-ratio');
          bloc.add(StyledImageMixRatioChanged(ratio));
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mix Ratio',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Slider(
                  value: state.mixRatio ?? 0,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    bloc.add(StyledImageMixRatioChanged(value));
                    _box.put('mix-ratio', value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyledImageBloc, StyledImageState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<StyledImageBloc>(context);
        final auth = BlocProvider.of<AuthBloc>(context).state as Authenticated;
        final result = state.result;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FilledButton.icon(
              onPressed: () {
                bloc.add(StyledImageRun());
              },
              label: const Text('Run'),
              icon: const Icon(Icons.play_arrow),
            ),
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<PostManagerBloc>(context).add(
                  InsertEvent(
                    post: PostModel(
                      author: auth.user,
                      image: result!,
                      likes: const [],
                    ),
                  ),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post saved'),
                  ),
                );
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save),
            ),
          ],
        );
      },
    );
  }
}

class StylePageArgs {
  StylePageArgs(this.image);

  final img.Image image;
}
