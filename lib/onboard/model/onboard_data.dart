class OnBoarding {
  final String title;
  final String image;

  OnBoarding({
    required this.title,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Welcome to\n your manzil',
    image: 'assets/images/onboarding_image_1.png',
  ),
  OnBoarding(
    title: 'Create new booking easily',
    image: 'assets/images/onboarding_image_2.png',
  ),
  OnBoarding(
    title: 'Keep track of your booking',
    image: 'assets/images/onboarding_image_3.png',
  ),
  OnBoarding(
    title: 'Help us on creating travel easy',
    image: 'assets/images/onboarding_image_4.png',
  ),
];
