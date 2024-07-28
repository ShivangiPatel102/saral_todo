// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:todo/screens/createTodo.dart';
// import 'package:todo/screens/viewTodo.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   String readTodos = """
// query {
//   tasks(sort:"createdAt:desc") {
//       data {
//         id
//         attributes {
//           Name
//           Description
//           Completed
//         }
//       }
//     }
// }""";

//   List<Map<String, dynamic>> todos = [];


//   onChange(b) {
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Query(
//           options: QueryOptions(
//             document: gql(readTodos),
//             pollInterval: const Duration(seconds: 0),
//           ),
//           builder: (QueryResult result,
//               {VoidCallback? refetch, FetchMore? fetchMore}) {
//             if (result.hasException) {
//               return Text(result.exception.toString());
//             }

//             if (result.isLoading) {
//               return const Center(child: Text('Loading'));
//             }

//             Map<String, dynamic> todos = result.data?["tasks"];

//             return Scaffold(
//               backgroundColor: Colors.white,
//               body: Column(children: [
//                 Container(
//                     alignment: Alignment.centerLeft,
//                     padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
//                     color: Colors.blue,
//                     child: const Text(
//                       "Todo",
//                       style: TextStyle(
//                           fontSize: 45,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   child: ListView.builder(
//                     itemCount: todos["data"].length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewTodo(
//                                     id: todos["data"][index]["id"],
//                                     refresh: () {
//                                       refetch!();
//                                     }),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                             padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                             decoration: const BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(7)),
//                               color: Colors.black,
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0, 6, 0, 6),
//                                         // child: Text('To do'),
//                                         child: Text(
//                                             todos['data'][index]["attributes"]
//                                                     ["Name"]
//                                                 .toString(),
//                                             style: const TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold)),
//                                       ),
//                                       // Text(
//                                       //   DateFormat("yMMMEd")
//                                       //       .format(DateTime.parse(todos['data']
//                                       //                   [index]["attributes"]
//                                       //               ["createdAt"]
//                                       //           .toString()))
//                                       //       .toString(),
//                                       //   style: const TextStyle(
//                                       //       color: Colors.white),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                                 Checkbox(
//                                   value: todos["data"][index]["attributes"]
//                                       ["Completed"],
//                                   onChanged: onChange,
//                                   checkColor: Colors.white,
//                                   activeColor: Colors.white,
//                                 )
//                               ],
//                             ),
//                           ));
//                     },
//                   ),
//                 ),
//               ]),
//               floatingActionButton: FloatingActionButton(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.green,
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CreateTodo(refresh: () {
//                         refetch!();
//                       }),
//                     ),
//                   );
//                 },
//                 tooltip: 'Add new todo',
//                 child: const Icon(Icons.add),
//               ),
//             );
//           }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo/screens/createTodo.dart';
import 'package:todo/screens/viewTodo.dart';

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
              return const Center(child: Text('Loading'));
            }

            Map<String, dynamic> todos = result.data?["tasks"];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
                    color: Colors.blue,
                    child: const Text(
                      "Todo",
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
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
                        builder: (RunMutation runMutation, QueryResult? mutationResult) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewTodo(
                                        id: todos["data"][index]["id"],
                                        refresh: () {
                                          refetch!();
                                        }),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 6, 0, 6),
                                            child: Text(
                                                todos['data'][index]["attributes"]
                                                        ["Name"]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: todos["data"][index]["attributes"]
                                          ["Completed"],
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          runMutation({
                                            'id': todos["data"][index]["id"],
                                            'Completed': value,
                                          });
                                        }
                                      },
                                      checkColor: Colors.white,
                                      activeColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    },
                  ),
                ),
              ]),
              floatingActionButton: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTodo(refresh: () {
                        refetch!();
                      }),
                    ),
                  );
                },
                tooltip: 'Add new todo',
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
