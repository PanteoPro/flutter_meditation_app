import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/logic/cubit/music_cubit.dart';
import 'package:meditation_controll/resources/resources.dart';
import 'package:provider/src/provider.dart';

class MusicViewWidget extends StatelessWidget {
  const MusicViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const _CurrentMusicWidget(),
        const SizedBox(height: 15),
        BlocBuilder<MusicCubit, MusicState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionItem(
                  image: AppImagesIcons.unmute,
                  isBorder: !state.isMusicMuted,
                  onPressed: () => context.read<MusicCubit>().onUnmute(),
                ),
                _ActionItem(
                  image: AppImagesIcons.mute,
                  isBorder: state.isMusicMuted,
                  onPressed: () => context.read<MusicCubit>().onMute(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CurrentMusicWidget extends StatelessWidget {
  const _CurrentMusicWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width * 0.7 - 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.main, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text('Исполнитель - трекаd sad ', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({Key? key, required this.image, this.isBorder = false, required this.onPressed}) : super(key: key);

  final String image;
  final bool isBorder;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: isBorder ? AppColors.main : Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
