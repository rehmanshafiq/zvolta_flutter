import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_event.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';

/// Home tab — displays data fetched through the domain layer.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeUsersRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const AppLoadingIndicator(
                message: 'Fetching users...',
              ),
            HomeFailure(:final message) => AppErrorView(
                message: message,
                onRetry: () => context
                    .read<HomeBloc>()
                    .add(const HomeRefreshRequested()),
              ),
            HomeLoaded(:final users) => RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const HomeRefreshRequested());
                  await context.read<HomeBloc>().stream.firstWhere(
                        (s) => s is HomeLoaded || s is HomeFailure,
                      );
                },
                child: users.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('No users found')),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('${user.id}'),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                          );
                        },
                      ),
              ),
          };
        },
      ),
    );
  }
}
