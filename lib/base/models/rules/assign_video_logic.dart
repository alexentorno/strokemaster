String assignDifficulty(String title) { //Beginner, Advanced, Professional
  final lowerTitle = title.toLowerCase();
  if (lowerTitle.contains('intro')
      || lowerTitle.contains('5 min')
      || lowerTitle.contains('6 min')
      || lowerTitle.contains('pause')
      || lowerTitle.contains('crossover')
      || lowerTitle.contains('see-saw')
      || lowerTitle.contains('twists')
      || lowerTitle.contains('one sided')
      || lowerTitle.contains('easy')) {
    return 'Beginner';
  } else if (lowerTitle.contains('paper, scissors, rock')
      || lowerTitle.contains('8 min')
      || lowerTitle.contains('10 min')
      || lowerTitle.contains('hand paddling')
      || lowerTitle.contains('paddle')
      || lowerTitle.contains('ear touch')
      || lowerTitle.contains('robot')
      || lowerTitle.contains('lunge')
      || lowerTitle.contains('technique')) {
    return 'Advanced';
  } else if (lowerTitle.contains('pass the paddle')
      || lowerTitle.contains('head, shoulders, knees')
      || lowerTitle.contains('sculling')
      || lowerTitle.contains('pro')) {
    return 'Professional';
  }
  return 'Advanced'; // Default level if no keywords match
}

String assignWhere(String title) {
  final lowerTitle = title.toLowerCase();
  if (lowerTitle.contains('paddler technique') || lowerTitle.contains('paddler balance')) {
    return 'On Water';
  } else if (lowerTitle.contains('warm up')) {
    return 'Warm up';
  }
  return 'Gym'; // Default if no keywords match
}
