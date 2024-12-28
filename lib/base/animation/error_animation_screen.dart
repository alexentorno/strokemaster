import 'package:stroke_master/base/animation/lottie_animation_screen.dart';
import 'package:stroke_master/base/widgets/animations/lottie_animation.dart';

class ErrorAnimationScreen extends LottieAnimationScreen {

  const ErrorAnimationScreen({super.key})
      : super(
    animation: LottieAnimation.error,
  );
}