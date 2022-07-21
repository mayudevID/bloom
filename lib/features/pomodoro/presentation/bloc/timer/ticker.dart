class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
            const Duration(milliseconds: 100), (x) => ticks - (x * 100) - 100)
        .take(ticks);
  }
}
