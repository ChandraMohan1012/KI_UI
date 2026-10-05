import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Conditional imports to prevent mobile build crashes
import 'web_stub.dart' if (dart.library.html) 'dart:ui_web' as ui_web;

import 'web_stub.dart' if (dart.library.html) 'package:web/web.dart' as web;
import '../widgets/door_window_selector_widget.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class ViewerScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  final bool isElevation;
  final bool isStructural;
  final VoidCallback? onNavigateToVastu;
  final void Function(Uint8List bytes)? onScreenshotReady;
  const ViewerScreen({
    super.key,
    required this.projectData,
    this.isElevation = false,
    this.isStructural = false,
    this.onNavigateToVastu,
    this.onScreenshotReady,
  });

  @override
  State<ViewerScreen> createState() => ViewerScreenState();
}

class ViewerScreenState extends State<ViewerScreen> {
  // Mobile Controller
  late final WebViewController _mobileController;

  // Web State
  final String _viewId =
      'viewer-iframe-${DateTime.now().millisecondsSinceEpoch}';
  web.HTMLIFrameElement? _webIFrame;

  bool _isWebViewReady = false;
  String _doorStyle = 'glass';
  String _windowStyle = 'wood';

  // Completer to receive screenshot from web iframe
  Completer<String?>? _screenshotCompleter;

  void _updateDoorStyle(String style) {
    setState(() => _doorStyle = style);
    if (kIsWeb) {
      final msg = json.encode({'type': 'set_door_style', 'style': style});
      _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
    } else {
      _mobileController
          .runJavaScript("if(window.setDoorStyle) setDoorStyle('$style');");
    }
  }

  void _updateWindowStyle(String style) {
    setState(() => _windowStyle = style);
    if (kIsWeb) {
      final msg = json.encode({'type': 'set_window_style', 'style': style});
      _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
    } else {
      _mobileController
          .runJavaScript("if(window.setWindowStyle) setWindowStyle('$style');");
    }
  }

  void _showDoorWindowSelector() {
    showDialog(
      context: context,
      builder: (ctx) => DoorWindowSelectorWidget(
        currentDoorStyle: _doorStyle,
        currentWindowStyle: _windowStyle,
        onDoorStyleChanged: _updateDoorStyle,
        onWindowStyleChanged: _updateWindowStyle,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _setupWebView();
    } else {
      _setupMobileView();
    }
  }

  @override
  void didUpdateWidget(ViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectData != widget.projectData) {
      _validationFailed = false;
      if (kIsWeb) {
        _sendDataToWeb();
      } else {
        _injectData();
      }
    }
  }

  bool _isValidV4Data(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return false;
    // Accept either the new nested 'floors' structure or the flat structure
    if (data.containsKey('floors') ||
        data.containsKey('rooms') ||
        data.containsKey('walls')) {
      return true;
    }
    return false;
  }

