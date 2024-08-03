class TransferData {
  final String filename;
  final String path;
  final int count;
  final int total;
  final bool completed;
  final bool failed;
  final bool receiving;
  final int id;
  final dynamic cancelToken;
  TransferData({
    required this.filename,
    required this.path,
    required this.count,
    required this.total,
    required this.completed,
    required this.failed,
    required this.receiving,
    required this.id,
    required this.cancelToken,
  });
}