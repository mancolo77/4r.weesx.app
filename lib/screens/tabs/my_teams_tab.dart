import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_overview_service.dart';
import '../widgets/cricket_detail_sheet.dart';

class MyTeamsTab extends StatefulWidget {
  const MyTeamsTab({super.key});

  @override
  State<MyTeamsTab> createState() => _MyTeamsTabState();
}

class _MyTeamsTabState extends State<MyTeamsTab> {
  final CricketOverviewService _service = CricketOverviewService();

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
    final favTeams = _service.favTeams.toList();
    final allTeams = _service.allTeams;

    // Matches involving favorite teams
    final teamMatches = _service.matches.where((m) => favTeams.contains(m.teamA) || favTeams.contains(m.teamB)).toList();
    final upcoming = teamMatches.where((m) => m.date == 'Tomorrow' || (m.date == 'Today' && !m.isLive && m.scoreA == null)).toList();
    final history = teamMatches.where((m) => m.scoreA != null).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('My Teams', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Your Teams', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allTeams.map((team) {
                final isFav = favTeams.contains(team);
                return FilterChip(
                  label: Text(team),
                  selected: isFav,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.darkNav,
                  labelStyle: TextStyle(color: isFav ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => _service.toggleFavoriteTeam(team),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (favTeams.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Column(
                  children: [
                    Icon(Icons.shield_outlined, size: 48, color: AppTheme.textSecondary),
                    SizedBox(height: 12),
                    Text('Select teams above to track their fixtures & results.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              )
            else ...[
              // Upcoming Fixtures
              const Text('Upcoming Fixtures', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (upcoming.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.darkNav, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  child: const Text('No upcoming games scheduled for your teams right now.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                )
              else
                ...upcoming.map((m) => Card(
                      color: AppTheme.surfaceCard,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                      child: ListTile(
                        onTap: () => showCricketMatchDetails(context, m),
                        title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Text('${m.date} at ${m.timeIST} • ${m.venue}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primary),
                      ),
                    )),
              const SizedBox(height: 24),

              // Match History
              const Text('Recent Results & History', style: TextStyle(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (history.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.darkNav, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  child: const Text('No past games found for selected teams.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                )
              else
                ...history.map((m) => Card(
                      color: AppTheme.surfaceCard,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                      child: ListTile(
                        onTap: () => showCricketMatchDetails(context, m),
                        title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Text('${m.summary}\n${m.scoreA} vs ${m.scoreB}', style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12)),
                        isThreeLine: true,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
                      ),
                    )),
            ],
          ],
        ),
      ),
    );
  }
}

