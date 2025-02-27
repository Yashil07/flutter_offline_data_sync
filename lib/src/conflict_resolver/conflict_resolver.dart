class ConflictResolver {
  /// Handles conflicts between local and server data
  static Map<String, dynamic> resolveConflict(
      Map<String, dynamic> localData, Map<String, dynamic> serverData) {
    // Example conflict resolution: Keep the latest updated data
    if (localData['updated_at'] != null && serverData['updated_at'] != null) {
      DateTime localTime = DateTime.parse(localData['updated_at']);
      DateTime serverTime = DateTime.parse(serverData['updated_at']);

      return localTime.isAfter(serverTime) ? localData : serverData;
    }

    // Default: Merge data (you can customize this)
    return {...serverData, ...localData};
  }
}
