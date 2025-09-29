import 'package:flutter/material.dart';

class ChipsExampleScreen extends StatefulWidget {
  const ChipsExampleScreen({super.key});

  @override
  State<ChipsExampleScreen> createState() => _ChipsExampleScreenState();
}

class _ChipsExampleScreenState extends State<ChipsExampleScreen> {
  // For ChoiceChip - single selection
  int _selectedChoiceIndex = 0;

  // For FilterChip - multiple selection
  final List<bool> _filterSelections = [false, false, false, false];

  // For InputChip - dynamic list with deletion
  final List<String> _inputChipData = [
    'Flutter',
    'Dart',
    'Mobile Dev',
    'UI/UX',
  ];

  // For ActionChip tracking
  int _actionCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chips Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chip Section
            _buildSectionTitle(
              '1. Basic Chip',
              'Displays information, can be deleted',
            ),
            _buildChipSection(),

            const SizedBox(height: 24),

            // InputChip Section
            _buildSectionTitle(
              '2. InputChip',
              'Interactive chips with selection and deletion',
            ),
            _buildInputChipSection(),

            const SizedBox(height: 24),

            // ChoiceChip Section
            _buildSectionTitle(
              '3. ChoiceChip',
              'Single selection from multiple options',
            ),
            _buildChoiceChipSection(),

            const SizedBox(height: 24),

            // FilterChip Section
            _buildSectionTitle(
              '4. FilterChip',
              'Multiple selections for filtering content',
            ),
            _buildFilterChipSection(),

            const SizedBox(height: 24),

            // ActionChip Section
            _buildSectionTitle(
              '5. ActionChip',
              'Triggers actions when pressed',
            ),
            _buildActionChipSection(),

            const SizedBox(height: 32),

