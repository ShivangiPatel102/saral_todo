import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo/constants.dart';
import 'package:todo/screens/createTodo.dart';
import 'package:todo/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String readTodos = """
query {
  tasks(sort:"createdAt:desc") {
      data {
        id
        attributes {
          Name
          Description
          Completed
        }
      }
    }
}""";

  String updateTaskStatus = """
  mutation updateTask(\$id: ID!, \$Completed: Boolean) {
    updateTask(id: \$id, data: { Completed: \$Completed }) {
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

  List<Map<String, dynamic>> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
          options: QueryOptions(
            document: gql(readTodos),
            pollInterval: const Duration(seconds: 0),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryAppColor));
            }

            Map<String, dynamic> todos = result.data?["tasks"];

            return Scaffold(
              backgroundColor: kPrimaryAppColor,
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //list icon
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30.0,
                            child: Icon(
                              Icons.list,
                              color: kPrimaryAppColor,
                              size: 40.0,
                            ),
                          ),
                          //space
                          SizedBox(
                            height: 15.0,
                          ),
                          //Todoo title
                          Text(
                            'To-Do',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 30.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: todos["data"].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Mutation(
                              options: MutationOptions(
                                document: gql(updateTaskStatus),
                                onCompleted: (dynamic resultData) {
                                  refetch!();
                                },
                              ),
                              builder: (RunMutation runMutation,
                                  QueryResult? mutationResult) {
                                final currentTodo =
                                    todos["data"][index]["attributes"];
                                return TaskTile(
                                  id: todos["data"][index]["id"],
                                  refresh: () {
                                    refetch!();
                                  },
                                  doublePressCallback: () => {},
                                  isChecked: currentTodo["Completed"],
                                  taskTitle: currentTodo["Name"],
                                  taskDescription:
                                      currentTodo["Description"] ?? '',
                                  checkboxCallback: (bool? checkboxState) {
                                    if (checkboxState != null) {
                                      runMutation({
                                        'id': todos["data"][index]["id"],
                                        'Completed': checkboxState,
                                      });
                                    }
                                  },
                                  longPressCallback: () {
                                    runMutation({
                                      'id': todos["data"][index]["id"],
                                      'Completed': !currentTodo["Completed"],
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
              floatingActionButton: FloatingActionButton(
                backgroundColor: kPrimaryAppColor,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Wrap(
                          children: [
                            CreateTodo(
                              refresh: () {
                                refetch!();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                tooltip: 'Add new todo',
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            );
          }),
    );
  }
}
