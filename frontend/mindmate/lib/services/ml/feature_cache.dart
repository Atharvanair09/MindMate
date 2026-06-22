class FeatureCache {
  bool _isDirty = true;

  bool get isDirty => _isDirty;

  void markDirty() {
    _isDirty = true;
  }

  void markClean() {
    _isDirty = false;
  }
}
