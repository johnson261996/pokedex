import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

class PokemonMysterySheet extends StatefulWidget {
  const PokemonMysterySheet({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<PokemonMysterySheet> createState() => _PokemonMysterySheetState();
}

class _PokemonMysterySheetState extends State<PokemonMysterySheet> {
  final _repository = PokemonRepository();
  final _random = Random();
  TextEditingController? _fieldController;

  PokemonDetail? _pokemon;
  bool _isLoading = true;
  bool _showHint = false;
  bool _isSolved = false;
  int _attemptsLeft = 3;
  String? _message;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  Future<void> _startRound() async {
    setState(() {
      _isLoading = true;
      _showHint = false;
      _isSolved = false;
      _attemptsLeft = 3;
      _message = null;
      _fieldController?.clear();
    });

    try {
      final pokemon = await _repository.getPokemonDetail(
        (_random.nextInt(1025) + 1).toString(),
      );
      if (mounted) setState(() => _pokemon = pokemon);
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = 'Could not load a mystery Pokemon. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitGuess(String value) {
    final guess = value.trim().toLowerCase();
    final pokemon = _pokemon;
    if (pokemon == null || guess.isEmpty || _isSolved || _attemptsLeft == 0) {
      return;
    }

    if (guess == pokemon.name.toLowerCase()) {
      setState(() {
        _isSolved = true;
        _message = 'Correct! It is ${pokemon.name.capitalizeFirst}.';
      });
    } else {
      setState(() {
        _attemptsLeft--;
        _message =
            _attemptsLeft == 0
                ? 'So close - it was ${pokemon.name.capitalizeFirst}!'
                : 'Not quite. $_attemptsLeft ${_attemptsLeft == 1 ? 'attempt' : 'attempts'} left.';
      });
    }
    _fieldController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isComplete = _isSolved || _attemptsLeft == 0;

    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.fromLTRB(12, 48, 12, 12),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: _buildContent(theme, isComplete),
                ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isComplete) {
    final pokemon = _pokemon;
    if (pokemon == null) {
      return SizedBox(
        height: 260,
        child: Center(
          child: FilledButton.icon(
            onPressed: _startRound,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ),
      );
    }

    final solvedColor = theme.colorScheme.primaryContainer;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "WHO'S THAT POKEMON?",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'How to play',
                onPressed: _showInstructions,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Identify the Pokemon from its silhouette, pixels, or cry!',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 210,
          decoration: BoxDecoration(
            color: isComplete ? solvedColor : const Color(0xFFFFCB05),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 14,
                left: 16,
                child: _ClueChip(
                  icon: Icons.visibility_outlined,
                  label: isComplete ? 'Revealed' : 'Silhouette',
                ),
              ),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isComplete ? Colors.transparent : Colors.black,
                  isComplete ? BlendMode.dst : BlendMode.srcIn,
                ),
                child: Image.network(
                  pokemon.imageUrl,
                  height: 178,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) =>
                          const Icon(Icons.catching_pokemon, size: 120),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_showHint)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hint: ${pokemon.types.map((type) => type.name.capitalizeFirst).join(' / ')} type',
                  ),
                ),
              ],
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => setState(() => _showHint = true),
            icon: const Icon(Icons.lightbulb_outline),
            label: const Text('Show hint'),
          ),
        const SizedBox(height: 14),
        Text(
          '$_attemptsLeft of 3 attempts remaining',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 10),
        if (!isComplete) _buildGuessField() else _buildResultActions(),
        if (_message != null) ...[
          const SizedBox(height: 12),
          Text(
            _message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  _isSolved ? Colors.green.shade700 : theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGuessField() {
    return Autocomplete<String>(
      optionsBuilder: (text) {
        final query = text.text.trim().toLowerCase();
        if (query.isEmpty) return const Iterable<String>.empty();
        return widget.homeController.allPokemonList
            .map((pokemon) => pokemon.name)
            .where((name) => name.startsWith(query))
            .take(6);
      },
      onSelected: (selection) {
        _submitGuess(selection);
      },
      fieldViewBuilder: (context, textController, focusNode, onSubmitted) {
        _fieldController = textController;
        return TextField(
          controller: textController,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onSubmitted: _submitGuess,
          decoration: InputDecoration(
            hintText: 'Type your guess',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () => _submitGuess(textController.text),
              icon: const Icon(Icons.arrow_forward),
              tooltip: 'Submit guess',
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 280,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.catching_pokemon),
                    title: Text(option.capitalizeFirst ?? option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultActions() {
    return FilledButton.icon(
      onPressed: _startRound,
      icon: const Icon(Icons.refresh),
      label: const Text('New mystery Pokemon'),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              const Text('How to Play'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInstructionItem(
                  icon: Icons.visibility,
                  title: 'Identify the Pokemon',
                  description:
                      'Look at the silhouette or pixels of the mystery Pokemon.',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.lightbulb,
                  title: 'Use Hints',
                  description:
                      'Click "Show hint" to reveal the Pokemon\'s type.',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.edit,
                  title: 'Make Your Guess',
                  description:
                      'Type the Pokemon\'s name in the text field and submit your answer.',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  icon: Icons.check_circle,
                  title: 'Win the Round',
                  description:
                      'Guess correctly within 3 attempts to win and unlock the next mystery Pokemon!',
                  theme: theme,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClueChip extends StatelessWidget {
  const _ClueChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.72),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
