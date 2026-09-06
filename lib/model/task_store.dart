import 'package:flutter/foundation.dart';



class TaskItem {
  final String id;

  // مش final عشان نقدر نعمل Edit للـ task
  String title;

  bool completed;

  TaskItem({
    required this.id,
    required this.title,
    this.completed = false,
  });
}

class TaskStore  {
  // ==========================================================
  // TASKS PER ROOM
  // ==========================================================

  // كل Room ليها List Tasks خاصة بيها
  static final Map<String, List<TaskItem>> _roomTasks = {};

  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static void _notify() {
    version.value++;
  }

  // ==========================================================
  // CURRENT ROOM
  // ==========================================================

  static String? currentRoom;

  // ==========================================================
  // CURRENT TASK PER ROOM
  // ==========================================================

  static final Map<String, String?> _currentTaskByRoom = {};

  // ==========================================================
  // CURRENT ROOM TASKS
  // ==========================================================

  static List<TaskItem> get currentRoomTasks {
    if (currentRoom == null) {
      return [];
    }

    return _roomTasks.putIfAbsent(
      currentRoom!,
          () => [],
    );
  }

  // ==========================================================
  // CURRENT TASK
  // ==========================================================

  static String? get currentTask {
    if (currentRoom == null) {
      return null;
    }

    return _currentTaskByRoom[currentRoom!];
  }

  // ==========================================================
  // SET CURRENT TASK
  // ==========================================================

  static void setTask(String task) {
    final cleanTask = task.trim();

    if (cleanTask.isEmpty || currentRoom == null) {
      return;
    }

    final roomTasks = currentRoomTasks;

    _currentTaskByRoom[currentRoom!] = cleanTask;

    // Don't add the same active task twice
    final existingIndex = roomTasks.indexWhere(
          (item) =>
      item.title == cleanTask &&
          !item.completed,
    );

    if (existingIndex == -1) {
      roomTasks.add(
        TaskItem(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          title: cleanTask,
          completed: false,
        ),
      );
    }
  }

  // ==========================================================
  // ADD TASK
  // ==========================================================

  static TaskItem? addTask(String task) {
    final cleanTask = task.trim();

    if (cleanTask.isEmpty || currentRoom == null) {
      return null;
    }

    final newTask = TaskItem(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: cleanTask,
      completed: false,
    );

    currentRoomTasks.add(newTask);
    _notify();

    return newTask;
  }

  // ==========================================================
  // EDIT TASK
  // ==========================================================

  static bool editTask(
      String id,
      String newTitle,
      ) {
    if (currentRoom == null) {
      return false;
    }

    final cleanTitle = newTitle.trim();

    if (cleanTitle.isEmpty) {
      return false;
    }

    final roomTasks = currentRoomTasks;

    // --------------------------------------------------------
    // Check if another task already has the same name
    // --------------------------------------------------------

    final duplicateExists = roomTasks.any(
          (item) =>
      item.id != id &&
          item.title.toLowerCase() ==
              cleanTitle.toLowerCase(),
    );

    if (duplicateExists) {
      return false;
    }

    // --------------------------------------------------------
    // Find task
    // --------------------------------------------------------

    final index = roomTasks.indexWhere(
          (item) => item.id == id,
    );

    if (index == -1) {
      return false;
    }

    final oldTitle = roomTasks[index].title;

    // --------------------------------------------------------
    // Update title
    // --------------------------------------------------------

    roomTasks[index].title = cleanTitle;

    // --------------------------------------------------------
    // If this was the current task,
    // update current task name too
    // --------------------------------------------------------

    if (_currentTaskByRoom[currentRoom!] == oldTitle) {
      _currentTaskByRoom[currentRoom!] = cleanTitle;
    }
    _notify();

    return true;
  }

  // ==========================================================
  // COMPLETE TASK
  // ==========================================================

  static void completeTask([String? id]) {
    if (currentRoom == null) return;

    final roomTasks = currentRoomTasks;

    if (roomTasks.isEmpty) return;

    if (id == null) {
      final task = currentTask;

      if (task == null) return;

      final index = roomTasks.indexWhere(
            (item) => item.title == task,
      );

      if (index != -1) {
        roomTasks[index].completed = true;
        _notify();
      }

      return;
    }

    final index = roomTasks.indexWhere(
          (item) => item.id == id,
    );

    if (index != -1) {
      roomTasks[index].completed = true;
      _notify();
    }
  }

  // ==========================================================
  // DELETE TASK
  // ==========================================================

  static void deleteTask(String id) {
    if (currentRoom == null) {
      return;
    }

    final roomTasks = currentRoomTasks;

    // Find task before deleting it
    final taskToDelete = roomTasks.where(
          (item) => item.id == id,
    );

    String? deletedTitle;

    if (taskToDelete.isNotEmpty) {
      deletedTitle = taskToDelete.first.title;
    }

    // Delete
    roomTasks.removeWhere(
          (item) => item.id == id,
    );

    // If deleted task was current task
    if (deletedTitle != null &&
        currentTask == deletedTitle) {
      _currentTaskByRoom[currentRoom!] = null;
    }
    _notify();
  }

  // ==========================================================
  // TOTAL TASKS
  // ==========================================================

  static int get totalTasks {
    return currentRoomTasks.length;
  }

  // ==========================================================
  // COMPLETED TASKS
  // ==========================================================

  static int get completedTasks {
    return currentRoomTasks
        .where(
          (item) => item.completed,
    )
        .length;
  }

  // ==========================================================
  // TASK PROGRESS
  // ==========================================================

  static double get taskProgress {
    if (totalTasks == 0) {
      return 0.0;
    }

    return completedTasks / totalTasks;
  }

  // ==========================================================
  // COMPLETED PERCENTAGE
  // ==========================================================

  static int get completedPercentage {
    return (taskProgress * 100)
        .round()
        .clamp(0, 100);
  }

  // ==========================================================
  // CURRENT TASK ITEM
  // ==========================================================

  static TaskItem? get currentTaskItem {
    final task = currentTask;

    if (task == null) {
      return null;
    }

    for (final item in currentRoomTasks) {
      if (item.title == task) {
        return item;
      }
    }

    return null;
  }

  // ==========================================================
  // START / SWITCH ROOM
  // ==========================================================

  static void startNewRoom(String roomName) {
    final cleanRoomName = roomName.trim();

    if (cleanRoomName.isEmpty) {
      return;
    }

    currentRoom = cleanRoomName;

    // Create an empty task list only if
    // this room doesn't already exist
    _roomTasks.putIfAbsent(
      cleanRoomName,
          () => [],
    );

    // Make sure current task exists for this room
    _currentTaskByRoom.putIfAbsent(
      cleanRoomName,
          () => null,
    );
  }

  // ==========================================================
  // CLEAR CURRENT TASK
  // ==========================================================

  static void clearTask() {
    if (currentRoom == null) {
      return;
    }

    _currentTaskByRoom[currentRoom!] = null;
  }

  // ==========================================================
  // CLEAR ONE ROOM
  // ==========================================================

  static void clearRoomTasks(String roomName) {
    final cleanRoomName = roomName.trim();

    if (cleanRoomName.isEmpty) {
      return;
    }

    _roomTasks.remove(cleanRoomName);
    _currentTaskByRoom.remove(cleanRoomName);

    // If this was the current room
    if (currentRoom == cleanRoomName) {
      currentRoom = null;
    }
  }

  // ==========================================================
  // CLEAR ALL ROOMS
  // ==========================================================

  static void clearAllTasks() {
    _roomTasks.clear();
    _currentTaskByRoom.clear();
    currentRoom = null;
  }
}