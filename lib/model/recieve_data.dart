class RecieveData {
  String url;
  bool downloading;
  int id;
  final String filename;
  final String path;
  final dynamic cancelToken;
  RecieveData({
    required this.url,
    required this.downloading,
    required this.id,
    required this.filename,
    required this.path,
    required this.cancelToken,
  });
}
