import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/career_guidance_task_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";

class CareerGuidanceScreen extends StatefulWidget {
  final String jobSeekerID;

  const CareerGuidanceScreen({super.key, required this.jobSeekerID});

  @override
  State<CareerGuidanceScreen> createState() => _CareerGuidanceScreenState();
}

class _CareerGuidanceScreenState extends State<CareerGuidanceScreen>
    with TickerProviderStateMixin {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _searchCtrl = TextEditingController();

  List<CareerGuidanceTaskModel> _allTasks = [];
  bool _isLoading = true;
  String _activeFilter = 'All'; // All | Pending | Completed | Important

  late AnimationController _headerAnim;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    _loadTasks();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _service.getGuidanceTasks(widget.jobSeekerID);
      if (!mounted) return;
      setState(() {
        _allTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading guidance tasks: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<CareerGuidanceTaskModel> get _filteredTasks {
    List<CareerGuidanceTaskModel> result = List.from(_allTasks);

    // Search filter
    final q = _searchCtrl.text.toLowerCase().trim();
    if (q.isNotEmpty) {
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q);
      }).toList();
    }

    // Chip filter
    switch (_activeFilter) {
      case 'Completed':
        result = result.where((t) => t.isCompleted).toList();
        break;
      case 'Pending':
        result = result.where((t) => !t.isCompleted).toList();
        break;
      case 'Important':
        result = result.where((t) => t.priority == 'High').toList();
        break;
    }

    return result;
  }

  int get _totalCount => _allTasks.length;
  int get _completedCount => _allTasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _allTasks.where((t) => !t.isCompleted).length;

  // ──────── ACTIONS ────────

  Future<void> _toggleComplete(CareerGuidanceTaskModel task) async {
    final newVal = !task.isCompleted;
    await _service.updateGuidanceTask(task.taskID, {
      'isCompleted': newVal,
      'completedAt': newVal ? DateTime.now().toIso8601String() : null,
    });
    await _loadTasks();
  }

  Future<void> _toggleImportant(CareerGuidanceTaskModel task) async {
    final newPriority = task.priority == 'High' ? 'Medium' : 'High';
    await _service.updateGuidanceTask(task.taskID, {'priority': newPriority});
    await _loadTasks();
  }

  Future<void> _deleteTask(CareerGuidanceTaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Task',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: ElevateColor.gray,
          ),
        ),
        content: Text(
          'Remove "${task.title}" permanently?',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    /* if (confirm == true) {
      await _service.deleteGuidanceTask(task.taskID);
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted.'),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }*/
  }

  Future<void> _editTask(CareerGuidanceTaskModel task) async {
    final titleCtrl = TextEditingController(text: task.title);
    final descCtrl = TextEditingController(text: task.description);
    String selectedPriority = task.priority;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 28,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Guidance Task',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ElevateColor.gray,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              _buildLabel('Title'),
              const SizedBox(height: 8),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(
                  fontSize: 14,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _inputDecoration('e.g. Learn Flutter State Mgmt'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Description
              _buildLabel('Description'),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                decoration: _inputDecoration('Describe this learning task...'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Priority
              _buildLabel('Priority'),
              const SizedBox(height: 10),
              Row(
                children: ['Low', 'Medium', 'High'].map((p) {
                  final isSelected = selectedPriority == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setSheetState(() => selectedPriority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _priorityColor(p)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? _priorityColor(p)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ElevateColor.gray,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (saved == true) {
      await _service.updateGuidanceTask(task.taskID, {
        'title': titleCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'priority': selectedPriority,
      });
    }
    titleCtrl.dispose();
    descCtrl.dispose();
    await _loadTasks();
  }

  // ──────── BUILD ────────

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const ElevateHeader(
            title: "Career Guidance",
            subTitle: "Your AI-generated learning path",
            titleSize: 35,
            subtitleSize: 15,
            showBackButton: true,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTasks,
              color: ElevateColor.gray,
              child: CustomScrollView(
                slivers: [
                  // ── Search + Stats + Filters ─────────────────────────────
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats row
                            if (!_isLoading) _buildStatsRow(),

                            const SizedBox(height: 20),

                            // Search bar
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: TextField(
                                controller: _searchCtrl,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ElevateColor.gray,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search tasks...',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Colors.grey.shade400,
                                  ),
                                  suffixIcon: _searchCtrl.text.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            _searchCtrl.clear();
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.grey.shade400,
                                          ),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Filter chips
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  'All',
                                  'Pending',
                                  'Completed',
                                  'Important',
                                ].map((f) => _buildFilterChip(f)).toList(),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Body ────────────────────────────────────────────────
                  if (_isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ElevateColor.gray,
                        ),
                      ),
                    )
                  else if (tasks.isEmpty)
                    SliverFillRemaining(child: _buildEmptyState())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _GuidanceTaskCard(
                            key: ValueKey(tasks[i].taskID),
                            task: tasks[i],
                            onToggleComplete: () => _toggleComplete(tasks[i]),
                            onToggleImportant: () => _toggleImportant(tasks[i]),
                            onEdit: () => _editTask(tasks[i]),
                            onDelete: () => _deleteTask(tasks[i]),
                          ),
                          childCount: tasks.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatBadge(_totalCount.toString(), 'Total', Colors.black87),
        const SizedBox(width: 10),
        _buildStatBadge(
          _pendingCount.toString(),
          'Pending',
          const Color(0xFF1A6B3C),
        ),
        const SizedBox(width: 10),
        _buildStatBadge(
          _completedCount.toString(),
          'Done',
          Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildStatBadge(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
    IconData? icon;
    switch (label) {
      case 'Completed':
        icon = Icons.check_circle_outline;
        break;
      case 'Pending':
        icon = Icons.radio_button_unchecked;
        break;
      case 'Important':
        icon = Icons.star_outline;
        break;
      default:
        icon = null;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _activeFilter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? ElevateColor.gray : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? ElevateColor.gray : Colors.grey.shade200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 13,
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchCtrl.text.isNotEmpty;
    final isFiltering = _activeFilter != 'All';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(
                isSearching || isFiltering
                    ? Icons.search_off
                    : Icons.auto_awesome_outlined,
                size: 36,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching
                  ? 'No tasks match your search'
                  : isFiltering
                  ? 'No $_activeFilter tasks'
                  : 'No Guidance Tasks Yet',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ElevateColor.gray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching || isFiltering
                  ? 'Try a different search or filter.'
                  : 'Take a skill test and let AI generate\nyour personalized learning path.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ElevateColor.gray, width: 1.5),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: ElevateColor.gray,
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFF1A6B3C);
      case 'Medium':
        return const Color(0xFF5A5A5A);
      default:
        return Colors.grey.shade500;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Task Card
// ─────────────────────────────────────────────────────────────────────────────

class _GuidanceTaskCard extends StatefulWidget {
  final CareerGuidanceTaskModel task;
  final VoidCallback onToggleComplete;
  final VoidCallback onToggleImportant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GuidanceTaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onToggleImportant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_GuidanceTaskCard> createState() => _GuidanceTaskCardState();
}

class _GuidanceTaskCardState extends State<_GuidanceTaskCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Color get _priorityColor {
    switch (widget.task.priority) {
      case 'High':
        return const Color(0xFF1A6B3C);
      case 'Medium':
        return const Color(0xFF5A5A5A);
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isCompleted = task.isCompleted;
    final isImportant = task.priority == 'High';

    return FadeTransition(
      opacity: _fade,
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.grey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? Colors.grey.shade200
                  : isImportant
                  ? const Color(0xFF1A6B3C).withOpacity(0.3)
                  : Colors.grey.shade200,
              width: isImportant && !isCompleted ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isCompleted ? 0.02 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Main content row ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Completion circle checkbox
                    GestureDetector(
                      onTap: widget.onToggleComplete,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? ElevateColor.gray
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCompleted
                                ? ElevateColor.gray
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Content column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + star row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isCompleted
                                        ? Colors.grey.shade400
                                        : ElevateColor.gray,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.grey.shade400,
                                  ),
                                  maxLines: _expanded ? null : 2,
                                  overflow: _expanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                              ),
                              if (isImportant && !isCompleted) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Color(0xFF1A6B3C),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Description (expand/collapse)
                          if (task.description.isNotEmpty)
                            AnimatedCrossFade(
                              firstChild: Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              secondChild: Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  height: 1.4,
                                ),
                              ),
                              crossFadeState: _expanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 200),
                            ),

                          const SizedBox(height: 10),

                          // Badges
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildBadge(task.priority, _priorityColor),
                                if (task.aiGenerated) ...[
                                  const SizedBox(width: 6),
                                  _buildBadge(
                                    '✨ AI Generated',
                                    const Color(0xFF1A6B3C),
                                    textColor: Colors.white,
                                    filled: true,
                                  ),
                                ],
                                const SizedBox(width: 6),
                                if (isCompleted && task.completedAt != null)
                                  _buildBadge(
                                    'Done ${DateFormat('MMM d').format(task.completedAt!)}',
                                    Colors.grey.shade400,
                                  )
                                else
                                  _buildBadge(
                                    DateFormat('MMM d').format(task.createdAt),
                                    Colors.grey.shade400,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3-dot menu
                    _buildActionMenu(task),
                  ],
                ),
              ),

              // ── Expanded action bar (tap card to reveal) ──────────────────
              if (_expanded)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    child: Row(
                      children: [
                        _buildActionBtn(
                          icon: isCompleted
                              ? Icons.replay_rounded
                              : Icons.check_circle_rounded,
                          label: isCompleted ? 'Undo' : 'Complete',
                          color: isCompleted
                              ? Colors.grey.shade600
                              : const Color(0xFF1A6B3C),
                          onTap: widget.onToggleComplete,
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: isImportant
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          label: isImportant ? 'Unmark' : 'Important',
                          color: isImportant
                              ? const Color(0xFF1A6B3C)
                              : Colors.grey.shade600,
                          onTap: widget.onToggleImportant,
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                          color: Colors.grey.shade700,
                          onTap: widget.onEdit,
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.delete_outline_rounded,
                          label: 'Delete',
                          color: Colors.red.shade400,
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(CareerGuidanceTaskModel task) {
    return PopupMenuButton<String>(
      onSelected: (val) {
        switch (val) {
          case 'complete':
            widget.onToggleComplete();
            break;
          case 'important':
            widget.onToggleImportant();
            break;
          case 'edit':
            widget.onEdit();
            break;
          case 'delete':
            widget.onDelete();
            break;
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 4,
      icon: Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: Colors.grey.shade400,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'complete',
          child: _menuItem(
            task.isCompleted
                ? Icons.replay_rounded
                : Icons.check_circle_outline_rounded,
            task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
            task.isCompleted ? Colors.grey : const Color(0xFF1A6B3C),
          ),
        ),
        PopupMenuItem(
          value: 'important',
          child: _menuItem(
            task.priority == 'High'
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            task.priority == 'High' ? 'Unmark Important' : 'Mark Important',
            const Color(0xFF1A6B3C),
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: _menuItem(Icons.edit_outlined, 'Edit Task', ElevateColor.gray),
        ),
        PopupMenuItem(
          value: 'delete',
          child: _menuItem(
            Icons.delete_outline_rounded,
            'Delete',
            Colors.red.shade600,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(
    String text,
    Color color, {
    Color? textColor,
    bool filled = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor ?? color,
        ),
      ),
    );
  }
}
