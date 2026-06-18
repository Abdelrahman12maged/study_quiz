import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/core/responsive/responsive_builder.dart';
import 'package:study_quiz/core/widgets/error_state_view.dart';
import 'package:study_quiz/core/widgets/loading_indicator.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_cubit.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_state.dart';

import 'package:study_quiz/features/history/presentation/widgets/history_list_layout.dart';
import 'package:study_quiz/features/history/presentation/widgets/history_grid_layout.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }
        if (state is HistoryError) {
          return Scaffold(
            body: ErrorStateView(
              message: state.message,
              onRetry: () => context.read<HistoryCubit>().loadHistory(),
            ),
          );
        }
        if (state is HistoryLoaded) {
          return ResponsiveBuilder(
            mobile: (_, __) => HistoryListLayout(state: state),
            tablet: (_, __) => HistoryGridLayout(state: state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
