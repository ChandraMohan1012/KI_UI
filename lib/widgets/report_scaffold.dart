import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_loader.dart';
import 'app_error_view.dart';
import 'app_empty_state.dart';

class ReportScaffold extends StatelessWidget {
  const ReportScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.onRefresh,
    this.isLoading = false,
    this.isError = false,
    this.isEmpty = false,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final bool isError;
  final bool isEmpty;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = loadingWidget ?? const AppLoader(message: 'Loading details...');
    } else if (isError) {
      content = errorWidget ??
          AppErrorView(
              message: 'Failed to load report data.', onRetry: onRefresh);
    } else if (isEmpty) {
      content = emptyWidget ??
          const AppEmptyState(
              title: 'No Data Found',
              message: 'There is no report data available.');
    } else {
      content = body;
    }

    if (onRefresh != null && !isLoading && !isError && !isEmpty) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColors.accent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: content,
        ),
      );
    } else if (!isLoading && !isError && !isEmpty) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: content,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
