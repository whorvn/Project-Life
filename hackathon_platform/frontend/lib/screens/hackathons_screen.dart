import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../widgets/loading_overlay.dart';
import '../models/hackathon.dart';
import 'hackathon_creator_screen.dart';
import 'hackathon_edit_screen.dart';
import 'landing_page_configurator_screen.dart';
import 'hackathon_landing_page_screen.dart';

class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  List<Hackathon> _getFilteredHackathons(List<Hackathon> hackathons) {
    var filtered = hackathons.where((hackathon) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!hackathon.title.toLowerCase().contains(query) &&
            !hackathon.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Apply status filter
      if (_selectedFilter == 'all') {
        return true;
      } else {
        return hackathon.status == _selectedFilter;
      }
    }).toList();

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonProvider>(
      builder: (context, hackathonProvider, child) {
        return LoadingOverlay(
          isLoading: hackathonProvider.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with create button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hackathons',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manage your hackathon events',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LandingPageConfiguratorScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.web),
                      label: const Text('Design Landing Page'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HackathonCreatorScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Hackathon'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Search and filters
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search hackathons...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'completed', child: Text('Completed')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Error handling
                if (hackathonProvider.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            hackathonProvider.error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            hackathonProvider.clearError();
                            hackathonProvider.loadHackathons();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                
                // Hackathons list
                Expanded(
                  child: _buildHackathonsList(
                    _getFilteredHackathons(hackathonProvider.hackathons),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHackathonsList(List<Hackathon> hackathons) {
    if (hackathons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No hackathons found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first hackathon to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: hackathons.length,
      itemBuilder: (context, index) {
        final hackathon = hackathons[index];
        return _buildHackathonCard(hackathon);
      },
    );
  }

  Widget _buildHackathonCard(Hackathon hackathon) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigate to hackathon details
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hackathon details coming soon!'),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hackathon.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hackathon.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusChip(hackathon.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Start: ${_formatDate(hackathon.startDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 24),
                  Icon(
                    Icons.event_available,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'End: ${_formatDate(hackathon.endDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HackathonLandingPageScreen(
                              hackathonId: hackathon.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.web, size: 16),
                      label: const Text('View Landing Page'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(hackathon, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'preview',
                        child: Row(
                          children: [
                            Icon(Icons.preview),
                            SizedBox(width: 8),
                            Text('Preview Landing Page'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy),
                            SizedBox(width: 8),
                            Text('Duplicate'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case 'draft':
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[700]!;
        label = 'Draft';
        break;
      case 'upcoming':
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue[700]!;
        label = 'Upcoming';
        break;
      case 'active':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green[700]!;
        label = 'Active';
        break;
      case 'completed':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange[700]!;
        label = 'Completed';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[700]!;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuAction(Hackathon hackathon, String action) {
    switch (action) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HackathonEditScreen(hackathon: hackathon),
          ),
        );
        break;
      case 'preview':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HackathonLandingPageScreen(
              hackathonId: hackathon.id,
            ),
          ),
        );
        break;
      case 'duplicate':
        // TODO: Implement duplication
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Duplication coming soon!'),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(hackathon);
        break;
    }
  }

  void _showDeleteConfirmation(Hackathon hackathon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hackathon'),
        content: Text(
          'Are you sure you want to delete "${hackathon.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await Provider.of<HackathonProvider>(
                context,
                listen: false,
              ).deleteHackathon(hackathon.id);
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hackathon deleted successfully'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
