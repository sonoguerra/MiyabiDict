import 'package:flutter/material.dart';

var words = [
      'flavio',
      'paolo',
      'mario',
      'luca',
      'claudio',
      'renato',
    ]; //TODO implement real saved list

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});

  @override
  State<StatefulWidget> createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        return _HoverIconButton(index: index);
      },
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  final int index;

  const _HoverIconButton({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(words[widget.index]),
      leading: MouseRegion(
        onEnter: (event) => setState(() => _isHovered = true),
        onExit: (event) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(_isHovered ? Icons.bookmark_remove : Icons.bookmark),
          onPressed: () {
            setState(() {
              words.removeAt(widget.index);
            });
          },
        ),
      ),
      tileColor:
          (widget.index % 2 == 0) //TODO: change colors
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondary,
    );
  }
}
