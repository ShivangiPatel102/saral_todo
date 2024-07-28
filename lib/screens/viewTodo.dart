import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo/api/graphqlConfig.dart';

String readTodo= """
  query(\$id: ID!) {
    task(id: \$id) {
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

String updateTodo = """
  mutation updateTask(\$id: ID!, \$Name: String, \$Description: String, \$Completed: Boolean) {
    updateTask(id: \$id, data: { Name: \$Name, Description: \$Description, Completed: \$Completed }) {
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


class ViewTodo extends StatefulWidget {
  final id;
  final refresh;
  const ViewTodo({Key? key, @required this.id, @required this.refresh})
      : super(key: key);
  @override
  ViewTodoState createState() =>
      ViewTodoState(id: this.id, refresh: this.refresh);
}

class ViewTodoState extends State<ViewTodo> {
  late final id;
  late final refresh;
  ViewTodoState({Key? key, @required this.id, this.refresh});
  var editMode = false;
  var myController;
  bool? done;
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Query(
            options: QueryOptions(
                document: gql(readTodo),
                variables: {'id': id},
                pollInterval: const Duration(seconds: 0)),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return const Scaffold(body: Center(child: Text('Loading')));
              }
              // it can be either Map or List
              var todo = result.data?["task"];
              done = todo["data"]["attributes"]["Completed"];
              myController = TextEditingController(
                  text: todo["data"]["attributes"]["Name"].toString());
              return Scaffold(
                  appBar: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.blue,
                      flexibleSpace: SafeArea(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  right: 16, top: 4, bottom: 4, left: 0),
                              child: Row(children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "View Todo",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ])))),
                  body: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.blue),
                    width: double.infinity,
                    height: 200,
                    child: editMode
                        ? Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                  child: const Text("Todo:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ))),
                              TextField(
                                controller: myController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.white)),
                                    hintText: 'Add todo'),
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 4),
                                        child: const Text("Done:",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ))),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Checkbox(
                                        value: done,
                                        onChanged: (value) {
                                          setState(() {
                                            done = value;
                                          });
                                        },
                                      );
                                    }),
                                  ])
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                    child: const Text("Todo:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                      child: Text(
                                          todo["data"]["attributes"]["Name"]
                                              .toString(),
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text("Done:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                      todo["data"]["attributes"]["Completed"]
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                  ),
                  floatingActionButton: !editMode
                      ? Mutation(
                          options: MutationOptions(
                            document: gql(deleteTodo),
                            update:
                                (GraphQLDataProxy cache, QueryResult? result) {
                              return cache;
                            },
                            onCompleted: (dynamic resultData) {
                              refresh();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Done')));
                              Navigator.pop(context);
                            },
                          ),
                          builder:
                              (RunMutation runMutation, QueryResult? result) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    heroTag: null,
                                    child: const Icon(Icons.delete),
                                    onPressed: () {
                                      runMutation({'id': id});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Deleting todo...')));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FloatingActionButton(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        editMode = true;
                                      });
                                    },
                                    tooltip: 'Edit todo',
                                    child: const Icon(Icons.edit),
                                  )
                                ]);
                          })
                      : Mutation(
                          options: MutationOptions(
                            document: gql(updateTodo),
                            update:
                                (GraphQLDataProxy cache, QueryResult? result) {
                              return cache;
                            },
                            onCompleted: (dynamic resultData) {
                              refresh();
                              refetch!();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Done.')));
                            },
                          ),
                          builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                          ) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: FloatingActionButton(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        heroTag: null,
                                        child: const Icon(Icons.cancel),
                                        onPressed: () {
                                          setState(() {
                                            editMode = false;
                                          });
                                        },
                                      )),
                                  FloatingActionButton(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    heroTag: null,
                                    child: const Icon(Icons.save),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Updating todo...')));
                                      runMutation({
                                        'id': id,
                                        'name': myController.text,
                                        'done': done
                                      });
                                      setState(() {
                                        editMode = false;
                                      });
                                    },
                                  )
                                ]);
                          }));
            }));
  }
}
