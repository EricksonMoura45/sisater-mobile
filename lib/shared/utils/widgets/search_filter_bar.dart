import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class SearchFilterBar extends StatefulWidget {
  final String searchHint;
  final VoidCallback? onFilterPressed;
  final Function(String)? onSearchChanged;
  final Duration debounceDuration;
  final String? filterButtonText;
  final IconData? filterIcon;

  const SearchFilterBar({
    super.key,
    this.searchHint = 'Buscar...',
    this.onFilterPressed,
    this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.filterButtonText = 'Filtros',
    this.filterIcon,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final Debouncer debouncer = Debouncer();

  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          if (widget.onFilterPressed != null) ...[
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Themes.verdeBotao,
                side: BorderSide(color: Themes.verdeBotao, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: Icon(widget.filterIcon ?? Icons.tune, size: 20),
              label: Text(widget.filterButtonText!),
              onPressed: widget.onFilterPressed,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: Icon(Icons.search, color: Themes.cinzaTexto),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (termo) {
                  if (widget.onSearchChanged != null) {
                    debouncer.debounce(
                      duration: widget.debounceDuration,
                      onDebounce: () {
                        widget.onSearchChanged!(termo);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 