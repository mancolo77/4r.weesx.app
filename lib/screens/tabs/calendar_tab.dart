import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_overview_service.dart';
import '../widgets/cricket_detail_sheet.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  final CricketOverviewService _service = CricketOverviewService();
  String _selectedDay = 'All Days';
  String _searchQuery = '';
  String? _selectedTournament;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var list = _service.matches;

    if (_selectedDay != 'All Days') {
      list = list.where((m) => m.date == _selectedDay).toList();
    }

    if (_selectedTournament != null && _selectedTournament != 'All Tournaments') {
      list = list.where((m) => m.tournament == _selectedTournament).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((m) => m.teamA.toLowerCase().contains(q) || m.teamB.toLowerCase().contains(q)).toList();
    }

    final tours = ['All Tournaments', ..._service.matches.map((m) => m.tournament).toSet()];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Schedule & Calendar', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Team
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search team in calendar...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.darkNav,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 12),

            // Day Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All Days', 'Yesterday', 'Today', 'Tomorrow'].map((day) {
                  final isSel = _selectedDay == day;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(day),
                      selected: isSel,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.darkNav,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _selectedDay = day),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Tournament dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppTheme.darkNav, borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTournament ?? 'All Tournaments',
                  dropdownColor: AppTheme.darkNav,
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  isExpanded: true,
                  onChanged: (val) => setState(() => _selectedTournament = val),
                  items: tours.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Matches
            if (list.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Column(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 48, color: AppTheme.textSecondary),
                    SizedBox(height: 12),
                    Text('No calendar fixtures match the filter.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              )
            else
              ...list.map((m) {
                final isFav = _service.favMatchIds.contains(m.id);
                final isFinished = m.status.toLowerCase().contains('finish') || (!m.isLive && m.scoreA != null);
                return Card(
                  color: AppTheme.surfaceCard,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    onTap: () => showCricketMatchDetails(context, m),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${m.date} • ${m.timeIST}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.accentYellow : AppTheme.textSecondary),
                                onPressed: () => _service.toggleFavoriteMatch(m.id),
                              ),
                            ],
                          ),
                          Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${m.tournament} • ${m.venue}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          const SizedBox(height: 8),
                          if (isFinished)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(6)),
                              child: Text('Result: ${m.summary}', style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12, fontWeight: FontWeight.bold)),
                            )
                          else
                            Text(m.isLive ? 'LIVE • In Progress' : 'Scheduled', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

