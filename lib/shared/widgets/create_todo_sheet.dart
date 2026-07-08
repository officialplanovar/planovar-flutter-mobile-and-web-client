import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/chat_orders_service.dart';
import '../../core/state/overlay_state.dart';
import '../../core/theme/app_colors.dart';
import 'glossy_button.dart';

/// A selectable member of the group chat (assignee candidate).
class TodoMemberOption {
  final String userId;
  final String name;
  const TodoMemberOption({required this.userId, required this.name});
}

/// Compose a group-chat to-do. Requires real conversation members (their user
/// ids), so it's used from the event GROUP chat once that is wired to the API.
void showCreateTodoSheet(
  BuildContext context, {
  required String conversationId,
  required List<TodoMemberOption> members,
  required String currentUserId,
  VoidCallback? onCreated,
}) {
  bottomSheetCount.value++;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CreateTodoSheet(
      conversationId: conversationId,
      members: members,
      currentUserId: currentUserId,
      onCreated: onCreated,
    ),
  ).whenComplete(() => bottomSheetCount.value--);
}

class CreateTodoSheet extends StatefulWidget {
  final String conversationId;
  final List<TodoMemberOption> members;
  final String currentUserId;
  final VoidCallback? onCreated;

  const CreateTodoSheet({
    super.key,
    required this.conversationId,
    required this.members,
    required this.currentUserId,
    this.onCreated,
  });

  @override
  State<CreateTodoSheet> createState() => _CreateTodoSheetState();
}

class _CreateTodoSheetState extends State<CreateTodoSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _due;
  late final Set<String> _selected = {widget.currentUserId};
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_due ?? now),
    );
    setState(() => _due = DateTime(d.year, d.month, d.day, t?.hour ?? 9, t?.minute ?? 0));
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      _snack('Enter a task');
      return;
    }
    if (_selected.isEmpty) {
      _snack('Assign at least one person');
      return;
    }
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ChatOrdersService().createTodo(
        conversationId: widget.conversationId,
        title: _titleCtrl.text.trim(),
        assigneeIds: _selected.toList(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        dueAt: _due?.toIso8601String(),
      );
      navigator.pop();
      widget.onCreated?.call();
      messenger.showSnackBar(const SnackBar(content: Text('To-do added')));
    } catch (e) {
      if (mounted) setState(() => _submitting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: context.c.surface,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('New to-do',
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
                const SizedBox(height: 14),
                _field(_titleCtrl, 'Task'),
                const SizedBox(height: 10),
                _field(_descCtrl, 'Description (optional)', maxLines: 2),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickDue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.c.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.c.border),
                    ),
                    child: Row(children: [
                      Icon(Icons.schedule_rounded, size: 16, color: context.c.textHint),
                      const SizedBox(width: 8),
                      Text(
                        _due != null
                            ? '${_due!.day}/${_due!.month}/${_due!.year} · ${_two(_due!.hour)}:${_two(_due!.minute)}'
                            : 'Set a due date & time',
                        style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: _due != null ? context.c.textPrimary : context.c.textHint),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Assign to',
                    style: GoogleFonts.urbanist(
                        fontSize: 13, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.members.map((m) {
                    final on = _selected.contains(m.userId);
                    final label = m.userId == widget.currentUserId ? 'You' : m.name;
                    return GestureDetector(
                      onTap: () => setState(() =>
                          on ? _selected.remove(m.userId) : _selected.add(m.userId)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: on ? context.c.primaryLight : context.c.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: on ? AppColors.primary : context.c.border),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (on) const Icon(Icons.check_rounded, size: 14, color: AppColors.primary),
                          if (on) const SizedBox(width: 4),
                          Text(label,
                              style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: on ? AppColors.primary : context.c.textSecondary)),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                GlossyButton(
                  label: _submitting ? 'Adding…' : 'Add to-do',
                  onPressed: _submitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: GoogleFonts.urbanist(color: context.c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
        filled: true,
        fillColor: context.c.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.c.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
