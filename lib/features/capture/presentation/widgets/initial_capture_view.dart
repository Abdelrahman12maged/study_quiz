import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/capture/presentation/cubit/capture_cubit.dart';

class InitialCaptureView extends StatelessWidget {
  const InitialCaptureView({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null && context.mounted) {
      context.read<CaptureCubit>().selectImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Frame guide illustration
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: cs.outlineVariant,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.document_scanner_rounded,
                      size: 64, color: cs.primary.withValues(alpha: 0.6)),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.alignPageWithinFrame,
                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.makeSureTextIsClear,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Camera button
            PrimaryButton(
              label: l10n.takePhoto,
              icon: Icons.camera_alt_rounded,
              onPressed: () => _pickImage(context, ImageSource.camera),
            ),
            const SizedBox(height: AppSpacing.md),

            // Gallery button
            SecondaryButton(
              label: l10n.chooseFromGallery,
              icon: Icons.photo_library_rounded,
              isExpanded: true,
              onPressed: () => _pickImage(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
