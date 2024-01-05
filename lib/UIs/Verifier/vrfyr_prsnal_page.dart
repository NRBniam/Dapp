/*import 'package:flutter/material.dart';

class EditableTextToggle extends StatefulWidget {
  @override
  _EditableTextToggleState createState() => _EditableTextToggleState();
}

class _EditableTextToggleState extends State<EditableTextToggle> {
  TextEditingController _controller = TextEditingController();
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/certychainlogo.png',
            width: 150,
            height: 100,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                // Toggle the editable state
                isEditable = !isEditable;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isEditable
                ? TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your text',
                    ),
                  )
                : Text(
                    _controller.text,
                    style: TextStyle(fontSize: 16.0),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
*/
