import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiffRow {
  final String label;
  final String aValue;
  final String bValue;
  final bool higherIsBetter;   // false => меньше лучше
  final bool compareAsText;    // текстовое сравнение (AWD vs RWD)
  const DiffRow(
      this.label,
      this.aValue,
      this.bValue, {
        this.higherIsBetter = true,
        this.compareAsText = false,
      });
}

class DiffSection extends StatelessWidget {
  const DiffSection({
    super.key,
    required this.title,
    required this.rows,
    this.hideEquals = false,
  });

  final String title;
  final List<DiffRow> rows;
  final bool hideEquals;

  double _num(String s) {
    final t = s.replaceAll(RegExp(r'[^0-9\\.,-]'), '').replaceAll(',', '.');
    return double.tryParse(t) ?? double.nan;
  }

  bool _isEqual(DiffRow r) {
    if (r.compareAsText) {
      return r.aValue.trim().toLowerCase() == r.bValue.trim().toLowerCase();
    }
    final aNum = _num(r.aValue), bNum = _num(r.bValue);
    if (aNum.isFinite && bNum.isFinite) return (aNum - bNum).abs() < 1e-6;
    return r.aValue.trim() == r.bValue.trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = hideEquals ? rows.where((r) => !_isEqual(r)).toList() : rows;
    if (list.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...list.map((r) => _DiffRowTile(row: r)),
          ],
        ),
      ),
    );
  }
}

class _DiffRowTile extends StatelessWidget {
  const _DiffRowTile({required this.row});
  final DiffRow row;

  double _num(String s) {
    final t = s.replaceAll(RegExp(r'[^0-9\\.,-]'), '').replaceAll(',', '.');
    return double.tryParse(t) ?? double.nan;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final platform = theme.platform;

    int win = 0;
    if (!row.compareAsText) {
      final a = _num(row.aValue), b = _num(row.bValue);
      if (a.isFinite && b.isFinite && a != b) {
        win = (row.higherIsBetter ? a > b : a < b) ? 1 : 2;
      }
    }

    // ✅ вместо .withOpacity — используем контейнерные цвета для лучшего контраста в dark mode
    Color? bg(int who) {
      if (win != who) return null;
      return who == 1 ? cs.primaryContainer : cs.secondaryContainer;
    }

    Color? fg(int who) {
      if (win != who) return null;
      return who == 1 ? cs.onPrimaryContainer : cs.onSecondaryContainer;
    }

    // ✅ адаптивная стрелка (Material / Cupertino)
    IconData upIcon =
    (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoIcons.arrow_up
        : Icons.arrow_upward_rounded;

    Widget valueBox(int who, String text) {
      final isWinner = win == who;
      final boxColor = bg(who);
      final txtColor = fg(who);

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: boxColor ?? cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (isWinner) Icon(upIcon, size: 14, color: txtColor),
            if (isWinner) const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(color: txtColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(
      // ♿️ Читабельное объявление для скринридеров
      label: row.label,
      value: 'A: ${row.aValue}; B: ${row.bValue}',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                row.label,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(flex: 4, child: valueBox(1, row.aValue)),
            const SizedBox(width: 8),
            Expanded(flex: 4, child: valueBox(2, row.bValue)),
          ],
        ),
      ),
    );
  }
}
