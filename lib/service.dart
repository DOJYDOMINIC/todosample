// ==================== API SERVICE ====================

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class TodoApiService {
  late final Dio _dio;

  TodoApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
  }

  // GET - Fetch all todos

  Future<List<Todo>> getTodos({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/todos',
        queryParameters: {'_limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch todos',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  // POST - Create a new todo

  Future<Todo> createTodo(Todo todo) async {

    try {
      final response = await _dio.post('/todos', data: todo.toJson());

      if (response.statusCode == 201) {
        return Todo.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create todo',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  // PUT - Update a todo
  Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await _dio.put('/todos/${todo.id}', data: todo.toJson());

      if (response.statusCode == 200) {
        return Todo.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update todo',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  // DELETE - Delete a todo
  Future<void> deleteTodo(int id) async {
    try {
      final response = await _dio.delete('/todos/$id');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete todo',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  // Handle Dio errors
  String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Network error: ${e.message}';
    }
  }
}
