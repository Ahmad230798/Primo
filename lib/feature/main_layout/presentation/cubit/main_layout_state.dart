class MainLayoutState {
  final int currentIndex;
  final bool isMenuOpen;

  const MainLayoutState({
    this.currentIndex = 4, // الرئيسية هي الافتراضية
    this.isMenuOpen = false,
  });

  MainLayoutState copyWith({int? currentIndex, bool? isMenuOpen}) {
    return MainLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      isMenuOpen: isMenuOpen ?? this.isMenuOpen,
    );
  }
}
