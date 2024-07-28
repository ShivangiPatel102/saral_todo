import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo/constants.dart';
import '../api/graphQLConfig.dart';

class CreateTodo extends StatelessWidget {
  final String addTodo = """
  mutation createTask(\$Name: String, \$Description: String, \$Completed: Boolean) {
    createTask(data: { Name: \$Name, Description: \$Description, Completed: \$Completed }) {
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final VoidCallback? refresh;

  CreateTodo({Key? key, this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfiguration.clientToQuery(),
      child: Mutation(
        options: MutationOptions(
          document: gql(addTodo),
          update: (GraphQLDataProxy cache, QueryResult? result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
            if (refresh != null) refresh!();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New todo added.')),
            );
            Navigator.pop(context);
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Container(
            color: const Color(0xff757575),
            child: Container(
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
                  const Text(
                    'Add Task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: kPrimaryAppColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextField(
                    controller: nameController,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Task name',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: descriptionController,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Task description',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      runMutation({
                        'Name': nameController.text,
                        'Description': descriptionController.text,
                        'Completed': false,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adding new todo...')),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryAppColor,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
