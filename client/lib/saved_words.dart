import 'package:flutter/material.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});

  @override
  State<StatefulWidget> createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {
  List words = List.generate(100, (index) {
    return "Word #$index";
  }); //TODO implement real saved list

  void _handleTileDeleted(int indexToRemove) {
    setState(() {
      words.removeAt(indexToRemove); //TODO: animations
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        return _HoverIconButton(index: index, onChanged: _handleTileDeleted, text: words[index]);
      },
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  const _HoverIconButton({super.key, required this.index, required this.onChanged, required this.text});

  final int index;
  final ValueChanged<int> onChanged;
  final String text;
  
  @override
  State<StatefulWidget> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovered = false;
  
  void _handleTap() {
    widget.onChanged(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.text),
      leading: MouseRegion(
        onEnter: (event) => setState(() => _isHovered = true),
        onExit: (event) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(_isHovered ? Icons.bookmark_remove : Icons.bookmark),
          onPressed: () => _handleTap(),
        ),
      ),
      tileColor:
          (widget.index % 2 == 0) //TODO: change colors
              ? Theme.of(context).colorScheme.secondary
              : Colors.white,
    );
  }
}