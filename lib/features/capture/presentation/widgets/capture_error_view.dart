import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/capture/presentation/cubit/capture_cubit.dart';

class CaptureErrorView extends StatelessWidget {
  final String message;
  final File? imageFile;

  const CaptureErrorView({
    super.key,
    required this.message,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: cs.error),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.uploadFailed, style: tt.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(message,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l10n.tryAgain,
              icon: Icons.refresh_rounded,
              isExpanded: false,
              onPressed: () {
                final cubit = context.read<CaptureCubit>();
                if (imageFile != null) {
                  cubit.selectImage(imageFile!);
                } else {
                  cubit.reset();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
