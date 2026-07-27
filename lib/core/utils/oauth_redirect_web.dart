// ignore: deprecated_member_use
import 'dart:html' as html;

/// Strips the relayed `planovar_token` (and any `auth_error`) from the browser
/// URL via History.replaceState, leaving the path intact.
void clearOAuthParams() {
  final u = Uri.base;
  final path = u.path.isEmpty ? '/' : u.path;
  html.window.history.replaceState(null, '', path);
}
