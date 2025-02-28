/// RetryQueue class is used to store the data that needs to be retried.
class RetryQueue {
  static final List<Map<String, dynamic>> _queue = [];

  static void addToQueue(Map<String, dynamic> data) {
    _queue.add(data);
  }

  static void processQueue() {
    for (var data in _queue) {
      // ignore: avoid_print
      print(data);
    }

    _queue.clear();
  }
}