            // Summary Card
            _buildSummaryCard(),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to proceed?'),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      OverflowBar(
                        spacing: 12.0,
                        overflowSpacing: 8.0,
                        alignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: Text("Overflow button"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // 1. Basic Chip - Display information with optional delete
  Widget _buildChipSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            Chip(
              label: const Text('Basic Chip'),
              avatar: const Icon(Icons.info, size: 20),
              backgroundColor: Colors.blue.shade100,
              labelStyle: const TextStyle(color: Colors.blue),
            ),
            Chip(
              label: const Text('With Delete'),
              avatar: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 12,
                child: const Text(
                  'D',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              onDeleted: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Chip deleted!')));
              },
              backgroundColor: Colors.green.shade100,
              deleteIconColor: Colors.red,
            ),
            Chip(
              label: const Text('Custom Styled'),
              backgroundColor: Colors.purple.shade100,
              labelStyle: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.purple.shade300),
              ),
              elevation: 4,
            ),
          ],
        ),
      ),
    );
  }

  // 2. InputChip - Interactive chips with selection and deletion
  Widget _buildInputChipSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tap to select, use X to delete:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _inputChipData.map((String skill) {
                return InputChip(
                  label: Text(skill),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      skill[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  selected: skill == 'Flutter',
                  // Flutter is pre-selected
                  onSelected: (bool selected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$skill ${selected ? "selected" : "deselected"}',
                        ),
                      ),
                    );
                  },
                  onDeleted: () {
                    setState(() {
                      _inputChipData.remove(skill);
                    });
                  },
                  selectedColor: Colors.orange.shade200,
                  backgroundColor: Colors.orange.shade50,
                  checkmarkColor: Colors.orange.shade700,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _inputChipData.add('New Skill ${_inputChipData.length + 1}');
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Skill'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. ChoiceChip - Single selection
  Widget _buildChoiceChipSection() {
    List<String> priorities = ['Low', 'Medium', 'High', 'Critical'];
    List<Color> priorityColors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Task Priority (single selection):',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List<Widget>.generate(priorities.length, (int index) {
                return ChoiceChip(
                  label: Text(priorities[index]),
                  selected: _selectedChoiceIndex == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChoiceIndex = selected ? index : 0;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Priority set to: ${priorities[index]}'),
                      ),
                    );
                  },
                  selectedColor: priorityColors[index].withValues(alpha: 0.3),
                  backgroundColor: Colors.grey.shade100,
                  avatar: _selectedChoiceIndex == index
                      ? Icon(
                          Icons.check_circle,
                          size: 20,
                          color: priorityColors[index],
                        )
                      : Icon(
                          Icons.circle_outlined,
                          size: 20,
                          color: priorityColors[index],
                        ),
                  labelStyle: TextStyle(
                    color: _selectedChoiceIndex == index
                        ? priorityColors[index]
                        : Colors.grey[700],
                    fontWeight: _selectedChoiceIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: priorityColors[_selectedChoiceIndex].withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: priorityColors[_selectedChoiceIndex].withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.priority_high,
                    color: priorityColors[_selectedChoiceIndex],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Priority: ${priorities[_selectedChoiceIndex]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: priorityColors[_selectedChoiceIndex],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. FilterChip - Multiple selections
  Widget _buildFilterChipSection() {
    List<String> categories = ['Technology', 'Design', 'Business', 'Marketing'];
    List<IconData> categoryIcons = [
      Icons.computer,
      Icons.palette,
      Icons.business,
      Icons.campaign,
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Content by Category (multiple selection):',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List<Widget>.generate(categories.length, (int index) {
                return FilterChip(
                  label: Text(categories[index]),
                  selected: _filterSelections[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _filterSelections[index] = selected;
                    });
                  },
                  avatar: Icon(categoryIcons[index], size: 20),
                  selectedColor: Colors.teal.shade200,
                  checkmarkColor: Colors.teal.shade700,
                  backgroundColor: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (_filterSelections.any((selected) => selected)) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Filters:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSelectedFilters(categories),
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: const Text(
                        'No filters applied - showing all content',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 5. ActionChip - Trigger actions
  Widget _buildActionChipSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action Chips (tap to perform actions):',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ActionChip(
                  label: const Text('Download'),
                  avatar: const Icon(Icons.download, size: 20),
                  onPressed: () {
                    _showActionDialog(
                      'Download',
                      'File downloaded successfully!',
                    );
                  },
                  backgroundColor: Colors.green.shade100,
                  labelStyle: const TextStyle(color: Colors.green),
                ),
                ActionChip(
                  label: const Text('Share'),
                  avatar: const Icon(Icons.share, size: 20),
                  onPressed: () {
                    _showActionDialog('Share', 'Content shared successfully!');
                  },
                  backgroundColor: Colors.blue.shade100,
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
                ActionChip(
                  label: Text('Increment ($_actionCount)'),
                  avatar: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    setState(() {
                      _actionCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Counter incremented to $_actionCount'),
                      ),
                    );
                  },
                  backgroundColor: Colors.purple.shade100,
                  labelStyle: const TextStyle(color: Colors.purple),
                ),
                ActionChip(
                  label: const Text('Settings'),
                  avatar: const Icon(Icons.settings, size: 20),
                  onPressed: () {
                    _showActionDialog('Settings', 'Opening settings...');
                  },
                  backgroundColor: Colors.orange.shade100,
                  labelStyle: const TextStyle(color: Colors.orange),
                  elevation: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Chips Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'Basic Chip',
              'Display information, optional delete functionality',
            ),
            _buildSummaryItem(
              'InputChip',
              'Interactive with selection and deletion capabilities',
            ),
            _buildSummaryItem(
              'ChoiceChip',
              'Single selection from multiple options',
            ),
            _buildSummaryItem(
              'FilterChip',
              'Multiple selections for content filtering',
            ),
            _buildSummaryItem(
              'ActionChip',
              'Triggers specific actions when pressed',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedFilters(List<String> categories) {
    List<String> selected = [];
    for (int i = 0; i < _filterSelections.length; i++) {
      if (_filterSelections[i]) {
        selected.add(categories[i]);
      }
    }
    return selected.join(', ');
  }

  void _showActionDialog(String action, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
