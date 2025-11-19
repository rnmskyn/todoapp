
class Settings {
  final bool isDarkMode;
  final bool asksForDeletionConfirmation;
  const Settings({required this.isDarkMode, required this.asksForDeletionConfirmation});

  Settings copyWith({
    bool? isDarkMode,
    bool? asksForDeletionConfirmation,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      asksForDeletionConfirmation: asksForDeletionConfirmation ?? this.asksForDeletionConfirmation,
    );
  }

  Settings toggleDarkMode() {
    return copyWith(isDarkMode: !isDarkMode);
  }

  Settings toggleDeletionConfirmation() {
    return copyWith(asksForDeletionConfirmation: !asksForDeletionConfirmation);
  }
}
