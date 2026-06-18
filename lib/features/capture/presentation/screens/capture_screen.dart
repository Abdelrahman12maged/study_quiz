import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/di/service_locator.dart';
import 'package:study_quiz/features/capture/domain/repositories/capture_repository.dart';
import 'package:study_quiz/features/capture/presentation/cubit/capture_cubit.dart';
import 'package:study_quiz/features/capture/presentation/cubit/capture_state.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/capture/presentation/widgets/initial_capture_view.dart';
import 'package:study_quiz/features/capture/presentation/widgets/image_preview_view.dart';
import 'package:study_quiz/features/capture/presentation/widgets/capture_error_view.dart';

/// Capture screen — pick from camera or gallery, preview, confirm & upload.
class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaptureCubit(sl<CaptureRepository>()),
      child: const _CaptureBody(),
    );
  }
}

class _CaptureBody extends StatelessWidget {
  const _CaptureBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<CaptureCubit, CaptureState>(
      listener: (context, state) {
        if (state is CaptureSuccess) {
          context.go('/processing/${state.sessionId}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.captureAPage), // Reused from Home translations
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: switch (state) {
            CaptureInitial() => const InitialCaptureView(),
            CaptureImageSelected(imageFile: final file) =>
              ImagePreviewView(imageFile: file),
            CaptureUploading(imageFile: final file) =>
              ImagePreviewView(imageFile: file, isUploading: true),
            CaptureError(message: final msg, imageFile: final file) =>
              CaptureErrorView(message: msg, imageFile: file),
            CaptureSuccess() => const SizedBox.shrink(),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}