  void _setupWebView() {
    String viewParam = '';
    if (widget.isElevation) viewParam = '?view=elevation&hideToolbar=true';
    if (widget.isStructural) viewParam = '?view=structural&hideToolbar=true';
    final url = 'assets/viewer/viewer.html$viewParam';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      _webIFrame = web.HTMLIFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..style.display = 'block'
        ..src = url;

      web.window.addEventListener(
        'message',
        (web.Event event) {
          final message = event as web.MessageEvent;

          String raw = '';
          try {
            final dartData = message.data?.dartify();
            raw = dartData?.toString() ?? '';
          } catch (e) {
            // Ignore messages that cannot be dartified (e.g. from extensions)
          }

          if (raw == 'viewer_ready') {
            _sendDataToWeb();
          } else if (raw.startsWith('{')) {
            try {
              final parsed = json.decode(raw) as Map<String, dynamic>;
              if (parsed['type'] == 'screenshot_result') {
                _screenshotCompleter?.complete(parsed['data'] as String?);
                _screenshotCompleter = null;
              }
            } catch (_) {}
          }
        }.toJS,
      );

      return _webIFrame!;
    });

    Future.microtask(() {
      if (mounted) setState(() => _isWebViewReady = true);

      // Fallback: forcefully send data just in case the message event was missed or blocked
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) _sendDataToWeb();
      });
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) _sendDataToWeb();
      });
    });
  }

  void _sendDataToWeb() {
    if (_webIFrame == null) return;
    final modelData = widget.projectData['model_data'] as Map<String, dynamic>?;

    if (!_isValidV4Data(modelData)) {
      setState(() {
        _validationFailed = true;
      });
      return;
    }

    final data = json.encode({'type': 'render', 'data': modelData});
    _webIFrame!.contentWindow?.postMessage(data.toJS, '*'.toJS);

    if (widget.onScreenshotReady != null) {
      Future.delayed(const Duration(seconds: 3), _autoCapture);
    }
  }

  void _setupMobileView() {
    _mobileController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() => _isWebViewReady = true);
            _injectData();
          },
        ),
      )
      ..loadFlutterAsset(
        'assets/viewer/viewer.html${widget.isElevation ? "?view=elevation&hideToolbar=true" : (widget.isStructural ? "?view=structural&hideToolbar=true" : "")}',
      );
  }

  bool _validationFailed = false;

  void _injectData() {
    if (kIsWeb) return;
    final modelData = widget.projectData['model_data'] as Map<String, dynamic>?;

    if (!_isValidV4Data(modelData)) {
      setState(() {
        _validationFailed = true;
      });
      return;
    }

    final jsonData = json.encode(modelData);
    _mobileController.runJavaScript('window.renderProject($jsonData);');

    if (widget.isElevation) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _mobileController
            .runJavaScript("if(window.setView) setView('elevation');");
      });
    } else if (widget.isStructural) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _mobileController
            .runJavaScript("if(window.setView) setView('structural');");
      });
    }

    if (widget.onScreenshotReady != null) {
      Future.delayed(const Duration(seconds: 3), _autoCapture);
    }
  }

  Future<void> _autoCapture() async {
    if (!mounted) return;
    final bytes = await captureScreenshot();
    if (bytes != null && mounted) {
      debugPrint(
          '[ViewerScreen] Auto-captured 3D screenshot: ${bytes.length} bytes');
      widget.onScreenshotReady?.call(bytes);
    }
  }

  Future<void> setCameraMode(String mode) async {
    if (!_isWebViewReady) return;
    try {
      if (kIsWeb) {
        final msg = json.encode({'type': 'set_cam_mode', 'mode': mode});
        _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
      } else {
        await _mobileController
            .runJavaScript("if(window.setCamMode) setCamMode('$mode');");
      }
    } catch (e) {
      debugPrint('[ViewerScreen] setCameraMode error: $e');
    }
  }

  /// Automatically switches to 3D Top View for PDF, captures screenshots, and restores view.
  Future<Map<String, Uint8List>> captureAllFloorScreenshots() async {
    if (!_isWebViewReady) return {};

    Map<String, Uint8List> result = {};
    final modelData = widget.projectData['model_data'];
    final floors = modelData?['floors'] as Map<String, dynamic>?;

    // Force 3D Top View camera mode for clean PDF export
    await setCameraMode('top');
    await Future.delayed(const Duration(milliseconds: 500));

    if (floors != null && floors.keys.length > 1) {
      for (var floor in floors.keys) {
        try {
          if (kIsWeb) {
            final msg = json.encode({'type': 'set_view', 'view': floor});
            _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
          } else {
            await _mobileController
                .runJavaScript("if(window.setView) setView('$floor');");
          }
        } catch (_) {}

        await Future.delayed(const Duration(milliseconds: 800));
        await setCameraMode('top');
        await Future.delayed(const Duration(milliseconds: 400));

        final bytes = await captureScreenshot();
        if (bytes != null) result[floor] = bytes;
      }

      // Reset view to stacked after capturing
      try {
        if (kIsWeb) {
          final msg = json.encode({'type': 'set_view', 'view': 'stacked'});
          _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
        } else {
          await _mobileController
              .runJavaScript("if(window.setView) setView('stacked');");
        }
      } catch (_) {}
    } else {
      // Single floor: capture clean top view
      final bytes = await captureScreenshot();
      if (bytes != null) result['default'] = bytes;
    }

    // Restore interactive camera view (isometric) for user
    await setCameraMode('iso');

    return result;
  }

  /// Captures the 3D view as PNG bytes (defaulting to Top View for PDF).
  Future<Uint8List?> captureScreenshot({String mode = 'top'}) async {
    if (!_isWebViewReady) return null;
    try {
      if (kIsWeb) {
        // Send capture request to iframe, await response via Completer
        _screenshotCompleter = Completer<String?>();
        final msg = json.encode({'type': 'capture_screenshot', 'mode': mode});
        _webIFrame?.contentWindow?.postMessage(msg.toJS, '*'.toJS);
        final dataUrl = await _screenshotCompleter!.future
            .timeout(const Duration(seconds: 5), onTimeout: () => null);
        if (dataUrl == null || !dataUrl.startsWith('data:image')) return null;
        final base64Str = dataUrl.split(',').last;
        return base64Decode(base64Str);
      } else {
        // Mobile: call JS captureScreenshot('top') and decode result
        final result = await _mobileController.runJavaScriptReturningResult(
            "window.captureScreenshot('$mode')") as String?;
        if (result == null || result == 'null') return null;
        // result may be quoted JSON string like "data:image/png;base64,..."
        String dataUrl = result;
        if (dataUrl.startsWith('"')) dataUrl = json.decode(dataUrl) as String;
        if (!dataUrl.startsWith('data:image')) return null;
        final base64Str = dataUrl.split(',').last;
        return base64Decode(base64Str);
      }
    } catch (e) {
      debugPrint('[ViewerScreen] captureScreenshot error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_validationFailed) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Invalid Model',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3D Model fills available viewport height
              Expanded(
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: AppRadius.lgBorder,
                    child: Stack(
                      children: [
                        if (kIsWeb)
                          HtmlElementView(viewType: _viewId)
                        else
                          WebViewWidget(controller: _mobileController),
                        if (!_isWebViewReady)
                          const Center(
                            child: AppLoader(
                              message: 'Loading 3D Engine...',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Customize Action Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showDoorWindowSelector,
                      icon: const Icon(Icons.style_outlined, size: 18),
                      label: const Text('Customize Doors & Windows'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleCard(String id, String name, String assetPath,
      {required bool isSelected, required VoidCallback onTap}) {
    final cs = context.cs;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.accent : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: AppRadius.smBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(7)),
              child: Image.asset(
                assetPath,
                height: 100,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(height: 100, color: cs.surfaceContainerHighest),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                name,
                style:
                    context.tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
