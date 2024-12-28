import 'package:stroke_master/base/animation/lottie_animation_screen.dart';
import 'package:stroke_master/base/widgets/animations/lottie_animation.dart';

class EmptyContentsAnimationScreen extends LottieAnimationScreen {

  const EmptyContentsAnimationScreen({super.key})
      : super(
    animation: LottieAnimation.empty,
  );
}