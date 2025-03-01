import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/task/task_cubit.dart';
import 'dart:math' show sin, pi;
import 'package:flutter/services.dart' show HapticFeedback;

class TaskDialog extends StatefulWidget {
  TaskDialog({super.key});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog>
    with SingleTickerProviderStateMixin {
  final _textTitleController = TextEditingController();
  final _textDescController = TextEditingController();
  bool _showTitleError = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create a shake animation
    _animation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController);

    // Add a listener to update the UI during animation
    _animation.addListener(() {
      setState(() {});
    });
  }

  void _validateAndSubmit() {
    if (_textTitleController.text.isEmpty) {
      // Show error and start shake animation
      setState(() {
        _showTitleError = true;
      });

      // Shake 3 times
      _animationController.reset();
      _animationController.forward().then((_) {
        _animationController.reset();
        _animationController.forward().then((_) {
          _animationController.reset();
          _animationController.forward();
        });
      });

      // Vibrate if available
      HapticFeedback.mediumImpact();
    } else {
      // Submit the task
      context.read<TaskCubit>().addTask(
            _textTitleController.text,
            _textDescController.text,
          );
      _textTitleController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _textTitleController.dispose();
    _textDescController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the shake offset
    final double offset =
        _showTitleError ? sin(_animation.value * pi / 180) * 10 : 0;

    return AlertDialog(
      title: const Text("Add Task"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use Transform to apply the shake effect
            Transform.translate(
              offset: Offset(offset, 0),
              child: TextField(
                controller: _textTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  errorText: _showTitleError ? 'Title cannot be empty' : null,
                  errorStyle: const TextStyle(color: Colors.red),
                  focusedBorder: _showTitleError
                      ? const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        )
                      : null,
                  enabledBorder: _showTitleError
                      ? const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        )
                      : null,
                ),
                autofocus: true,
                onChanged: (value) {
                  if (_showTitleError && value.isNotEmpty) {
                    setState(() {
                      _showTitleError = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textDescController,
              decoration: const InputDecoration(
                hintText: 'Enter task description',
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _validateAndSubmit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
