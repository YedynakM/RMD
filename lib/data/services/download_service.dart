import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();
  
  final String _baseUrl = 'http://10.0.2.2:5000/download'; 

  Future<String?> downloadTrack(String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$filename';

      final encodedFilename = Uri.encodeComponent(filename);
      final url = '$_baseUrl/$encodedFilename';

      print('[Dio] Починаю запит: $url');

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Завантаження: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      print('Файл збережено: $savePath');
      return savePath;
      
    } on DioException catch (e) {
      print('Помилка Dio: ${e.message}');
      if (e.response != null) {
        print('Статус сервера: ${e.response?.statusCode}');
        print(' Відповідь сервера: ${e.response?.data}');
      } else {
        print('Сервер не відповідає (можливо, блокування http або неправильний IP)');
      }
      return null;
    } catch (e) {
      print('Невідома помилка: $e');
      return null;
    }
  }
}