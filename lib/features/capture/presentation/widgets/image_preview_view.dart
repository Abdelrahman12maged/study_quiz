import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/capture/presentation/cubit/capture_cubit.dart';

class ImagePreviewView extends StatelessWidget {
  final File imageFile;
  final bool isUploading;

  const ImagePreviewView({
    super.key,
    required this.imageFile,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        children: [
          // Image preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: cs.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.sm,
              AppSpacing.pagePadding,
              AppSpacing.xl,
            ),
            child: Row(
              children: [
                // Retake
                Expanded(
                  child: SecondaryButton(
                    label: l10n.retake,
                    icon: Icons.refresh_rounded,
                    isExpanded: true,
                    onPressed: isUploading
                        ? null
                        : () => context.read<CaptureCubit>().clearSelection(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Confirm
                Expanded(
                  child: PrimaryButton(
                    label: l10n.upload,
                    icon: Icons.cloud_upload_rounded,
                    isLoading: isUploading,
                    isExpanded: true,
                    onPressed: isUploading
                        ? null
                        : () => context.read<CaptureCubit>().uploadImage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
