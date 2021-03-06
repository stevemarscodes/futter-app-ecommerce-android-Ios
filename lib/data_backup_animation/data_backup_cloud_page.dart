import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:australti_ecommerce_app/data_backup_animation/data_backup_home.dart';

import 'package:provider/provider.dart';

class _Bubble {
  _Bubble({
    this.color,
    this.direction,
    this.speed,
    this.size,
    this.initialPosition,
  });
  final Color color;
  final double direction;
  final double speed;
  final double size;
  final double initialPosition;
}

class DataBackupCloudPage extends StatelessWidget {
  DataBackupCloudPage({
    Key key,
    this.progressAnimation,
    this.cloudOutAnimation,
    this.bubblesAnimation,
  }) : super(key: key);

  final Animation<double> progressAnimation;
  final Animation<double> cloudOutAnimation;
  final Animation<double> bubblesAnimation;
  final bubbles = List<_Bubble>.generate(300, (index) {
    final size = math.Random().nextInt(20) + 5.0;
    final speed = math.Random().nextInt(50) + 1.0;
    final directionRandom = math.Random().nextBool();
    final colorRandom = math.Random().nextBool();
    final direction =
        math.Random().nextInt(500) * (directionRandom ? 1.0 : -1.0);
    final color = colorRandom
        ? mainDataBackupColor
        : secondaryDataBackupColor.withOpacity(0.50);

    return _Bubble(
      color: color,
      direction: direction,
      speed: speed,
      size: size,
      initialPosition: index * 10.0,
    );
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final queryData = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: Listenable.merge(
          [
            progressAnimation,
            cloudOutAnimation,
          ],
        ),
        builder: (context, snapshot) {
          final size = queryData.width * 0.5;
          final circleSize = size *
              math.pow(
                  (progressAnimation.value + cloudOutAnimation.value + 1), 2);
          final topPosition = queryData.height * 0.0;
          final centerMargin = queryData.width - circleSize;
          final leftSize =
              size * 0.0 * math.pow((1 - progressAnimation.value), 3);
          final rightSize =
              size * 0.0 * math.pow((1 - progressAnimation.value), 3);
          final leftMargin = queryData.width / 2 - leftSize * 1.2;
          final rightMargin = queryData.width / 2 - rightSize * 1.2;
          final middleMargin = queryData.width / 2 -
              (size / 2) * math.pow((1 - progressAnimation.value), 3);
          final topOutPosition = queryData.height * cloudOutAnimation.value;
          final bottomMiddleSize =
              size * math.pow((1 - progressAnimation.value), 3);

          return Positioned(
            left: 0,
            right: 0,
            top: topPosition - circleSize + topOutPosition,
            height: circleSize,
            child: Stack(
              children: [
                Positioned(
                  height: leftSize / 2,
                  width: bottomMiddleSize,
                  left: middleMargin,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentTheme.scaffoldBackgroundColor),
                  ),
                ),
                Positioned(
                  height: leftSize,
                  width: leftSize,
                  left: leftMargin,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentTheme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  height: rightSize,
                  width: rightSize,
                  right: rightMargin,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentTheme.scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  height: circleSize,
                  width: circleSize,
                  bottom: 0,
                  left: centerMargin / 2,
                  child: ClipOval(
                    child: CustomPaint(
                      foregroundPainter: _CloudBubblePainter(
                        bubblesAnimation,
                        bubbles,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentTheme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _CloudBubblePainter extends CustomPainter {
  _CloudBubblePainter(
    this.animation,
    this.bubbles,
  ) : super(repaint: animation);

  final Animation<double> animation;
  final List<_Bubble> bubbles;

  @override
  void paint(Canvas canvas, Size size) {
    for (_Bubble _bubble in bubbles) {
      final offset = Offset(
        size.width / 2 + _bubble.direction * animation.value,
        size.height * 1.2 * (1 - animation.value) -
            _bubble.speed * animation.value +
            _bubble.initialPosition * (1 - animation.value),
      );

      canvas.drawCircle(offset, _bubble.size, Paint()..color = _bubble.color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
