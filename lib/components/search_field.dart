import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchField extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? initialSearch;

  SearchField({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.initialSearch,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(54);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: TextField(
        controller: _controller,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
          // height: 1,
        ),
        decoration: InputDecoration(
          hintText: "البحث",
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          prefixIcon: Container(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/Icons/search.svg",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          contentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 8, 8),
          suffix: IconButton(
            onPressed: () {
              _controller.clear();
              widget.onSubmit?.call("");
            },
            style: IconButton.styleFrom(
              fixedSize: Size.square(16),
              iconSize: 16,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            icon: Icon(Icons.close),
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmit,
      ),
    );
  }
}
