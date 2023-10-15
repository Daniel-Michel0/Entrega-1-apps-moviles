import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'acerca_de.dart';

class Task {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> categories;

  Task({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.categories,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskStartDateController = TextEditingController();
  final taskEndDateController = TextEditingController();
  List<String> selectedCategories = [];

  final List<String> categories = ['Codear', 'Comer', 'No estudiar', 'Tampoco estudiar'];

  // Colores correspondientes a cada categoría
  final List<Color> categoryColors = [
    Colors.blue, // Codear
    Colors.green, // Comer
    Colors.orange, // No estudiar
    Colors.red, // Tampoco estudiar
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void deleteAllTasks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Todas las Tareas'),
          content: const Text('¿Estás seguro de que deseas eliminar todas las tareas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                tasks.clear(); // Elimina todas las tareas de la lista
                saveTasks(); // Elimina todas las tareas del almacenamiento local
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
                setState(() {}); // Actualiza la interfaz de usuario para reflejar el cambio
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      tasks = taskList.map((taskData) {
        final parts = taskData.split('|');
        final categories = parts[4].split(', ');
        return Task(
          name: parts[0],
          description: parts[1],
          startDate: DateTime.parse(parts[2]),
          endDate: DateTime.parse(parts[3]),
          categories: categories,
        );
      }).toList();
      setState(() {});
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = tasks.map((task) {
      final categoryString = task.categories.join(', ');
      return "${task.name}|${task.description}|${task.startDate}|${task.endDate}|$categoryString";
    }).toList();
    prefs.setStringList('tasks', taskList);
  }

  void addTask() {
    final name = taskNameController.text;
    final description = taskDescriptionController.text;
    final startDate = taskStartDateController.text;
    final endDate = taskEndDateController.text;
    final categories = selectedCategories.toList();
    debugPrint("name: $name, description: $description, startDate: $startDate, endDate: $endDate, categories: $categories");
    if (name.isNotEmpty && startDate.isNotEmpty && endDate.isNotEmpty && selectedCategories.isNotEmpty) {
      final task = Task(
        name: name,
        description: description,
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
        categories: categories,
      );
      tasks.add(task);
      saveTasks();
      setState(() {
        taskNameController.clear();
        taskDescriptionController.clear();
        taskStartDateController.clear();
        taskEndDateController.clear();
        selectedCategories.clear();
      }); // Cierra el diálogo después de guardar la tarea
    }
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    saveTasks();
    setState(() {});
  }

  Color getCategoryColor(String category) {
    final index = categories.indexOf(category);
    if (index != -1 && index < categoryColors.length) {
      return categoryColors[index];
    } else {
      // Devolver un color predeterminado en caso de error
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Agregar Tarea'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Agregar Tarea'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: taskNameController,
                                  decoration: const InputDecoration(labelText: 'Nombre'),
                                ),
                                TextField(
                                  controller: taskDescriptionController,
                                  decoration: const InputDecoration(labelText: 'Descripción'),
                                ),
                                TextFormField(
                                  controller: taskStartDateController,
                                  decoration: const InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        taskStartDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                                      });
                                    }
                                  },
                                ),
                                TextFormField(
                                  controller: taskEndDateController,
                                  decoration: const InputDecoration(labelText: 'Fecha de Fin (YYYY-MM-DD)'),
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        taskEndDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                                      });
                                    }
                                  },
                                ),
                                Wrap(
                                  spacing: 4,
                                  children: categories.map((category) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedCategories.contains(category)) {
                                            selectedCategories.remove(category);
                                          } else {
                                            selectedCategories.add(category);
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: selectedCategories.contains(category)
                                              ? getCategoryColor(category)
                                              : Colors.grey,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color: selectedCategories.contains(category)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                addTask();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Guardar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar Todas las Tareas'),
              onTap: () {
                Navigator.pop(context);
                deleteAllTasks();
              },
            ),
            ListTile(
              leading: const Icon(Icons.navigate_next),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const acercaDe()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final startDateFormatted = DateFormat('yyyy-MM-dd').format(task.startDate);
          final endDateFormatted = DateFormat('yyyy-MM-dd').format(task.endDate);

          return ListTile(
            title: Text(task.name),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Inicio: $startDateFormatted\nFin: $endDateFormatted'),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(index);
                  },
                ),
              ],
            ),
            leading: Wrap(
              spacing: 4,
              children: task.categories.map((category) {
                final categoryColor = getCategoryColor(category);
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
            onTap: () {
              // Puedes agregar lógica para ver o editar la tarea aquí
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Agregar Tarea'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: taskNameController,
                            decoration: const InputDecoration(labelText: 'Nombre'),
                          ),
                          TextField(
                            controller: taskDescriptionController,
                            decoration: const InputDecoration(labelText: 'Descripción'),
                          ),
                          TextFormField(
                            controller: taskStartDateController,
                            decoration: const InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                            keyboardType: TextInputType.datetime,
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  taskStartDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                                });
                              }
                            },
                          ),
                          TextFormField(
                            controller: taskEndDateController,
                            decoration: const InputDecoration(labelText: 'Fecha de Fin (YYYY-MM-DD)'),
                            keyboardType: TextInputType.datetime,
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  taskEndDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                                });
                              }
                            },
                          ),
                          Wrap(
                            spacing: 4,
                            children: categories.map((category) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedCategories.contains(category)) {
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: selectedCategories.contains(category)
                                        ? getCategoryColor(category)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: selectedCategories.contains(category)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          addTask();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Guardar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
