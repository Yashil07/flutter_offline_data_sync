class RetryQueue {
  static final List<Map<String, dynamic>> _queue = [];

  static void addToQueue(Map<String, dynamic> data) {
    _queue.add(data);
  }

  static void processQueue() {
    _queue.forEach((data) {
      // Send data to the server (Implement API call)
    });
    _queue.clear();
  }
}