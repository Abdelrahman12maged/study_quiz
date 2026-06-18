import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:study_quiz/core/responsive/responsive_builder.dart';
import 'package:study_quiz/core/widgets/error_state_view.dart';
import 'package:study_quiz/core/widgets/loading_indicator.dart';

import 'package:study_quiz/features/home/presentation/cubit/home_cubit.dart';
import 'package:study_quiz/features/home/presentation/cubit/home_state.dart';
import 'package:study_quiz/features/home/presentation/widgets/mobile_home_layout.dart';
import 'package:study_quiz/features/home/presentation/widgets/tablet_home_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }
        if (state is HomeError) {
          return Scaffold(
            body: ErrorStateView(
              message: state.message,
              onRetry: () => context.read<HomeCubit>().loadDashboard(),
            ),
          );
        }
        if (state is HomeLoaded) {
          return ResponsiveBuilder(
            mobile: (_, __) => MobileHomeLayout(state: state),
            tablet: (_, __) => TabletHomeLayout(state: state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
