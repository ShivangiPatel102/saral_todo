import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo/constants.dart';

String deleteTodo = """
  mutation deleteTask(\$id: ID!) {
    deleteTask(id: \$id) {
      data {
        id
        attributes {
          Name
          Description
          Completed
        }
      }
    }
  }
""";

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function checkboxCallback;
  final VoidCallback longPressCallback;
  final VoidCallback doublePressCallback;
  final String taskDescription;
  final String id;
  final Function refresh;

  TaskTile({
    required this.isChecked,
    required this.taskTitle,
    required this.checkboxCallback,
    required this.longPressCallback,
    required this.doublePressCallback,
    required this.taskDescription,
    required this.id,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(deleteTodo),
        update: (GraphQLDataProxy cache, QueryResult? result) {
          return cache;
        },
        onCompleted: (dynamic resultData) {
          refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted')),
          );
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return GestureDetector(
          onLongPress: longPressCallback,
          // onDoubleTap: doublePressCallback,
          onDoubleTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      taskTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: kPrimaryAppColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      taskDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: ListTile(
            title: Text(
              taskTitle,
              style: TextStyle(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                fontSize: 22.0,
                fontFamily: "Rubik",
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  activeColor: kPrimaryAppColor,
                  onChanged: checkboxCallback as void Function(bool?)?,
                  value: isChecked,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: kPrimaryAppColor,
                  onPressed: () {
                    runMutation({'id': id});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deleting task...')),
                    );
                  },
                ),
                SizedBox(
                  width: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

