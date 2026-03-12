class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    final totalTicks = (ticks / 100).ceil();
    return Stream.periodic(
      const Duration(milliseconds: 100),
      (x) => ticks - ((x + 1) * 100),
    ).take(totalTicks);
  }
}
