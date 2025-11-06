
// ==================== CONTROLLER (PROVIDER) ====================

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/service.dart';
import 'package:todo/shared.dart';
import 'model.dart';

class TodoController with ChangeNotifier {
  final TodoApiService _apiService;

  TodoController(this._apiService);

  ScrollController con = ScrollController();

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  var switchObs = false;

  void switchMode() {
      switchObs = !switchObs;
      notifyListeners();
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com', // ✅ replace with your base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// Login API
  Future<void> login({required String username, required String password,}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          "expiresInMins" : 30
        },
      );
      if (response.statusCode == 200) {
        final token = response.data['accessToken'];
        UserPreferences.setToken(token);
        debugPrint('🎟 Token: ${UserPreferences.token}');

      } else {
        debugPrint('⚠️ Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('❌ API Error: ${e.response?.statusCode}');
        debugPrint('🧾 Message: ${e.response?.data}');
      } else {
        debugPrint('🚫 Network Error: ${e.message}');
      }
    } catch (e) {
      debugPrint('💥 Unexpected Error: $e');
    }
  }

  // Fetch todos
  Future<void> fetchTodos() async {
    _setLoading(true);
    _clearError();

    try {
      _todos = await _apiService.getTodos(limit: 10);
      _clearError();
    } on DioException catch (e) {
      _setError(_apiService.handleError(e));
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new todo
  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    _setLoading(true);

    try {

      final newTodo = Todo(title: title);
      final createdTodo = await _apiService.createTodo(newTodo);
      _todos.insert(0, createdTodo);
      _clearError();
    } on DioException catch (e) {
      _setError(_apiService.handleError(e));
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Toggle todo completion
  Future<void> toggleTodo(int index) async {
    final todo = _todos[index];
    final updatedTodo = todo.copyWith(completed: !todo.completed);

    // Optimistic update
    _todos[index] = updatedTodo;
    notifyListeners();

    try {
      await _apiService.updateTodo(updatedTodo);
    } on DioException catch (e) {
      // Revert on failure
      _todos[index] = todo;
      _setError(_apiService.handleError(e));
    } catch (e) {
      _todos[index] = todo;
      _setError('Unexpected error: $e');
    }
  }

  // Delete todo
  Future<void> deleteTodo(int index) async {
    final todo = _todos[index];
    final removedTodo = _todos.removeAt(index);
    notifyListeners();

    try {
      await _apiService.deleteTodo(todo.id!);
    } on DioException catch (e) {
      // Revert on failure
      _todos.insert(index, removedTodo);
      _setError(_apiService.handleError(e));
    } catch (e) {
      _todos.insert(index, removedTodo);
      _setError('Unexpected error: $e');
    }
  }

  // Clear error
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
