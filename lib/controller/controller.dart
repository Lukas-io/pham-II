import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../model/product_model.dart';

class ProductController {
  final Dio _dio = Dio();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get(
        '$kBaseApiUrl/products',
        queryParameters: {
          'organization_id': kOrganisationId,
          'Appid': kAppId,
          'Apikey': kApikey,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['items'];
        print(data);

        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusMessage}');
      }
    } catch (error) {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception('Connection timeout');
          case DioExceptionType.sendTimeout:
            throw Exception('Send timeout');
          case DioExceptionType.receiveTimeout:
            throw Exception('Receive timeout');
          case DioExceptionType.badResponse:
            throw Exception(
                'Received invalid status code: ${error.response?.statusCode}');
          case DioExceptionType.cancel:
            throw Exception('Request to API server was cancelled');
          case DioExceptionType.unknown:
            throw Exception(
                'Connection to API server failed due to internet connection');
          case DioExceptionType.badCertificate:
            throw Exception(
                'Connection to API server failed due to internet connection');
          case DioExceptionType.connectionError:
            throw Exception(
                'Connection to API server failed due to internet connection');
        }
      } else {
        throw Exception(error);
      }
    }
  }
}
