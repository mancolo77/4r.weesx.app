import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_overview_service.dart';
import '../widgets/cricket_detail_sheet.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  final CricketOverviewService _service = CricketOverviewService();
  String _selectedDate = 'Today';
  String _formatFilter = 'All';

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
    final heroMatch = _service.getHeroMatch();
    var dayMatches = _service.matches.where((m) => m.date == _selectedDate).toList();

    if (_formatFilter != 'All') {
      dayMatches = dayMatches.where((m) => m.format == _formatFilter).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cricket Match Day', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('IST Timezone • Updated ${_service.lastUpdated.hour.toString().padLeft(2, '0')}:${_service.lastUpdated.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Demo', style: TextStyle(color: Color(0xFF0B1928), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _service.refresh,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Match Card
              if (heroMatch != null) ...[
                const Text('Featured Match', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildHeroCard(context, heroMatch),
                const SizedBox(height: 20),
              ],

              // Horizontal Date Ribbon
              Row(
                children: ['Yesterday', 'Today', 'Tomorrow'].map((d) {
                  final isSel = _selectedDate == d;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => setState(() => _selectedDate = d),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSel ? AppTheme.primary : AppTheme.darkNav,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 42),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                        ),
                        child: Text(d, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Format chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'T20', 'ODI', 'Test'].map((f) {
                    final isSel = _formatFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: isSel,
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.darkNav,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _formatFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Match Day List
              Text('$_selectedDate\'s Fixtures', style: const TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (dayMatches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  child: const Center(
                    child: Text('No matches scheduled for this filter.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ),
                )
              else
                ...dayMatches.map((m) => _buildCompactMatchCard(context, m)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, CricketMatchDetail match) {
    final isFav = _service.favMatchIds.contains(match.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        side: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => showCricketMatchDetails(context, match),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
                    child: Text('${match.format} • ${match.tournament}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Row(
                    children: [
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(6)),
                          child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavoriteMatch(match.id),
                        child: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.accentYellow : AppTheme.textSecondary, size: 26),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(match.teamA, style: const TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(match.teamB, style: const TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(match.scoreA != null ? '${match.scoreA} ${match.oversA ?? ""}' : match.timeIST, style: const TextStyle(color: AppTheme.primary, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(match.scoreB != null ? '${match.scoreB} ${match.oversB ?? ""}' : 'Upcoming', style: const TextStyle(color: AppTheme.primary, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 24),
              Text(match.summary, style: const TextStyle(color: AppTheme.accentYellow, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Stadium: ${match.venue}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactMatchCard(BuildContext context, CricketMatchDetail match) {
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () => showCricketMatchDetails(context, match),
        title: Text('${match.teamA} vs ${match.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('${match.format} • ${match.timeIST} • ${match.status}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        trailing: Text(match.scoreA != null ? '${match.scoreA}' : 'Upcoming', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }
}

