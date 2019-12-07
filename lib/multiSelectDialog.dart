import 'package:flutter/material.dart';

/// We followed this tutorial to create the dialog for selecting allergens
/// https://medium.com/@KarthikPonnam/flutter-multi-select-choicechip-244ea016b6fa

class MultiSelectChip extends StatefulWidget {
  
  final List<String> allAllergens;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(
      this.allAllergens,
      {this.onSelectionChanged} 
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {

  List<String> selectedAllergens = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.allAllergens.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedAllergens.contains(item),
          onSelected: (selected) {
            setState(() {
              if (selectedAllergens.contains(item)){
                selectedAllergens.remove(item);
              }
              else{
                selectedAllergens.add(item);
              }
              widget.onSelectionChanged(selectedAllergens);
            });
          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}