import 'package:easy_books/app/auth/add/AddUserWidget.dart';
import 'package:easy_books/app/auth/edit/EditUserWidget.dart';
import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:flutter/material.dart';

class ManageUsersWidget extends StatelessWidget with UserHelper {
  ManageUsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Staff'),
        onPressed: () => navigateTo(const AddUserWidget(), context),
      ),
      body: StreamBuilder<List<User>>(
        stream: usersStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoaderWidget();
          }

          final users = snapshot.data ?? <User>[];
          return buildListView(users, context);
        },
      ),
    );
  }

  ListView buildListView(List<User> users, BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        final user = users.elementAt(index);
        return ListTile(
          title: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Manager Status: ${user.isAdmin}'),
          onTap: () => navigateTo(EditUserWidget(user: user), context),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }
}
