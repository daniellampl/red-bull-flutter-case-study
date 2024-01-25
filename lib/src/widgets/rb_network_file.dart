import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_icons.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_spinner.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_typography.dart';
import 'package:video_player/video_player.dart';

const _kFadeInCurve = Curves.ease;
const _kFadeInDuration = Duration(milliseconds: 300);
const _kFadeOutCurve = Curves.easeOut;
const _kFadeOutDuration = Duration(milliseconds: 300);

class RbNetworkImage extends StatelessWidget {
  const RbNetworkImage({
    required this.url,
    super.key,
  });

  final Uri url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInCurve: _kFadeInCurve,
      fadeInDuration: _kFadeInDuration,
      fadeOutCurve: _kFadeOutCurve,
      fadeOutDuration: _kFadeOutDuration,
      fit: BoxFit.cover,
      imageUrl: url.toString(),
      errorWidget: (_, value, __) => _Error(message: value),
      placeholder: (_, __) => ColoredBox(
        color: RbColors.of(context).fillsTertiary,
      ),
    );
  }
}

class RbNetworkVideo extends StatefulWidget {
  const RbNetworkVideo({
    required this.url,
    super.key,
  });

  final Uri url;

  @override
  State<RbNetworkVideo> createState() => _RbNetworkVideoState();
}

class _RbNetworkVideoState extends State<RbNetworkVideo> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(widget.url);
    _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (_, value, __) {
        return AnimatedSwitcher(
          duration: _kFadeInDuration,
          switchInCurve: _kFadeInCurve,
          reverseDuration: _kFadeOutDuration,
          switchOutCurve: _kFadeOutCurve,
          child: Stack(
            children: [
              if (value.hasError)
                _Error(
                  message: value.errorDescription ??
                      context.l10n.file_details_video_error_unknown,
                )
              else if (!value.isInitialized && value.buffered.isEmpty)
                const _VideoLoading()
              else ...[
                VideoPlayer(_controller),
                if (!value.isPlaying)
                  GestureDetector(
                    onTap: _controller.play,
                    child: const _PlayVideoOverlay(),
                  )
              ]
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _VideoLoading extends StatelessWidget {
  const _VideoLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RbColors.of(context).fillsTertiary,
      child: const Center(
        child: RbSpinner(),
      ),
    );
  }
}

class _PlayVideoOverlay extends StatelessWidget {
  const _PlayVideoOverlay();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0x40000000),
      child: Center(
        child: Icon(
          RbIcons.playOutlined,
          color: Color(0xFFFFFFFF),
          size: 46,
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RbColors.of(context).fillsTertiary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            message,
            style: textSmallOf(context),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
