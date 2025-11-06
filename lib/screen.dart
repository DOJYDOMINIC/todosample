// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'controller.dart';
//
// class TodoHomePage extends StatefulWidget {
//   const TodoHomePage({super.key});
//
//   @override
//   State<TodoHomePage> createState() => _TodoHomePageState();
// }
//
// class _TodoHomePageState extends State<TodoHomePage> {
//
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => context.read<TodoController>().fetchTodos());
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _addTodo() {
//     if (_controller.text.trim().isNotEmpty) {
//       context.read<TodoController>().addTodo(_controller.text);
//       _controller.clear();
//       FocusScope.of(context).unfocus();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Todo App'),
//         elevation: 2,
//         leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => context.read<TodoController>().fetchTodos(),
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: Consumer<TodoController>(
//         builder: (context, controller, child) {
//           if (controller.isLoading && controller.todos.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return Column(
//             children: [
//               // Error message
//               if (controller.error != null)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   color: Colors.red.shade100,
//                   child: Row(
//                     children: [
//                       Icon(Icons.error, color: Colors.red.shade700),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           controller.error!,
//                           style: TextStyle(color: Colors.red.shade700),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, size: 20),
//                         color: Colors.red.shade700,
//                         onPressed: () => controller.clearError(),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               // Add todo input
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _controller,
//                         decoration: const InputDecoration(
//                           hintText: 'Enter a new todo',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                         onSubmitted: (_) => _addTodo(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: controller.isLoading ? null : _addTodo,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.all(16),
//                       ),
//                       child: controller.isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             )
//                           : const Icon(Icons.add),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Todo list
//               Expanded(
//                 child: controller.todos.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         controller: controller.con,
//                         itemCount: controller.todos.length,
//                         itemBuilder: (context, index) {
//                           final todo = controller.todos[index];
//
//                           return Card(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 4,
//                             ),
//                             child: ListTile(
//                               leading: Checkbox(
//                                 value: todo.completed,
//                                 onChanged: (_) => controller.toggleTodo(index),
//                               ),
//                               title: Text(
//                                 todo.title,
//                                 style: TextStyle(
//                                   decoration: todo.completed
//                                       ? TextDecoration.lineThrough
//                                       : null,
//                                   color: todo.completed
//                                       ? Colors.grey
//                                       : Colors.black,
//                                 ),
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 color: Colors.red,
//                                 onPressed: () => controller.deleteTodo(index),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TodoController>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 16,
              children: [
                if(!provider.switchObs)
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (va) {
                    if (va!.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: password,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: provider.switchObs,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.switchMode();
                      },
                      icon: Icon(
                        provider.switchObs ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    if (username.text.isNotEmpty && password.text.isNotEmpty) {
                      provider.login(
                        username: username.text.trim(),
                        password: password.text.trim(),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
